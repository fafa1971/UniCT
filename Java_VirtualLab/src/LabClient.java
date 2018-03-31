/*
 * @(#)LabClient.java
 *
 * Classe usata dall'applet per comunicare col LabServer
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XI/7
 */

import java.awt.*;
import java.net.*;
import java.io.*;

public class LabClient {
	// Classi di supporto private per gestione dati e cifratura
	private DataManager myDM;
	private CryptographyLibrary myCL;
	private long Session,Ticket;

	// Classi e variabili pubbliche
	public VirtualLab myBoss;        
	public Socket sok;
	public byte buffer[] = new byte[1024];
	public int myPort;
	
	// Usato dal protocollo ContinuousFlow
	private String lastRequest[];

	// Costruttore apre il socket
	public LabClient(VirtualLab myIncomingBoss) {
		myBoss = myIncomingBoss;
		myDM = new DataManager();
		myCL = new CryptographyLibrary();

		System.out.println("Inizializzo connessione col server...");

		// Apre la connessione con il MultiLabServer sulla porta 6666
		try {
			sok=new Socket( InetAddress.getByName
				(myBoss.getCodeBase().getHost()),6666 );
		} catch (IOException e) { }

		if (sok!=null) {
			System.out.println("Connected to MultiLabServer:6666");
		} else {
			System.out.println("NOT connected to MultiLabServer:6666");
		}

		// Riceve il numero di porta privato del SingleLabServer
		myPort = (int)myDM.twoBytesToLong(receiveBytes());
		try {
			sok=new Socket( InetAddress.getByName
				(myBoss.getCodeBase().getHost()), myPort );
		} catch (IOException e) { }

		if (sok!=null) {
			System.out.println("Connected to SingleLabServer:"+myPort);
		} else {
			System.out.println("NOT connected to SingleLabServer:"+myPort);
		}
	}

	// Invia String[] al server
	public void sendStrings(String data[]) {
		if (sok!=null) try {
			OutputStream outstream;
			outstream=sok.getOutputStream();
			outstream.write(myDM.packStringsIntoBytes(data));
		} catch (IOException e) { }
	}

	// Invia String[] al server con cifratura DES
	public void sendStrings(String data[], long session, long ticket) {
		if (sok!=null) try {
			OutputStream outstream;
			outstream=sok.getOutputStream();
			outstream.write( myCL.DESencryptCBC(
				myDM.packStringsIntoBytes(data),
				myDM.longToEightBytes(session),
				myDM.longToEightBytes(ticket) ) );
		} catch (IOException e) { }
	}

	// Invia byte[] al server
	public void sendBytes(byte data[]) {
		if (sok!=null) try {
			OutputStream outstream;
			outstream=sok.getOutputStream();
			outstream.write(data);
		} catch (IOException e) { }
	}

	// Riceve String[] dal server
	public String[] receiveStrings() {
		String incomingData[] = null;

		if (sok!=null) try {
			InputStream instream;
			instream = sok.getInputStream();
			instream.read(buffer);
			incomingData = myDM.unpackStringsFromBytes(buffer);
		} catch (IOException e) { }
	
		return incomingData;
	}

	// Riceve String[] dal server con cifratura DES
	public String[] receiveStrings(long session, long ticket) {
		String incomingData[] = null;

		if (sok!=null) try {
			InputStream instream;
			instream = sok.getInputStream();
			instream.read(buffer);
			incomingData = myDM.unpackStringsFromBytes(
				myCL.DESdecryptCBC(buffer,
				myDM.longToEightBytes(session),
				myDM.longToEightBytes(ticket) ) );
		} catch (IOException e) { }
	
		return incomingData;
	}

	// Riceve byte[] dal server
	public byte[] receiveBytes() {
		byte incomingData[] = null;
		int count;

		if (sok!=null) try {
			InputStream instream;
			instream = sok.getInputStream();
			count = instream.read(buffer);
			if (count!=-1) {
				incomingData = new byte[count];
				System.arraycopy(buffer,0,incomingData,0,count);
			}
		} catch (IOException e) { }
	
		return incomingData;
	}

