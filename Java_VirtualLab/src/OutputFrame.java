/*
 * @(#)OutputFrame.java
 * 
 * Finestra per visualizzare i risultati delle interazioni
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XII/31
 */

import java.awt.*;

public class OutputFrame extends Frame {
	// Variabili generali
	private VirtualLab myBoss;
	private String resourceName;
	
	// Usate per formattare la disposizione dei componenti
	private GridBagLayout myGrid = new GridBagLayout();
	private GridBagConstraints myGridPos = new GridBagConstraints();

	// Separatori dei campi nelle stringhe
	private int recordSeparator = '#';
	private int fieldSeparator = ',';

	// Pulsanti di avvio e di chiusura
	private Button OKbutton, cancelButton;

	// Componenti grafici (possono essere utilizzati da tutte le risorse)
	private Image rect1,rect2,rect3,rect4,rect5,rect6;
	private float X1,X2,X3,X4,X5,X6;
	private float Y1,Y2,Y3,Y4,Y5,Y6;
	private Label myLabel0,myLabel1,myLabel2,myLabel3,myLabel4,myLabel5;
	private Label myLabel6,myLabel7,myLabel8,myLabel9,myLabel10,myLabel11;
	private Button myButton0,myButton1,myButton2,myButton3,myButton4;
	private TextField myText0,myText1,myText2,myText3,myText4,myText5;
	private CheckboxGroup Radio1,Radio2,Radio3,Radio4,Radio5;
	private Checkbox Radio1A,Radio1B,Radio1C,Radio1D;
	private Checkbox Radio2A,Radio2B,Radio2C,Radio2D;
	private Checkbox Radio3A,Radio3B,Radio3C,Radio3D;
	private Checkbox Radio4A,Radio4B,Radio4C,Radio4D;
	private Checkbox Radio5A,Radio5B,Radio5C,Radio5D;

	// Costruttore setta il nome della risorsa cui si riferisce
	public OutputFrame(VirtualLab myIncomingBoss, String incomingResourceName) {
		super ("Output Interface of " + incomingResourceName);
		myBoss = myIncomingBoss;
		resourceName = incomingResourceName;
	}

	// Visualizza una interfaccia differente per ogni risorsa
	public void ShowInterface(String results[]) {
		
		// Interfaccia di uscita del simulatore 'FabNet'
		if(resourceName.equals("FabNet")) {
			// Variabili di ingresso della simulazione
			// (nell'ordine: pro,pri,nod,pat,dat,len,tsi,tpr)
			int Protocol, Priority, Nodes, Length;
			float Path, DataRate, T_Simul;
			float T_Pri[] = new float[4];
			
			// Valori di ascisse e ordinate
			float WL_max, TP_max, AD_max;
			float WorkLoad[] = new float[8];

			// Risultati della simulazione
			float ThroughPut[][] = new float[3][8];
			float AccessDelay[][] = new float[3][8];

			// Area di visualizzazione grafico ThroughPut
			int TP_width = 210;
			int TP_height = 140;
			
			// Area di visualizzazione grafico Access Delay
			int AD_width = 210;
			int AD_height = 140;

			// Rileggo parametri di ingresso	
			float floats[] = readFloatRecord(results[1]);
			Protocol = (int)floats[0];
			Priority = (int)floats[1];
			Nodes = (int)floats[2];
			Path = floats[3];
			DataRate = floats[4];
			Length = (int)floats[5];
			T_Simul = floats[6];
			for (int i=0; i<4; i++) T_Pri[i] = floats[7+i];

			// Leggo i valori per normalizzare le ordinate
			floats = readFloatRecord(results[2]);
			TP_max = floats[0];
			AD_max = floats[1];

			// Leggo i valori delle ascisse
			floats = readFloatRecord(results[3]);
			for (int i=0; i<floats.length; i++)
				WorkLoad[i] = floats[i];
			WL_max = WorkLoad[WorkLoad.length-1];

			// Trasmetto i valori max alle variabili globali (per paint())
			X1 = WL_max;
			Y1 = TP_max;
			Y2 = AD_max;

			// Leggo risultati della simulazione
			int curves = ((Priority==4) ? 1 : 3 );
			int row=4;
			for (int a=0; a<curves; a++) {
				floats = readFloatRecord(results[row+a]);
				for (int i=0; i<floats.length; i++)
					ThroughPut[a][i] = floats[i];
			}
			row = ( (Priority==4) ? 5 : 7 );
			for (int a=0; a<curves; a++) {
				floats = readFloatRecord(results[row+a]);
				for (int i=0; i<floats.length; i++)
					AccessDelay[a][i] = floats[i];
			}

			// Volendo potrei ancora leggere dati per istogrammi...

			// Immagini per double-buffering e graphic context
			addNotify();	// crea il FramePeer (serve per createImage)
			rect1 = createImage(TP_width, TP_height);
			rect2 = createImage(AD_width, AD_height);
			Graphics gc1 = rect1.getGraphics();
			Graphics gc2 = rect2.getGraphics();

			// Sfondo grafico ThroughPut
			gc1.setColor(Color.cyan);
			gc1.fillRect(0,0,TP_width,TP_height);
			gc1.setColor(Color.black);
			// Sfondo grafico Access Delay
			gc2.setColor(Color.pink);
			gc2.fillRect(0,0,AD_width,AD_height);
			gc2.setColor(Color.black);

			// Inizio plottaggio grafici
			float Xold,Yold,Xnew,Ynew;
			
			// Curve ThroughPut (1 o 3)
			for (int a=0; a<curves; a++) {
				Xold = 0; Yold = 0;

				for (int i=0; i<8; i++) {
					Xnew = WorkLoad[i];
					Ynew = Math.min(ThroughPut[a][i],TP_max);

					gc1.drawLine(
						(int) (( Xold / WL_max )* (float)TP_width),
						(int) (( 1.0 - Yold / TP_max )* (float)TP_height),
						(int) (( Xnew / WL_max )* (float)TP_width),
						(int) (( 1.0 - Ynew / TP_max )* (float)TP_height ));

					Xold = Xnew; Yold = Ynew;
				}
			}
			// Curve Access Delay (1 o 3)
			for (int a=0; a<curves; a++) {
				Xold = 0; Yold = 0;

				for (int i=0; i<8; i++) {
					Xnew = WorkLoad[i];
					Ynew = Math.min(AccessDelay[a][i],AD_max);

					gc2.drawLine(
						(int) (( Xold / WL_max )* (float)AD_width),
						(int) (( 1.0 - Yold / AD_max )* (float)AD_height),
						(int) (( Xnew / WL_max )* (float)AD_width),
						(int) (( 1.0 - Ynew / AD_max )* (float)AD_height ));

					Xold = Xnew; Yold = Ynew;
				}
			}
			reshape(10,10,600,400);
			show();
			reshape(10,10,600,400);
		}
	}
	
