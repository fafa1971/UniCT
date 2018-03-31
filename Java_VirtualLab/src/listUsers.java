/*
 * @(#)listUsers.java
 *
 * Comando stand-alone usato per leggere la Access Matrix
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XI/12
 */

import java.io.*;

public class listUsers {

	// Legge utenti e password dal file 'access'
	public static void main(String args[]) throws IOException {
		String strings[];

		FileManager myFile = new FileManager("data/access","r");

		while(true) {
			strings = myFile.readRecord();
			if(strings==null) break;
			System.out.print("User "+strings[0]);
			System.out.println(" has rights "+strings[2]);
		}

		myFile.close();
	}
}