	// Chiude la connessione
	public void close() {
		if (sok!=null) try {
			sok.close();
			sok = null;
		} catch (IOException e) { }
	}

	// Gestisce il protocollo di autenticazione
	public boolean[] Authentication(String leavingData[]) {
		String inStrings[], outStrings[];
		byte inBytes[], outBytes[];	
		boolean accessArray[] = null;
		
		if (sok != null) {
			// Invia richiesta di connessione
			outStrings = new String[1];
			outStrings[0] = "connect";
			sendStrings(outStrings);

			// Riceve in chiaro chiave pubblica dell'algoritmo RSA
			inBytes = receiveBytes();
			byte temp[] = new byte[3];
			System.arraycopy(inBytes,0,temp,0,3);
			long n = myDM.threeBytesToLong(temp);
			System.arraycopy(inBytes,3,temp,0,3);
			long e = myDM.threeBytesToLong(temp);

			// Genera, cifra RSA ed invia chiave di sessione
			long session = (long)(Math.random()*(double)Long.MAX_VALUE);
			if (Math.random()>0.5) session = session*(-1);
			sendBytes(myCL.RSAencrypt(myDM.longToEightBytes(session),n,e));

			// Da questo momento uso l'algoritmo DES con la chiave
			// di sessione per tutte le comunicazioni

			// Riceve il ticket di identificazione
			long ticket = myDM.eightBytesToLong
				( myCL.DESencryptECB(receiveBytes(),
					myDM.longToEightBytes(session)) );

			// Memorizza chiave e IV in variabili globali
			// (per farli usare poi ai protocolli)
			Session = session;
			Ticket = ticket;

			// spedisco userName e cryptedPassword
			sendStrings(leavingData,session,ticket);

			// ricevo i permessi
			inStrings = receiveStrings(session,ticket);
			
			// qui la stringa ricevuta va decifrata
			accessArray = myDM.stringToBooleans(inStrings[0]);
		}
		return accessArray;
	}

	// Gestisce il protocollo Request/Reply
	public String[] RequestReply(String request[]) {
		if (request == null) return null;
		
		String reply[] = null;
		
		if (sok != null) {
			// spedisco la richiesta
			sendStrings(request,Session,Ticket);

			// ricevo la risposta
			reply = receiveStrings(Session,Ticket);
		}
		return reply;
	}

	// Gestisce il protocollo Continuous Flow
	public String[] ContinuousFlow(String request[]) {
		String reply[] = null;
		boolean idem = true;
		
		if (request == null) return null;

		// Controllo se e' la stessa richiesta precedente
		if (request!=null && lastRequest!=null &&
			request.length==lastRequest.length) {
			for (int i=0; i<request.length; i++)
				if (!request[i].equals(lastRequest[i])) idem = false;

			// E' la stessa richiesta precedente -> solo reply
			if (idem) {
				if (sok != null) {
					// ricevo la risposta
					reply = receiveStrings(Session,Ticket);
				}
			// Nuova richiesta
			} else {
				// Conservo richiesta attuale
				lastRequest = new String[request.length];
				System.arraycopy(request,0,lastRequest,0,request.length);
				
				if (sok != null) {
					// spedisco la richiesta
					sendStrings(request,Session,Ticket);

					// ricevo la risposta
					reply = receiveStrings(Session,Ticket);
				}
			}
		// Nuova richiesta
		} else {
			// Conservo richiesta attuale
			lastRequest = new String[request.length];
			System.arraycopy(request,0,lastRequest,0,request.length);
				
			if (sok != null) {
				// spedisco la richiesta
				sendStrings(request,Session,Ticket);

				// ricevo la risposta
				reply = receiveStrings(Session,Ticket);
			}
		}
		return reply;
	}
}
