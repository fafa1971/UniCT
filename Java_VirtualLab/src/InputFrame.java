/*
 * @(#)InputFrame.java
 * 
 * Finestra di ingresso alle risorse del laboratorio
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XI/8
 */

import java.awt.*;

public class InputFrame extends Frame {
	// Variabili generali
	private VirtualLab myBoss;
	private String resourceName;
	
	// Usate per formattare la disposizione dei componenti
	private GridBagLayout myGrid = new GridBagLayout();
	private GridBagConstraints myGridPos = new GridBagConstraints();

	// Pulsanti di avvio e di chiusura
	private Button OKbutton, cancelButton;

	// Componenti grafici (possono essere utilizzati da tutte le risorse)
	private Label myLabel0,myLabel1,myLabel2,myLabel3,myLabel4,myLabel5;
	private Label myLabel6,myLabel7,myLabel8,myLabel9,myLabel10,myLabel11;
	private Button myButton0,myButton1,myButton2,myButton3,myButton4;
	private TextField myText0,myText1,myText2,myText3,myText4,myText5;
	private CheckboxGroup Radio1,Radio2,Radio3,Radio4,Radio5;
	private Checkbox Radio1A,Radio1B,Radio1C,Radio1D;
	private Checkbox Radio2A,Radio2B,Radio2C,Radio2D;
	private Checkbox Radio3A,Radio3B,Radio3C,Radio3D;
	private Checkbox Radio4A,Radio4B,Radio4C,Radio4D;
	private Checkbox Radio5A,Radio5B,Radio5C,Radio5D;

	// Costruttore setta il nome della risorsa cui si riferisce
	public InputFrame(VirtualLab myIncomingBoss, String incomingResourceName) {
		super ("Input Interface of " + incomingResourceName);
		myBoss = myIncomingBoss;
		resourceName = incomingResourceName;

		ShowInterface();
	}

