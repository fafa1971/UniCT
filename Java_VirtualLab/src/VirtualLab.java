/*
 * @(#)VirtualLab.java
 *
 * Applet che implementa il lato client del Virtual Lab
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/X/29
 */

import java.applet.*;
import java.awt.*;

public class VirtualLab extends Applet implements Runnable {
	
	// Supporto per animazione richiede thread multipli	
	Thread	myLabThread = null;					// Thread del laboratorio
	AnimationThread	myAnimationThread = null;	// Thread per l'animazione
	
	// Variabili dell'AnimationThread
	public Graphics VL_Graphics;
	public Image VL_Images[];
	public int VL_CurrImageNo;
	public int VL_ImgWidth = 0;
	public int VL_ImgHeight = 0;
	public boolean VL_AllLoaded = false;
	public final int NUM_IMAGES = 18;

	// Bottone per il login
	private Button buttonLogin;

	// Variabili per sincronizzare i vari thread
	public boolean LoginDialogActive = false;	// On=this, Off=dialog
	public boolean LoginOKPressed = false;		// On=dialog, Off=this
	public String executionCommand = null;
	public boolean executionCanStart = false;	// On=input, Off=this

	// Classi di supporto
	public LoginDialog myLoginDialog = null;
	public LabResources myResources = null;
	public LabClient myClient = null;

	public Frame myLoginDialogFrame = null;
	public LabResourcesFrame myResourcesFrame = null;
	public InputFrame myInputFrame = null;
	public OutputFrame myOutputFrame = null;

	// Variabili utilizzate per memorizzare info riservate
	public String userName = new String();
	private String cryptedPassword = new String();
	
	// Restituisce info dell'applet
	public String getAppletInfo() {
		return "Name: VirtualLab 1.0\r\n\n" +
		       "Author: Fabrizio Fazzino\r\n" +
		       "E-mail: ffazzino@k200.cdc.unict.it\r\n\n" +
		       "Designed by the IIT of the University of Catania\r\n" +
		       "From an idea of O.Mirabella & A.Di Stefano\r\n" +
		       "With the help of L.Lo Bello\r\n\n" +
		       "Release version January 1997";
	}

	// Inizializza applet aggiungendo bottone per login
	public void init() {
		buttonLogin = new Button("Login");
		add(buttonLogin);

		resize(320, 240);
	}

	// Controlla se viene premuto il bottone di login
	public boolean action(Event e, Object arg) {
		if (e.target instanceof Button && arg.equals("Login")) {
			if(!LoginDialogActive) {
				LoginDialogActive = true;

				myLoginDialogFrame = new Frame();
				myLoginDialog = new LoginDialog(this);
			}
		}
		return true;
	}

	// Avvia l'esecuzione dell'applet
	public void start() {
		if (myLabThread == null) {
			myLabThread = new Thread(this);
//			myLabThread.setPriority(Thread.MAX_PRIORITY);
			myLabThread.start();
		}
		if (myAnimationThread == null) {
			myAnimationThread = new AnimationThread(this);
//			myAnimationThread.setPriority(6);
			myAnimationThread.start();
		}
	}
	
	// Ferma l'esecuzione dell'applet
	public void stop() {
		if (myLabThread != null) {
			myLabThread.stop();
			myLabThread = null;
		}
		if (myAnimationThread != null) {
			myAnimationThread.stop();
			myAnimationThread = null;
		}
	}

	// Visualizza messaggio attesa caricamento oppure fotogramma
	public void paint(Graphics g) {
		if (VL_AllLoaded) {
			Rectangle r = g.getClipRect();	
			g.clearRect(r.x, r.y, r.width, r.height);
			displayImage(g);
		}
		else
			g.drawString("Loading images...", 10, 20);
	}

	// Visualizza uno dei fotogrammi dell'animazione
	public void displayImage(Graphics g) {
		if (!VL_AllLoaded) return;

		g.drawImage(VL_Images[VL_CurrImageNo], 
				   (size().width - VL_ImgWidth)   / 2,
				   (size().height - VL_ImgHeight) / 2, null);
	}

	// Aggiorna il numero dei fotogrammi caricati
	public boolean imageUpdate(Image img, int flags, int x, int y, int w, int h) {
		if(VL_AllLoaded) return false;

		if ((flags & ALLBITS)==0) return true;

		if (++VL_CurrImageNo == NUM_IMAGES) {
			VL_CurrImageNo = 0;
			VL_AllLoaded = true;
		}				

		return false;
	}

	// Gestisce le operazioni del VirtualLab sulla base
	// dello stato delle variabili di sincronizzazione
	public void run() {
		repaint();

		// Il ciclo seguente viene ripetuto all'infinito
		while (true) {
			try {
				// Leggo lo stato e svolgo tutte le operazioni

				// Utente ha riempito il pannello di login
				if(LoginOKPressed) {
					LoginOKPressed = false;

					// Inizializzo connessione ed autenticazione
					myClient = new LabClient(this);
					String data[] = new String[2];
					data[0] = new String(userName);
					data[1] = new String(cryptedPassword);
					boolean access[] = myClient.Authentication(data);

					// Ricevo permessi e visualizzo risorse
					if (access!=null && access.length>0) {
						myResources = new LabResources(access);
						myResourcesFrame = new LabResourcesFrame(this);
					} else {
						System.out.println("Accessi non ricevuti");
					}

					// Può essere avviata la simulazione
					while(true) {
						if(executionCanStart) {
							executionCanStart = false;
							
							// Viene avviato protocollo Request/Reply
							String commands[] =
								{ new String(executionCommand) };
							String results[] =
								myClient.RequestReply(commands);
							if(results==null) {
								System.out.println("VL.run fallito");
							} else {
								for (int zx=0; zx<results.length; zx++) {
									System.out.println(results[zx]);
								}
								myOutputFrame.ShowInterface(results);
							}
						}
					}
				}
			} catch (InterruptedException e) {
				stop();
			}
		}
	}
 
	// Usato per settare le variabili riservate
	public void setInfo(String un, String cp) {
		userName = new String(un);
		cryptedPassword = new String(cp);
	}

}
