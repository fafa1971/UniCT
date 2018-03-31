/*
 * @(#)LabResources.java
 *
 * Contiene la descrizione delle risorse disponibili per il client
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XI/15
 */

import java.io.*;

public class LabResources {
	// Variabili generali per memorizzare le risorse
	private static int numberOfResources = 4;
	private static final String resourceName[] = {
		"FabNet",
		"Resource2",
		"Resource3",
		"Resource4"
	};

	// Variabili usate dal client per ricordare i propri permessi
	private int numberOfAccessibleResources = 0;
	private boolean resourceAccess[];

	// Costruttore usato dal server non fa nulla
	public LabResources() {
	}

	// Costruttore (usato dal client) setta i permessi ricevuti.
	// Non importa se il client bara, tanto potrà solo ottenere
	// l'accesso all'interfaccia, mentre per le vere risorse il
	// server non guarda questa struttura ma utilizza le proprie
	public LabResources(boolean access[]) {
		if (access==null || access.length!=numberOfResources) {
			System.err.println("Numero di permessi non valido");
			System.exit(1);
		} else {
			resourceAccess = access;
			for (int i=0; i<resourceAccess.length; i++) {
				if (resourceAccess[i]) numberOfAccessibleResources++;
			}
		}
	}

	// Ritorna il numero di risorse totali
	public int getNumberOfResources() {
		return numberOfResources;
	}

	// Ritorna il numero di risorse accessibili
	public int getNumberOfAccessibleResources() {
		return numberOfAccessibleResources;
	}

	// Ritorna il permesso su ogni risorsa
	public boolean getResourceAccess(int n) {
		if (n>=0 && n<numberOfResources)
			return resourceAccess[n];
		else return false;
	}

	// Restituisce dal numero il nome della risorsa
	public String getResourceName(int n) {
		if (n>=0 && n<numberOfResources)
			return resourceName[n];
		else return null;
	}

	// Restituisce dal nome il numero della risorsa
	public int getResourceNumber(String name) {
		for (int i=0; i<numberOfResources; i++) {
			if (name.toLowerCase().startsWith
				(resourceName[i].toLowerCase()))
				return i;
		}
		return -1;
	}
}