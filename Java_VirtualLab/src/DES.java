/*
 * @(#)DES.java
 *
 * Classe con tutti gli strumenti della cifratura DES
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XI/10
 */

public class DES {
	DataManager myDM;	// alloca memoria per nuove strutture

	// Dati dell'algoritmo di cifratura DES
	
	// Vettori di trasposizione del testo (64 int [1..64])

	// IP
	private final int InitialTr[] = {
		58,50,42,34,26,18,10, 2,60,52,44,36,28,20,12, 4,
		62,54,46,38,30,22,14, 6,64,56,48,40,32,24,16, 8,
		57,49,41,33,25,17, 9, 1,59,51,43,35,27,19,11, 3,
		61,53,45,37,29,21,13, 5,63,55,47,39,31,23,15, 7 };

	// FP
	private final int FinalTr[] = {
		40, 8,48,16,56,24,64,32,39, 7,47,15,55,23,63,31,
		38, 6,46,14,54,22,62,30,37, 5,45,13,53,21,61,29,
		36, 4,44,12,52,20,60,28,35, 3,43,11,51,19,59,27,
		34, 2,42,10,50,18,58,26,33, 1,41, 9,49,17,57,25 };

	private final int swap[] = {
		33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,
		49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,
		 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,
		17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32 };

	// Vettori di trasposizione delle chiavi
	
	// PC-1 (56 int [1..64])
	private final int KeyTr1[] = {
		57,49,41,33,25,17, 9, 1,58,50,42,34,26,18,
		10, 2,59,51,43,35,27,19,11, 3,60,52,44,36,
		63,55,47,39,31,23,15, 7,62,54,46,38,30,22,
		14, 6,61,53,45,37,29,21,13, 5,28,20,12, 4 };

	// PC-2 (48 int [1..56])
	private final int KeyTr2[] = {
		14,17,11,24, 1, 5, 3,28,15, 6,21,10,
		23,19,12, 4,26, 8,16, 7,27,20,13, 2,
		41,52,31,37,47,55,30,40,51,45,33,48,
		44,49,39,56,34,53,46,42,50,36,29,32 };

	// Altri vettori
	
	// E (48 int [1..32])
	private final int etr[] = {
		32, 1, 2, 3, 4, 5, 4, 5, 6, 7, 8, 9,
		 8, 9,10,11,12,13,12,13,14,15,16,17,
		16,17,18,19,20,21,20,21,22,23,24,25,
		24,25,26,27,28,29,28,29,30,31,32, 1 };

	// P (32 int [1..32])
	private final int ptr[] = {
		16, 7,20,21,29,12,28,17, 1,15,23,26, 5,18,31,10,
		 2, 8,24,14,32,27, 3, 9,19,13,30, 6,22,11, 4,25 };

	// Rots (16 int [1;2])
	private final int rots[] = {1,1,2,2,2,2,2,2,1,2,2,2,2,2,2,1};

