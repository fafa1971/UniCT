/*
 * @(#)FileManager.java
 *
 * Classe di supporto per accedere ai campi delle strutture dati
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XI/14
 */

import java.io.*;

public class FileManager {
	private RandomAccessFile myFile = null;
	private int FileIndex = 0;
	private int recordSeparator = '#';
	private int fieldSeparator = ',';

	// Costruttore apre il file da leggere o scrivere
	// 'name' è il nome del file da aprire
	// 'mode' è "r" per lettura o "rw" per lettura-scrittura
	public FileManager(String name, String mode) {
		try {
			myFile = new RandomAccessFile(name, mode);
		} catch (IOException e) {
			System.err.println("Problems accessing " + name);
			System.exit(1);
		}
	}

	// Modifica i separatori da utilizzare
	public void setSeparators(int rs, int fs) {
		recordSeparator = rs;
		fieldSeparator = fs;
	}

	// Aggiunge un record al file
	public void addRecord(String strings[]) {
		try {
			myFile.seek(myFile.length());
			myFile.writeByte(recordSeparator);
			for (int z=0; z<strings.length; z++) {
				myFile.writeBytes(strings[z]);
				if(z != (strings.length-1)) myFile.writeByte(fieldSeparator);
			}
			myFile.writeBytes("\r\n");
		} catch (IOException e) {
			System.err.println("Problems adding record");
			System.exit(1);
		}
	}

	// Legge un record dal file
	public String[] readRecord() {
		String strings[] = null;
		int numberOfFields = 1;
		int separatorPos = 0;
		int newPos = 0;
		String line = new String();

		try {
			if (FileIndex < myFile.length()) {
				// Leggo una riga
				myFile.seek(FileIndex);
				line = new String(myFile.readLine());
				FileIndex += line.length()+1;

				// Conto il numero di campi
				while(true) {
					newPos = line.indexOf(fieldSeparator,separatorPos);
					if (newPos == -1) break;
					else {
						numberOfFields++;
						separatorPos = newPos+1;
					}
				}
				
				// Calcolo le posizioni di tutti i separatori
				int pos[] = new int[numberOfFields+1];
				pos[0] = line.indexOf(recordSeparator);
				if (pos[0] == -1) {
					System.err.println("Record separator not found");
					System.exit(1);
				}
				for (int k=1; k<numberOfFields; k++) {
					pos[k] = line.indexOf(fieldSeparator,pos[k-1]+1);
				}
				pos[numberOfFields] = line.indexOf('\r');

				// Pongo i campi nelle stringhe da ritornare
				byte array[][] = new byte[numberOfFields][80];

				for (int x=0; x<numberOfFields; x++)
					line.getBytes(pos[x]+1,pos[x+1],array[x],0);
				line = new String();

				strings = new String[numberOfFields];

				for (int x=0; x<numberOfFields; x++)
					strings[x] = new String(new String(array[x],0)).trim();
			} else {
				strings = null;
			}
		} catch (IOException e) {
			strings = null;
			System.err.println("IOE catched");
		}
		return strings;
	}

	// Chiude il file
	public void close() {
		try {
			myFile.close();
			myFile = null;
		} catch (IOException e) { }
	}
}