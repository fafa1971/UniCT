/*
 * @(#)AnimationThread.java
 *
 * Thread separato che avvia l'animazione nell'applet
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XII/30
 */

import java.applet.*;
import java.awt.*;

public class AnimationThread extends Thread {
	VirtualLab myBoss = null;
	
	// Costruttore
	public AnimationThread(VirtualLab myIncomingBoss) {
		super();
		myBoss = myIncomingBoss;
	}

	// Carica i fotogrammi che compongono l'animazione
	public void run() {
		myBoss.repaint();

		myBoss.VL_Graphics = myBoss.getGraphics();
		myBoss.VL_CurrImageNo = 0;
		myBoss.VL_Images = new Image[myBoss.NUM_IMAGES];

		String strImage;

		// For each image in the animation, this method first constructs a
		// string containing the path to the image file; then it begins loading
		// the image into the VL_Images array.  Note that the call to getImage
		// will return before the image is completely loaded.
		for (int i = 1; i <= myBoss.NUM_IMAGES; i++) {
			strImage = "images/img00" + ((i < 10) ? "0" : "") + i + ".gif";
            myBoss.VL_Images[i-1] = myBoss.getImage(myBoss.getDocumentBase(),
				strImage);
			
			if (myBoss.VL_ImgWidth == 0) {
				try	{
					// The getWidth() and getHeight() methods of the Image class
					// return -1 if the dimensions are not yet known. The
					// following code keeps calling getWidth() and getHeight()
					// until they return actual values (executed only once).
					while ((myBoss.VL_ImgWidth =
						myBoss.VL_Images[i-1].getWidth(null)) < 0)
						
						Thread.sleep(1);

					while ((myBoss.VL_ImgHeight =
						myBoss.VL_Images[i-1].getHeight(null)) < 0)
						
						Thread.sleep(1);						
				
				} catch (InterruptedException e) { }
			}
			myBoss.VL_Graphics.drawImage(myBoss.VL_Images[i-1],
				-1000,-1000,myBoss);
		}

		while (!myBoss.VL_AllLoaded) {
			try	{
				Thread.sleep(10);
			} catch (InterruptedException e) { }
		}
		
		myBoss.repaint();

		// Il ciclo seguente viene ripetuto all'infinito
		while (true) {
			try {
				myBoss.displayImage(myBoss.VL_Graphics);
				myBoss.VL_CurrImageNo++;
				if (myBoss.VL_CurrImageNo == myBoss.NUM_IMAGES)
					myBoss.VL_CurrImageNo = 0;

				Thread.sleep(50);
			} catch (InterruptedException e) {
				stop();
			}
		}
	}
}