	// S-boxes (blocchi di sostituzione) (matrice di 8*64 int):
	private final int s[][] = {
		{
			14, 4,13, 1, 2,15,11, 8, 3,10, 6,12, 5, 9, 0, 7,
			 0,15, 7, 4,14, 2,13, 1,10, 6,12,11, 9, 5, 3, 8,
			 4, 1,14, 8,13, 6, 2,11,15,12, 9, 7, 3,10, 5, 0,
			15,12, 8, 2, 4, 9, 1, 7, 5,11, 3,14,10, 0, 6,13 },
		{
			15, 1, 8,14, 6,11, 3, 4, 9, 7, 2,13,12, 0, 5,10,
			 3,13, 4, 7,15, 2, 8,14,12, 0, 1,10, 6, 9,11, 5,
			 0,14, 7,11,10, 4,13, 1, 5, 8,12, 6, 9, 3, 2,15,
			13, 8,10, 1, 3,15, 4, 2,11, 6, 7,12, 0, 5,14, 9 },
		{
			10, 0, 9,14, 6, 3,15, 5, 1,13,12, 7,11, 4, 2, 8,
			13, 7, 0, 9, 3, 4, 6,10, 2, 8, 5,14,12,11,15, 1,
			13, 6, 4, 9, 8,15, 3, 0,11, 1, 2,12, 5,10,14, 7,
			 1,10,13, 0, 6, 9, 8, 7, 4,15,14, 3,11, 5, 2,12 },
		{
			 7,13,14, 3, 0, 6, 9,10, 1, 2, 8, 5,11,12, 4,15,
			13, 8,11, 5, 6,15, 0, 3, 4, 7, 2,12, 1,10,14, 9,
			10, 6, 9, 0,12,11, 7,13,15, 1, 3,14, 5, 2, 8, 4,
			 3,15, 0, 6,10, 1,13, 8, 9, 4, 5,11,12, 7, 2,14 },
		{
			 2,14, 4, 1, 7,10,11, 6, 8, 5, 3,15,13, 0,14, 9,
			14,11, 2,12, 4, 7,13, 1, 5, 0,15,10, 3, 9, 8, 6,
			 4, 2, 1,11,10,13, 7, 8,15, 9,12, 5, 6, 3, 0,14,
			11, 8,12, 7, 1,14, 2,13, 6,15, 0, 9,10, 4, 5, 3 },
		{
			12, 1,10,15, 9, 2, 6, 8, 0,13, 3, 4,14, 7, 5,11,
			10,15, 4, 2, 7,12, 9, 5, 6, 1,13,14, 0,11, 3, 8,
			 9,14,15, 5, 2, 8,12, 3, 7, 0, 4,10, 1,13,11, 6,
			 4, 3, 2,12, 9, 5,15,10,11,14, 1, 7, 6, 0, 8,13 },
		{
			 4,11, 2,14,15, 0, 8,13, 3,12, 9, 7, 5,10, 6, 1,
			13, 0,11, 7, 4, 9, 1,10,14, 3, 5,12, 2,15, 8, 6,
			 1, 4,11,13,12, 3, 7,14,10,15, 6, 8, 0, 5, 9, 2,
			 6,11,13, 8, 1, 4,10, 7, 9, 5, 0,15,14, 2, 3,12 },
		{
			13, 2, 8, 4, 6,15,11, 1,10, 9, 3,14, 5, 0,12, 7,
			 1,15,13, 8,10, 3, 7, 4,12, 5, 6,11, 0,14, 9, 2,
			 7,11, 4, 1, 9,12,14, 2, 0, 6,10,13,15, 3, 5, 8,
			 2, 1,14, 7, 4,10, 8,13,15,12, 9, 0, 3, 5, 6,11 }
	};

	// Costruttore
    public DES() {
		myDM = new DataManager();		// alloca memoria
	}
	
	// Procedure interne all'algoritmo di cifratura DES

	// Traspone i primi n elementi di data con trasposizione trasp
	// Modifica: data[]
	// Invariati: t[], n
    private void traspone(boolean data[], int trasp[], int n) {
        boolean olddata[] = new boolean[data.length];
        System.arraycopy(data,0,olddata,0,data.length);

        for (int i=0; i<n; i++) data[i] = olddata[trasp[i]-1];
	}

    // Ruota key a sinistra di 1 bit su due unita' di 28 bit n volte
    // Modifica: key[]
    private void ruota(boolean key[], int n) {
        boolean oldkey[] = new boolean[key.length];

		for (int z=0; z<n; z++) {
            System.arraycopy(key,0,oldkey,0,key.length);
            for (int i=0; i<55; i++) key[i] = oldkey[i+1];
            key[27] = oldkey[0];
            key[55] = oldkey[28];
		}
	}

