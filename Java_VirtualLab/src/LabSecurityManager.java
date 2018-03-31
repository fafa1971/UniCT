/*
 * @(#)LabSecurityManager.java
 *
 * Gestisce il Modello di Sicurezza del Virtual Lab
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1997/I/1
 */

class LabSecurityManager {
	// Variabili private
	private LabResources myLR;			// risorse del laboratorio
	private int numberOfResources;		// numero di risorse
	
	// Vettore dei bloccaggi -> Current Blocking Set
	private boolean Locks[];

	// Il costruttore inizializza il vettore dei bloccaggi
	public LabSecurityManager() {
		myLR = new LabResources();
		numberOfResources = myLR.getNumberOfResources();

		Locks = new boolean[numberOfResources];
		for (int i=0; i<Locks.length; i++) Locks[i] = false;
	}

	// Verifica che l'utente sia registrato e restituisce accessi
	// (spediti solo nella fase di autenticazione e senza alcun impegno)
	String getAccesses(String userName, String cryptedPassword) {
		String strings[] = null;
		String access = new String();

		FileManager myFile = new FileManager("data/access","r");

		while(true) {
			strings = myFile.readRecord();
			if (strings==null || strings.length<3) {
				break;
			} else if (strings[0].equals(userName) && strings[1].equals(cryptedPassword)) {
				access = new String(strings[2]);
				break;
			}
		}
		myFile.close();
		
		return access;
	}

	// Controlla nella Access Matrix (ovvero nel file 'data/access')
	// se l'utente autenticato ha il permesso di accedere alla
	// risorsa richiesta
	boolean checkAccess(String userName, String resourceName) {
		int num = myLR.getResourceNumber(resourceName);

		// Se la risorsa esiste
		if (num!=-1) {
	
			String records[];
			String accesses;

			FileManager myFile = new FileManager("data/access","r");

			while(true) {
				// Legge i permessi dalla Access Matrix
				records = myFile.readRecord();

				if (records==null || records.length<3) {
					break;
				} else if (records[0].equals(userName)) {
					accesses = new String(records[2]);

					// Restituisce se l'utente ha il permesso
					myFile.close();
					if (accesses.charAt(num)=='1')
						return true;
					else return false;
				}
			}
			myFile.close();
		}
		return false;
	}

	// Controlla (in maniera anche attiva) se il comando da
	// eseguire possa essere pericoloso per gli impianti.
	// Implementa il Resources Interaction Set, e controlla
	// nel Current Blocking Set (vettore Locks[])
	boolean checkCommand(String commands[]) {
		// Il simulatore e' innocuo
		if (commands[0].toLowerCase().startsWith("fabnet")) {

			return true;
		}
		
		return false;
	}
}