	// Disegna la finestra
	public void paint(Graphics g) {
		if (resourceName.equals("FabNet") && rect1!=null && rect2!=null) {
			g.drawString("ThroughPut [Mbps] "+Y1,50,40);
			g.drawImage(rect1,250,40,this);
			g.drawString("Access Delay [msec] "+Y2,50,200);
			g.drawImage(rect2,250,200,this);
			g.drawString("WorkLoad [frames/sec] "+X1,250,350);
		}
	}

	// Gestisce la pressione dei tasti
	public boolean handleEvent(Event ev) {
		// Chiudo la finestra
		if (ev.id == Event.WINDOW_DESTROY) {
			dispose();
			return true;
		}
		return false;
	}

	// Modifica i separatori da utilizzare
	public void setSeparators(int rs, int fs) {
		recordSeparator = rs;
		fieldSeparator = fs;
	}

	// Converte una stringa (record) in array di interi
	public int[] readIntRecord(String record) {
		String fields[] = readRecord(record);
		int integers[] = new int[fields.length];

		for (int i=0; i<fields.length; i++) {
//System.out.println("Provo a convertire la stringa '"+fields[i]+"'");
			try {
				integers[i] = Integer.parseInt(fields[i]);
			} catch (NumberFormatException e) {
				return null;
			}
		}

		return integers;
	}

	// Converte una stringa (record) in array di float
	public float[] readFloatRecord(String record) {
		String fields[] = readRecord(record);
		float floats[] = new float[fields.length];

		for (int i=0; i<fields.length; i++) {
//System.out.println("Provo a convertire la stringa '"+fields[i]+"'");
			try {
				floats[i] = Float.valueOf(fields[i]).floatValue();
			} catch (NumberFormatException e) {
				return null;
			}
		}

		return floats;
	}

	// Converte una stringa (record) in array di stringhe
	public String[] readRecord(String record) {
		String strings[] = null;
		int numberOfFields = 1;
		int separatorPos = 0;
		int newPos = 0;

		// Conto il numero di campi
		while(true) {
			newPos = record.indexOf(fieldSeparator,separatorPos);
			if (newPos == -1) break;
			else {
				numberOfFields++;
				separatorPos = newPos+1;
			}
		}
				
		// Calcolo le posizioni di tutti i separatori
		int pos[] = new int[numberOfFields+1];
		pos[0] = record.indexOf(recordSeparator);
		if (pos[0] == -1) {
			System.err.println("Record separator not found");
			return null;
		}
		for (int k=1; k<numberOfFields; k++) {
			pos[k] = record.indexOf(fieldSeparator,pos[k-1]+1);
		}
		pos[numberOfFields] = record.length();

		// Pongo i campi nelle stringhe da ritornare
		byte array[][] = new byte[numberOfFields][80];

		for (int x=0; x<numberOfFields; x++)
			record.getBytes(pos[x]+1,pos[x+1],array[x],0);
		record = new String();

		strings = new String[numberOfFields];

		for (int x=0; x<numberOfFields; x++)
			strings[x] = new String(new String(array[x],0)).trim();

		return strings;
	}

	public static void main(String args[]) {
		OutputFrame of = new OutputFrame(null,"Superpollo!!!");

		String record1 = "#12,34,128";
		String record2 = "#123.4,234.5,12345.678";

		int ints[] = of.readIntRecord(record1);
		if (ints!=null) System.out.println("ints OK");
		else System.out.println("ints !!!");

		float floats[] = of.readFloatRecord(record2);
		if (floats!=null) System.out.println("floats OK");
		else System.out.println("floats !!!");
	}
}