	// Funzione principale della cifratura
    // Modifica: key[56], a[64](dove?), x[64]
	// Invariato: i
    private void f(int i, boolean key[], boolean a[], boolean x[]) {
		boolean e[] = new boolean[64];
        boolean ikey[] = new boolean[56];
		boolean y[] = new boolean[48];

        System.arraycopy(a,0,e,0,64);           // Copia testo cifrato in 'e'
        traspone(e,etr,48);                     // Espande primi 32->48 bit

        ruota(key,rots[i]);                     // Ruota la chiave
		
        System.arraycopy(key,0,ikey,0,key.length);  // Copia la chiave
        traspone(ikey,KeyTr2,48);               // Traspone chiave attuale

        for (int j=0; j<48; j++) y[j] = e[j]^ikey[j]; // y[48]=XOR con chiave
		
		for (int k=1; k<=8; k++) {
            int r = (                           // 'r' ha valori in [0..63]
				32*(y[6*k-6] ? 1 : 0) +
				16*(y[6*k-1] ? 1 : 0) +
				 8*(y[6*k-5] ? 1 : 0) +
				 4*(y[6*k-4] ? 1 : 0) +
				 2*(y[6*k-3] ? 1 : 0) +
				 1*(y[6*k-2] ? 1 : 0)        );

            x[4*k-4] = myDM.dispari(s[k-1][r]/8);    // Riempio x[0..31]
			x[4*k-3] = myDM.dispari(s[k-1][r]/4);
			x[4*k-2] = myDM.dispari(s[k-1][r]/2);
			x[4*k-1] = myDM.dispari(s[k-1][r]);
		}
        traspone(x, ptr, 32);                   // Mescola primi 32 di 'x'
	}

	// Algoritmo di cifratura DES privato (singolo blocco):
    // dati plaintext[64] e key[64] riempie ciphertext[64]
    // Modifica: ciphertext[] (distrugge anche key[])
    private boolean[] DEScrypt(boolean plaintext[], boolean longkey[]) {
		boolean ciphertext[] = new boolean[64];
		
		boolean a[] = new boolean[64];
		boolean b[] = new boolean[64];
		boolean x[] = new boolean[64];
        boolean shortkey[] = new boolean[56];

//System.out.print("DEScrypt.pla=");
//myDM.printBooleans(plaintext);

        System.arraycopy(plaintext,0,a,0,64);   // 'a' testo in chiaro
        traspone(a,InitialTr,64);               // Trasposizione iniziale

		for(int f=0;f<64;f++) longkey[f]=false;			// DEBUG
        traspone(longkey,KeyTr1,56);            // Riduce chiave a 56 bit
        System.arraycopy(longkey,0,shortkey,0,56);

        for (int i=0; i<16; i++) {              // 16 iterazioni
            System.arraycopy(a,0,b,0,64);       // 'a' testo cifrato corrente
            for (int j=0; j<32; j++) a[j]=b[j+32];      // sx=dx

            f(i,shortkey,a,x);                          // x=f(r[i-1],k[i])

            for (int j=0; j<32; j++) a[j+32] = b[j]^x[j];   // dx=XOR
/*
System.out.print("Dc.cip("+i+")=");
myDM.printBooleans(a);
*/
		}

        traspone(a,swap,64);                    // Scambia meta' sx/dx
        traspone(a,FinalTr,64);                 // Trasposizione finale

        System.arraycopy(a,0,ciphertext,0,64);  // Testo cifrato

//System.out.print("DEScrypt.cip:");
//myDM.printBooleans(ciphertext);

		return ciphertext;
	}

	// Espande un array di byte fino ad avere una dimensione multipla
	// di 8, appendendo dei caratteri di riempimento (padding) casuali
	// (lo rende idoneo alla cifratura DES di blocchi di 64 bit)
	private byte[] ExpandToBlock(byte input[]) {
		// Se e' gia' multiplo di un blocco non fa nulla
		if (input.length%8==0) return input;

		// Calcola dim attuale e dim richiesta
		int olddim = input.length;
		int newdim = ((int)(olddim/8)+1)*8;

		// Crea array piu' grande e ricopia i primi elementi
		byte output[] = new byte[newdim];
		System.arraycopy(input,0,output,0,olddim);

		// Riempie ultimi elementi con numeri casuali
		int count = newdim-olddim;
		while(count>0) {
			output[olddim+(--count)] = 
				(byte)((256*Math.random())%256-128);
		}
		return output;
	}

