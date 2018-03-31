/*
 * @(#)LabResourcesFrame.java
 * 
 * Finestra per scegliere una delle risorse accessibili
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XI/19
 */

import java.awt.*;

public class LabResourcesFrame extends Frame {
	private VirtualLab myBoss;
	
	private GridBagLayout myGrid = new GridBagLayout();
	private GridBagConstraints myGridPos = new GridBagConstraints();
	private Label myLabel1 = new Label();
	private Label myLabel2 = new Label();
	private Label myLabel3 = new Label();
	private Button bottoniera[] = null;
	private Button cancelButton = null;

	// Costruttore visualizza le risorse disponibili
	public LabResourcesFrame(VirtualLab myIncomingBoss) {
		super ("Lab resources index");
		myBoss = myIncomingBoss;

		bottoniera = new Button[myBoss.myResources.getNumberOfAccessibleResources()];

		setLayout(myGrid);

		// Stampa tre righe di testo (utente,porta,risorse)
		myLabel1.setText("You are the User : "+myBoss.userName);
		myGridPos.gridx = 0;
		myGridPos.gridy = 0;
		myGrid.setConstraints(myLabel1,myGridPos);
		add(myLabel1);

		myLabel2.setText("You are connected to LabServer port : "+
			myBoss.myClient.myPort);
		myGridPos.gridx = 0;
		myGridPos.gridy = 1;
		myGrid.setConstraints(myLabel2,myGridPos);
		add(myLabel2);

		myLabel3.setText("You got authorized access to this resources : ");
		myGridPos.gridx = 0;
		myGridPos.gridy = 2;
		myGrid.setConstraints(myLabel3,myGridPos);
		add(myLabel3);

		// Visualizza un bottone per ogni risorsa autorizzata
		int buttonNumber = 0;
		for(int i=0; i<myBoss.myResources.getNumberOfResources(); i++) {
			if(myBoss.myResources.getResourceAccess(i)) {
				bottoniera[buttonNumber++] = new Button(myBoss.myResources.getResourceName(i));
				myGridPos.gridx = 0;
				myGridPos.gridy = buttonNumber+2;
				myGrid.setConstraints(bottoniera[buttonNumber-1],myGridPos);
				add(bottoniera[buttonNumber-1]);
			}
		}

		// Bottone per chiudere la finestra
		cancelButton = new Button("Cancel");
		myGridPos.gridx = 0;
		myGridPos.gridy = buttonNumber+5;
		myGrid.setConstraints(cancelButton,myGridPos);
		add(cancelButton);

		// Ridimensiona e ridisegna la finestra
		reshape(100,100,300,300);
		show();
		reshape(100,100,300,300);
	}

	// Gestisce la pressione dei bottoni
	public boolean handleEvent(Event ev) {
		// Chiudo la finestra di dialogo		
		if (ev.id == Event.WINDOW_DESTROY) {
			dispose();
			return true;
		}
		// Premo uno dei bottoni
		if (ev.target instanceof Button) {
			String label = (String)ev.arg;
			if (label!=null && label.equals("FabNet")) {
				myBoss.myInputFrame = new InputFrame(myBoss,"FabNet");
				return true;
			}
			if (label!=null && label.equals("Cancel")) {
				dispose();
				return true;
			}
		}
		return false;
	}
}
