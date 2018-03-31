/*
 * @(#)MultiLabServer.java
 *
 * Istanzia un server singolo per ogni utente collegato
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XII/30
 */

import java.util.*;
import java.io.*;
import java.net.*;

public class MultiLabServer extends Thread {
	private DataManager myDM;
	
	private Socket sok = null;
	ServerSocket sersok1 = null;	// Uguale per tutti (richieste)

	// Costruttore attiva sersok1
	public MultiLabServer() {
		super("LabServer");
		try {
			sersok1 = new ServerSocket(6666);
			System.out.print("LabServer in ascolto sulla porta ");
			System.out.println(sersok1.getLocalPort());
		} catch (IOException e) {
			System.err.println("Impossibile attivare il LabServer");
		}
		myDM = new DataManager();
	}

	// Metodo run() del Thread attiva un sersok2 per ogni richiesta
	public void run() {
		try {
			if (sersok1!=null) {

				// Cicla all'infinito attendendo nuove connessioni
				while (true) {
						sok = sersok1.accept();
						ServerSocket sersok2 = new ServerSocket(0,1);
						new SingleLabServer(sersok2).start();
						byte port[] = myDM.longToTwoBytes
							((long)sersok2.getLocalPort());
						sendBytes(port);
						sok.close();
						sersok1.close();
						sersok1 = new ServerSocket(6666);
						System.out.print("LabServer in ascolto sulla porta ");
						System.out.println(sersok1.getLocalPort());			
				}
			} else {
				sersok1 = new ServerSocket(6666);
				System.out.print("LabServer in ascolto sulla porta ");
				System.out.println(sersok1.getLocalPort());
			}
		} catch (IOException e) { }
	}

	// Metodo finalize() del Thread (per garbage collection)
	protected void finalize() {
		if (sok!=null) try {
//			sok.close();
			System.out.println("Vorrei chiudere il socket "+sok.getLocalPort());
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
}