	// Cifra l'array di byte in ingresso con il DES
	// secondo il Modo di Operazione ECB (Electronic Codebook)
	public byte[] DESencryptECB(byte plaintext[], byte key[]) {
		
		if (plaintext==null || plaintext.length==0) return null;
		else plaintext = ExpandToBlock(plaintext);

		byte ciphertext[] = new byte[plaintext.length];
		
		int numofblocks = plaintext.length/8;

		boolean boolplain[] = new boolean[64];
		boolean boolkey[] = new boolean[64];
		boolean boolcipher[] = new boolean[64];

		boolkey = myDM.bytesToBooleans(key);

		byte tempblock[] = new byte[8];
		
		for (int zx=0; zx<numofblocks; zx++) {
			System.arraycopy(plaintext,zx*8,tempblock,0,8);
			boolplain = myDM.bytesToBooleans(tempblock);

			boolcipher = DEScrypt(boolplain, boolkey);

			System.arraycopy(myDM.booleansToBytes(boolcipher),0,
				ciphertext,zx*8,8);
		}

		return ciphertext;
	}

	// Decifra l'array precedentemente cifrato in modo ECB
	public byte[] DESdecryptECB(byte ciphertext[], byte key[]) {

		if (ciphertext==null || ciphertext.length==0 ||
			((ciphertext.length%8)!=0) ) return null;

		byte plaintext[] = new byte[ciphertext.length];
		
		int numofblocks = ciphertext.length/8;

		boolean boolcipher[] = new boolean[64];
		boolean boolkey[] = new boolean[64];
		boolean boolplain[] = new boolean[64];

		boolkey = myDM.bytesToBooleans(key);

		byte tempblock[] = new byte[8];
		
		for (int zx=0; zx<numofblocks; zx++) {
			System.arraycopy(ciphertext,zx*8,tempblock,0,8);
			boolcipher = myDM.bytesToBooleans(tempblock);
			
			boolplain = DEScrypt(boolcipher, boolkey);

			System.arraycopy(myDM.booleansToBytes(boolplain),0,
				plaintext,zx*8,8);
		}

		return plaintext;
	}

	// Per il modo di operazione CBC bisogna anche eseguire
	// lo XOR di blocchi di dati di 64 bit
	private boolean[] XOR(boolean a[], boolean b[]) {
		if (a.length!=b.length) return null;
		boolean c[] = new boolean[a.length];

		for (int i=0; i<c.length; i++) c[i]=a[i]^b[i];

		return c;
	}

	// Cifra l'array di byte in ingresso con il DES
	// secondo il Modo di Operazione CBC (Cipher Block Chaining)
	public byte[] DESencryptCBC(byte plaintext[], byte key[],
		byte IV[]) {
		
		if (plaintext==null || plaintext.length==0) return null;
		else plaintext = ExpandToBlock(plaintext);

		byte ciphertext[] = new byte[plaintext.length];
		
		int numofblocks = plaintext.length/8;

		boolean boolplain[] = new boolean[64];
		boolean boolkey[] = new boolean[64];
		boolean boolcipher[] = new boolean[64];

		boolkey = myDM.bytesToBooleans(key);
		boolcipher = myDM.bytesToBooleans(IV);

		byte tempblock[] = new byte[8];
		
		// Cifra un blocco alla volta
		for (int zx=0; zx<numofblocks; zx++) {
			System.arraycopy(plaintext,zx*8,tempblock,0,8);
			boolplain = myDM.bytesToBooleans(tempblock);

			boolplain = XOR(boolplain,boolcipher);
			
			boolcipher = DEScrypt(boolplain, boolkey);
			System.arraycopy(myDM.booleansToBytes(boolcipher),0,
				ciphertext,zx*8,8);
		}

		return ciphertext;
	}

