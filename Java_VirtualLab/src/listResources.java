/*
 * @(#)listResources.java
 *
 * Comando stand-alone usato per elencare le risorse disponibili
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1997/I/6
 */

public class listResources {
	public static void main(String args[]) {
		LabResources myLR = new LabResources();
		int MAX = myLR.getNumberOfResources();

		System.out.println("There are "+MAX+" resources available.");
		
		for (int i=0; i<MAX; i++) {
			System.out.print("Resource nr."+i+" is named ");
			System.out.println(myLR.getResourceName(i));
		}
	}
}