	// Visualizza una interfaccia differente per ogni risorsa
	private void ShowInterface() {
		if(resourceName.equals("FabNet")) {
			setLayout(myGrid);

			// Titolo
			myLabel0 = new Label("FabNet 3.0");
			myGridPos.gridx = 1;
			myGridPos.gridy = 0;
			myGrid.setConstraints(myLabel0,myGridPos);
			add(myLabel0);
		
			// Protocollo
			myLabel1 = new Label("Protocol : ");
			myGridPos.gridx = 0;
			myGridPos.gridy = 1;
			myGrid.setConstraints(myLabel1,myGridPos);
			add(myLabel1);

			Radio1 = new CheckboxGroup();

			Radio1A = new Checkbox("Token Bus",Radio1,true);	
			myGridPos.gridx = 1;
			myGridPos.gridy = 1;
			myGrid.setConstraints(Radio1A,myGridPos);
			add(Radio1A);

			Radio1B = new Checkbox("Token Ring",Radio1,false);
			myGridPos.gridx = 2;
			myGridPos.gridy = 1;
			myGrid.setConstraints(Radio1B,myGridPos);
			add(Radio1B);

			Radio1C = new Checkbox("FDDI",Radio1,false);	
			myGridPos.gridx = 3;
			myGridPos.gridy = 1;
			myGrid.setConstraints(Radio1C,myGridPos);
			add(Radio1C);

			// Priorità
			myLabel2 = new Label("Priority : ");
			myGridPos.gridx = 0;
			myGridPos.gridy = 2;
			myGrid.setConstraints(myLabel2,myGridPos);
			add(myLabel2);

			Radio2 = new CheckboxGroup();

			Radio2A = new Checkbox("4",Radio2,true);	
			myGridPos.gridx = 1;
			myGridPos.gridy = 2;
			myGrid.setConstraints(Radio2A,myGridPos);
			add(Radio2A);

			Radio2B = new Checkbox("3",Radio2,false);
			myGridPos.gridx = 2;
			myGridPos.gridy = 2;
			myGrid.setConstraints(Radio2B,myGridPos);
			add(Radio2B);

			Radio2C = new Checkbox("2",Radio2,false);	
			myGridPos.gridx = 3;
			myGridPos.gridy = 2;
			myGrid.setConstraints(Radio2C,myGridPos);
			add(Radio2C);

			Radio2D = new Checkbox("1",Radio2,false);	
			myGridPos.gridx = 4;
			myGridPos.gridy = 2;
			myGrid.setConstraints(Radio2D,myGridPos);
			add(Radio2D);

			// Nodi
			myLabel3 = new Label("Number of nodes : ");
			myGridPos.gridx = 0;
			myGridPos.gridy = 3;
			myGrid.setConstraints(myLabel3,myGridPos);
			add(myLabel3);

			myText0 = new TextField("30");
			myGridPos.gridx = 1;
			myGridPos.gridy = 3;
			myGrid.setConstraints(myText0,myGridPos);
			add(myText0);

			// Percorso
			myLabel4 = new Label("Path between two nodes [Km] : ");
			myGridPos.gridx = 0;
			myGridPos.gridy = 4;
			myGrid.setConstraints(myLabel4,myGridPos);
			add(myLabel4);

			myText1 = new TextField("1");
			myGridPos.gridx = 1;
			myGridPos.gridy = 4;
			myGrid.setConstraints(myText1,myGridPos);
			add(myText1);
				
			// Data Rate
			myLabel5 = new Label("Data Rate [Mbps] : ");
			myGridPos.gridx = 0;
			myGridPos.gridy = 5;
			myGrid.setConstraints(myLabel5,myGridPos);
			add(myLabel5);

			myText2 = new TextField("1");
			myGridPos.gridx = 1;
			myGridPos.gridy = 5;
			myGrid.setConstraints(myText2,myGridPos);
			add(myText2);
			
			// Lunghezza
			myLabel6 = new Label("Average message length [bit] : ");
			myGridPos.gridx = 0;
			myGridPos.gridy = 6;
			myGrid.setConstraints(myLabel6,myGridPos);
			add(myLabel6);

			myText3 = new TextField("1000");
			myGridPos.gridx = 1;
			myGridPos.gridy = 6;
			myGrid.setConstraints(myText3,myGridPos);
			add(myText3);
			
			// Tempo di simulazione
			myLabel7 = new Label("Time to simulate [msec] : ");
			myGridPos.gridx = 0;
			myGridPos.gridy = 7;
			myGrid.setConstraints(myLabel7,myGridPos);
			add(myLabel7);

			myText4 = new TextField("3000");
			myGridPos.gridx = 1;
			myGridPos.gridy = 7;
			myGrid.setConstraints(myText4,myGridPos);
			add(myText4);

			// Tempi di rotazione del token...

			reshape(10,10,600,400);
			show();
			reshape(10,10,600,400);
		}

		OKbutton = new Button("OK");
		myGridPos.gridx = 1;
		myGridPos.gridy = 8;
		myGrid.setConstraints(OKbutton,myGridPos);
		add(OKbutton);

		cancelButton = new Button("Cancel");
		myGridPos.gridx = 2;
		myGridPos.gridy = 8;
		myGrid.setConstraints(cancelButton,myGridPos);
		add(cancelButton);
	}
	
	// Gestisce la pressione dei tasti
	public boolean handleEvent(Event ev) {
		// Chiudo la finestra
		if (ev.id == Event.WINDOW_DESTROY) {
			dispose();
			return true;
		}
		// Premo uno dei bottoni
		if (ev.target instanceof Button) {
			String label = (String)ev.arg;
			if (label!=null && label.equals("Cancel")) {
				dispose();
				return true;
			}
			if (label!=null && label.equals("OK")) {
				// Costruisce comando diverso a seconda della risorsa
				
				// Costruzione comando per 'FabNet'
				if(resourceName.equals("FabNet")) {				
					StringBuffer command = new StringBuffer();
						
					command.append("FABNET ");

					if(Radio1A.getState()) command.append("0 ");
					else if(Radio1B.getState()) command.append("1 ");
					else if(Radio1C.getState()) command.append("2 ");
					else command.append("* ");	// Murphy Law

					if(Radio2A.getState()) command.append("4 ");
					else if(Radio2B.getState()) command.append("3 ");
					else if(Radio2C.getState()) command.append("2 ");
					else if(Radio2D.getState()) command.append("1 ");
					else command.append("* ");	// Murphy Law

					command.append(myText0.getText()+" ");
					command.append(myText1.getText()+" ");
					command.append(myText2.getText()+" ");
					command.append(myText3.getText()+" ");
					command.append(myText4.getText()+" ");
					
					myBoss.executionCommand = new String(command.toString());
					myBoss.executionCanStart = true;
				}
				myBoss.myOutputFrame = new OutputFrame(myBoss,resourceName);
				return true;
			}
		}
		return false;
	}
}
