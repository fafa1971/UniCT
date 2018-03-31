/*
 * @(#) LoginDialog.java
 *
 * Finestra di dialogo per il login
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/X/31
 */

import java.awt.*;

public class LoginDialog extends Dialog {
	VirtualLab myBoss;
	
	// Variabili usate per il disegno
	public GridBagLayout myGrid = new GridBagLayout();
	public GridBagConstraints myGridPos = new GridBagConstraints();
	public Label UserNameLabel,PasswordLabel;
	public TextField UserNameField,PasswordField;
	public Button OKButton,CancelButton;

	// Usate per memorizzare le info da inviare all'applet
	private String userName,cryptedPassword;

	// Il costruttore disegna tutta la finestra di dialogo
	public LoginDialog (VirtualLab myIncomingBoss) {
		super (myIncomingBoss.myLoginDialogFrame, "Virtual Lab Login Dialog", false);
		
		myBoss = myIncomingBoss;

		setLayout(myGrid);

		UserNameLabel = new Label("User Name : ");
		myGridPos.gridx=0;
		myGridPos.gridy=0;
		myGrid.setConstraints(UserNameLabel,myGridPos);
		add(UserNameLabel);

		PasswordLabel = new Label("Password : ");
		myGridPos.gridx=0;
		myGridPos.gridy=1;
		myGrid.setConstraints(PasswordLabel,myGridPos);
		add(PasswordLabel);

		UserNameField = new TextField(15);
		UserNameField.setEditable(true);
		myGridPos.gridx=1;
		myGridPos.gridy=0;
		myGrid.setConstraints(UserNameField,myGridPos);
		add(UserNameField);

		PasswordField = new TextField(15);
		PasswordField.setEchoCharacter('*');
		PasswordField.setEditable(true);
		myGridPos.gridx=1;
		myGridPos.gridy=1;
		myGrid.setConstraints(PasswordField,myGridPos);
		add(PasswordField);

		OKButton = new Button("OK");
		myGridPos.gridx=0;
		myGridPos.gridy=2;
		myGrid.setConstraints(OKButton,myGridPos);
		add(OKButton);

		CancelButton = new Button("Cancel");
		myGridPos.gridx=1;
		myGridPos.gridy=2;
		myGrid.setConstraints(CancelButton,myGridPos);
		add(CancelButton);
		
		reshape (200, 100, 250, 140);
		show();
		reshape (200, 100, 250, 140);
	}

	// Gestisce gli eventi che possono verificarsi
	public boolean handleEvent(Event ev) {
		// Chiudo la finestra di dialogo		
		if (ev.id == Event.WINDOW_DESTROY) {
			myBoss.LoginDialogActive = false;
			dispose();
			return true;
		}
		// Premo uno dei bottoni
		if (ev.target instanceof Button) {
			String label = (String)ev.arg;
			if (label!=null && label.equals("OK")) {

				// QUI DOVREI CIFRARE LA PASSWORD
				userName = UserNameField.getText();
				cryptedPassword = PasswordField.getText();
				myBoss.setInfo(userName,cryptedPassword);
				myBoss.LoginDialogActive = false;
				myBoss.LoginOKPressed = true;
				
				dispose();
				return true;
			}
			if (label!=null && label.equals("Cancel")) {
				myBoss.LoginDialogActive = false;
				dispose();
				return true;
			}
		}
		return false;
	}

}
