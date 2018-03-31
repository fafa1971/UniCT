/*
 * @(#)SingleLabServer.java
 *
 * Singolo thread del server per gestire i protocolli
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XI/9
 */

import java.net.*;
import java.io.*;
import java.util.Date;

public class SingleLabServer extends Thread {
	// Classi di supporto per gestione dati e cifratura
	private DataManager	myDM;
	private CryptographyLibrary myCL;
	private LabSecurityManager myLSM;

	// Classi per la trasmissione sulla rete
	private static ServerSocket sersok;
	private static Socket sok;
	private static byte buffer[] = new byte[1024];

	// Variabili private
	private int port;
	private boolean protocol = false;	// solitamente Request/Reply
	private String userName, cryptedPassword;

	// Inizializza il server su una porta privata
	public SingleLabServer(ServerSocket mysersok) {
		super();

		sersok = mysersok;
		port = mysersok.getLocalPort();
		System.out.println("SingleLabServer in ascolto sulla porta "+port);
		
		myDM = new DataManager();
		myCL = new CryptographyLibrary();
		myLSM = new LabSecurityManager();
	}

	// Metodo run() serve le richieste dei client
	public void run() {
		String inStrings[], outStrings[];
		byte inBytes[], outBytes[];
		FileManager myFile = null;
		
		try {
			try {
				// Accetta la richiesta di un client
				sok = sersok.accept();

				// Riceve richiesta di connessione in chiaro
				inStrings = receiveStrings();
				if (inStrings==null) close();
				else if (inStrings.length==1 &&
					inStrings[0].equals("connect")) {

					// L'algoritmo RSA viene usato per lo scambio della
					// chiave di sessione
				
					// Avvia RSA ed invia chiave pubblica (n,e) in chiaro
					long keys[] = myCL.RSAstart();
					long n = keys[0];
					long e = keys[1];
					long d = keys[2];
					outBytes = new byte[6];
					System.arraycopy(myDM.longToThreeBytes(n),0,outBytes,0,3);
					System.arraycopy(myDM.longToThreeBytes(e),0,outBytes,3,3);
					sendBytes(outBytes);

					// Riceve chiave di sessione e la decifra con RSA
					long session = myDM.eightBytesToLong
						(myCL.RSAdecrypt(receiveBytes(),n,d));
					
					// Da questo momento tutte le comunicazioni sono cifrate
					// usando il DES e la chiave di sessione
				
					// Genera ed invia il ticket da usare come identificatore
					long ticket = (long)(Math.random()*(double)Long.MAX_VALUE);
					if (Math.random()>0.5) ticket = ticket*(-1);
					sendBytes(myCL.DESencryptECB(myDM.longToEightBytes(ticket),
						myDM.longToEightBytes(session)));

					// Riceve UserName e Password cifrate
					inStrings = receiveStrings(session,ticket);
					userName = new String(inStrings[0]);
					cryptedPassword = new String(inStrings[1]);

					// Autentica l'utente e manda autorizzazioni
					String access = myLSM.getAccesses(userName,cryptedPassword);
					String accesses[] = { new String(access) };
					sendStrings(accesses,session,ticket);

					// Protocollo Request/Reply o Continuous Flow
					while (true) {
						// Riceve ed esegue comando
						inStrings = receiveStrings(session,ticket);

						if ( myLSM.checkAccess(userName,inStrings[0]) &&
							myLSM.checkCommand(inStrings) ) {

							System.out.println("Eseguo : "+inStrings[0]);
							ExecutionThread myET = new ExecutionThread(inStrings[0]);

							// Aggiorno la User History (file 'history')
							String toAdd[] = new String[inStrings.length+2];
							toAdd[0] = new String(userName);
							toAdd[1] = new String( ( new Long(
								((new Date()).getTime()) )).toString());
							System.arraycopy(inStrings,0,toAdd,2,inStrings.length);
							myFile = new FileManager("data/history","rw");
							myFile.addRecord(toAdd);
							myFile.close();

//							inStrings = null;	// ?

							// Manda i risultati della operazione remota
							outStrings = myET.getExecutionResponse();
							sendStrings(outStrings,session,ticket);
//							outStrings = null;	// ?
						} else {
							System.out.println("Ricevuta richiesta non sicura.");
							close();
						}
					}			
				} else {
					System.out.println("Connect non ricevuto");
					close();
				}
			} catch (IOException e) { }
		} catch (Exception n) { }
	}

	// Chiude la singola connessione
	private void close() throws IOException {
		if (sok!=null) {
			sok.close();
			sok = null;
		}
	}

	// Invia String[] al client
	public void sendStrings(String data[]) {
		if (sok!=null) try {
			OutputStream outstream;
			outstream=sok.getOutputStream();
			outstream.write(myDM.packStringsIntoBytes(data));
		} catch (IOException e) { }
	}

	// Invia String[] al client con cifratura DES
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

	// Invia byte[] al client
	public void sendBytes(byte data[]) {
		if (sok!=null) try {
			OutputStream outstream;
			outstream=sok.getOutputStream();
			outstream.write(data);
		} catch (IOException e) { }
	}

	// Riceve String[] dal client
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

	// Riceve String[] dal client con cifratura DES
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

	// Riceve byte[] dal client
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
}