	// Decifra l'array precedentemente cifrato in modo CBC
	public byte[] DESdecryptCBC(byte ciphertext[], byte key[],
		byte IV[]) {

		if (ciphertext==null || ciphertext.length==0) return null;
		else ciphertext = ExpandToBlock(ciphertext);

		byte plaintext[] = new byte[ciphertext.length];
		
		int numofblocks = ciphertext.length/8;

		boolean boolcipher[] = new boolean[64];
		boolean boolkey[] = new boolean[64];
		boolean boolplain[] = new boolean[64];
		boolean boolmem[] = new boolean[64];

		boolkey = myDM.bytesToBooleans(key);
		boolmem = myDM.bytesToBooleans(IV);

		byte tempblock[] = new byte[8];
		
		// Decifra un blocco alla volta
		for (int zx=0; zx<numofblocks; zx++) {
			System.arraycopy(ciphertext,zx*8,tempblock,0,8);
			boolcipher = myDM.bytesToBooleans(tempblock);
			
			boolplain = DEScrypt(boolcipher, boolkey);

			boolplain = XOR(boolplain,boolmem);
			System.arraycopy(boolcipher,0,boolmem,0,64);

			System.arraycopy(myDM.booleansToBytes(boolplain),0,
				plaintext,zx*8,8);
		}

		return plaintext;
	}
/*
	// Si inizia con plaintext[64], key[64], ciphertext[64]
	public void testDES() {
		boolean plaintext[] = new boolean[64];
		boolean key[] = new boolean[64];
		boolean ciphertext[] = new boolean[64];

		// Prima prova
        myDM.hexToBooleans(0x0123456789abcde7L,plaintext);
        myDM.hexToBooleans(0x0L,key);
        ciphertext = DEScrypt(plaintext, key);
		
		// Seconda prova
        System.arraycopy(ciphertext,0,plaintext,0,64);
        myDM.hexToBooleans(0x0L,key);
        ciphertext = DEScrypt(plaintext, key);
	}
*/
	// Provo tutto
	public void testALL() {
		String strings[] = {"Pippo","pappo","peppo","turiddu"};
		byte key[] = {10,20,30,40,50,60,70,80};
		byte IV[] = {8,7,6,5,4,3,2,1};
		byte plain[];
		byte cipher[];
		
		// Prova ECB
		
		// Cifro
		plain = myDM.packStringsIntoBytes(strings);
		cipher = DESencryptECB(plain,key);

		// Qui posso trasmettere i bytes (cipher)
System.out.print("ECBcipher:");
myDM.printBytes(cipher);
		
		// Decifro
		plain = DESdecryptECB(cipher,key);
		strings = myDM.unpackStringsFromBytes(plain);
		if (strings!=null) {
			System.out.println("Num.stringhe="+strings.length);
			for(int i=0;i<strings.length;i++) System.out.println(strings[i]);
		}

		// Prova CBC
		
		// Cifro
		plain = myDM.packStringsIntoBytes(strings);
		cipher = DESencryptCBC(plain,key,IV);

		// Qui posso trasmettere i bytes (cipher)
System.out.print("CBCcipher:");
myDM.printBytes(cipher);
		
		// Decifro
		plain = DESdecryptCBC(cipher,key,IV);
		strings = myDM.unpackStringsFromBytes(plain);
		if (strings!=null) {
			System.out.println("Num.stringhe="+strings.length);
			for(int i=0;i<strings.length;i++) System.out.println(strings[i]);
		}
	}

	// Procedura principale utilizzata per la prova.
	public static void main(String args[]) {
		DES myDES = new DES();

		myDES.testALL();
	
	}
}
