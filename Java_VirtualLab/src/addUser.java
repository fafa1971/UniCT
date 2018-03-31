/*
 * @(#)addUser.java
 *
 * Comando stand-alone usato per aggiungere utenti al file 'access'
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XI/9
 */

import java.io.*;

public class addUser {
	// Variabili ausiliarie per scrivere su file un record
	private static final int NUMBER_OF_FIELDS = 3;
	private static String strings[] = new String[NUMBER_OF_FIELDS];

	// Variabili private
	private static int numberOfRights;

	// Legge una stringa dallo 'stdin'
	private static String readLine() throws IOException {
		byte line[] = new byte[80];
		int i=0, b=0;

		while( (i<80) && ((b=System.in.read())!='\n') ) {
			line[i++] = (byte)b;
		}

		return(new String(line,0,0,i));
	}

	// Aggiunge il nuovo utente al file 'access'	
	public static void main(String args[]) throws IOException {

		LabResources myLR = new LabResources();
		numberOfRights = myLR.getNumberOfResources();

		if (args.length == 0) {
			System.err.println("Insert new User Name : ");
			strings[0] = readLine();
			
			System.err.println("Insert Password : ");
			strings[1] = readLine();
			
			System.err.print("Insert Rights (string of ");
			System.err.println(numberOfRights+" '0' and '1') : ");
			strings[2] = readLine();

		} else if (args.length == NUMBER_OF_FIELDS &&
			args[2].trim().length()==numberOfRights) {

			strings = args;
		} else {
			System.out.print("Syntax: java addUser USERNAME PASSWORD ");
			System.out.println("RIGHTS("+numberOfRights+")");
			System.exit(1);
		}

		FileManager myFile = new FileManager("data/access","rw");
		myFile.addRecord(strings);
		myFile.close();
		myFile = null;

		System.out.println("User added to data/access");
	}
}