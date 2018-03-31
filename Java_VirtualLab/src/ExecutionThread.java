/*
 * @(#)ExecutionThread.java
 *
 * Usato dal server per eseguire i comandi a distanza
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XI/19
 */

import java.util.*;
import java.io.*;

public class ExecutionThread {
	String command = new String();

	// Costruttore memorizza il comando da eseguire
	public ExecutionThread(String cmd) {
		if (cmd!=null) command = new String(cmd);
	}
	
	// Esegue il comando e restituisce la risposta
	public String[] getExecutionResponse() {
		String response[] = null;

		try {
			System.out.println("Prima del processo");
			Process p = Runtime.getRuntime().exec(command);

			DataInputStream stream = new DataInputStream(new BufferedInputStream(p.getInputStream()));
			String newString = null;
			while((newString=stream.readLine())!=null) response=addString(response,newString);

			System.out.println("Dopo il processo");
			p.destroy();

		} catch (IOException e) {
			System.out.println("Exception : "+ e);
			e.printStackTrace();
		}

		return response;
	}

	// Usato per accrescere la risposta run-time
	private String[] addString(String oldStrings[], String stringToAdd) {
		String newStrings[];
			
		if (oldStrings!=null) {
			newStrings = new String[oldStrings.length+1];
		
			System.arraycopy(oldStrings,0,newStrings,0,oldStrings.length);
			newStrings[newStrings.length-1] = stringToAdd;
		} else {
			newStrings = new String[1];
			newStrings[0] = stringToAdd;
		}

		return newStrings;
	}

}