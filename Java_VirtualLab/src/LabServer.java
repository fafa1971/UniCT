/*
 * @(#)LabServer.java
 *
 * Applicazione stand-alone che avvia il server del Virtual Lab
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XII/30
 */

public class LabServer {
	public static void main(String args[]) {
		new MultiLabServer().start();
	}
}