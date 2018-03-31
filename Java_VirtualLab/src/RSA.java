/*
 * @(#)RSA.java
 *
 * Classe con tutti gli strumenti per la cifratura RSA
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XII/27
 */

public class RSA {
	DataManager myDM;

	// Costruttore
	public RSA() {
		myDM = new DataManager();
	}

	// Algoritmo di Euclide per trovare il Massimo Comune Divisore
	// (gcd = greatest common divisor) di due numeri interi
	public long Euclid(long d, long f) {
		long X = f;
		long Y = d;
		long R;

		while (true) {
			if (Y==0) return X;
			R = X % Y;
			X = Y;
			Y = R;
		}
	}

	// Algoritmo Esteso di Euclide per trovare il MCD (in long[0])
	// e se possibile (MCD=1) anche l'inverso moltiplicativo (long[1])
	// ( se l'inverso non esiste torna long[1]=0 )
	public long[] ExtendedEuclid(long d, long f) {
		long out[] = { 0, 0 };
		long X1,X2,X3,Y1,Y2,Y3,T1,T2,T3,Q;

		X1=1; X2=0; X3=f; Y1=0; Y2=1; Y3=d;

		while (true) {
			if (Y3==0) {
				out[0] = X3;		// MCD
				return out;			// torna { MCD, 0 }
			}
			if (Y3==1) {
				out[0] = Y3;		// MCD
				if (Y2>0 && (((d*Y2)%f)==1))
					out[1] = Y2;	// inverso (inv d mod f)
				else
					out[1] = 0;		// per la Legge di Murphy
				return out;			// torna { MCD=1, inverso }
			}
			Q = X3 / Y3;		// prendo il quoziente
			T1=X1-Q*Y1; T2=X2-Q*Y2; T3=X3-Q*Y3;
			X1=Y1; X2=Y2; X3=Y3;
			Y1=T1; Y2=T2; Y3=T3;
		}
	}

	// Il test di primalita' di Rabin Miller dice se e' probabile che
	// l'argomento sia un numero primo (esegue il test singolo 5 volte)
	public boolean RabinMiller(long p) {
		return RabinMiller(p, 5);
	}
	
	// Il test di primalita' di Rabin Miller dice se e' probabile che
	// l'argomento sia un numero primo (esegue test singolo 'times' volte)
	public boolean RabinMiller(long p, int times) {
		long test[] = {2,3,5,7,11,13,17,19,23,29,31,37,41,43,47};
		long a,b,m;

		// Elimino le estrazioni errate
		if (p<=1) return false;

		// Se e' divisibile per uno dei numeri di test non e' primo
		for (int x=0; x<test.length; x++) {
			if ((p%test[x])==0) return false;
		}

		// 'b' e' l'exp della max pot di 2 che divide p-1
		long temp = p-1;
		b = 0;
		while(true) {
			if (!myDM.dispari(temp)) {
				b++;
				temp = temp/2;
			} else {
				break;
			}
		}

		// 'm' e' tale che p=1+pow(2,b)*m
		m = (long)((p-1)/(long)Math.pow(2,b));
		
		// E' probabilmente primo se supera il test 'times' volte
		for (int i=0; i<times; i++) {
			
			// Genera un numero casuale a<p
			do {
				a = (long)(Math.random()*(double)p);
			} while(a>=p || a==0);

			if(!singleRabinMiller(p,a,b,m)) return false;
		}
		return true;
	}

	// Procedura usata per un singolo test di primalita'
	// (la procedura pubblica chiama questa 5 o n volte)
	private boolean singleRabinMiller(long p, long a, long b, long m) {
		long j = 0;
		long z = (((long)Math.pow(a,m)) % p);

		if (z==1 || z==p-1) return true;	// questo test e' superato
			
		while (true) {
			if (j>0 && z==1) return false;	// di sicuro non e' primo
			j++;
			if (j<b && z!=p-1) {
				z = ((z*z) % p);
			} else {
				if (z==p-1) return true;	// questo test e' superato
				if (j==b && z!=p-1) return false;
				break;
			}
		}
		return false;
	}

	// Restituisce un numero primo casuale sufficientemente grande
	// (da 2^8 a 2^12, così il prodotto di 2 sara' da 2^16 a 2^24)
	public long getLongPrime() {
		return getLongPrime(260,4094);
	}

	// Restituisce un numero primo casuale compreso tra min e max
	public long getLongPrime(long min, long max) {
		long number;

		while (true) {
			number = min + (long)(Math.random()*(double)(max-min));

			if (number%2==0) number--;
			if (RabinMiller(number)) return number;
		}
	}

	// Inizializzazione dell'algoritmo RSA
	// (torna { n, e, d } )
	public long[] RSAstart() {
		long p,q,n,e,d;
		long temp[];
		long Murphy[] = { 0, 47, 64, 99, 126 };
		boolean OK = false;

		do {
			// Trova p, q, n
			p = getLongPrime();
			q = getLongPrime();
			n = p*q;

			// Calcola d, e
			while (true) {
				d = getLongPrime();
				temp = ExtendedEuclid(d,(p-1)*(q-1));
				if (temp[0]==1 && temp[1]!=0) {
					e = temp[1];
					break;
				}
			}
		
			// Fa alcune prove anti-jella (Legge di Murphy)
			OK = true;
			for (int i=0; i<Murphy.length; i++) {
				if (Murphy[i]!=RSAdecryptLong(RSAencryptLong(Murphy[i],n,e),n,d))
					OK = false;
			}
		} while (!OK);
		
		// Fornisce in uscita { n, e, d }
		long out[] = { n, e, d };
		return out;
	}

	// Procedura per eseguire potenze intere in modulo
	// (svolge long = ((long)Math.pow(a,b) % n); senza overflow
	public long PowMod(long a, long b, long n) {
		if (a==1 || b==0) return 1;		// Casi banali
		if (a==0) return 0;
		if (n==0 || n==1) return 0;		// In caso di errore
		
		a = a % n;		
		long result = a;
		
		// Eseguo (b-1) prodotti
		for (int i=1; i<b; i++) {
			result = result * a;
			result = result % n;
		}
		return result;
	}

	// Algoritmo di cifratura RSA ( long -> long )
	private long RSAencryptLong(long plain, long n, long e) {

		return PowMod(plain,e,n);
	}

	// Algoritmo di decifratura RSA ( long -> long )
	private long RSAdecryptLong(long cipher, long n, long d) {

		return PowMod(cipher,d,n);
	}

	// Cifratura RSA byte[2] -> byte[3]
	private byte[] RSAencrypt2bytes(byte plain[], long n, long e) {
		if (plain.length!=2) return null;
		
		long cipher = RSAencryptLong(myDM.twoBytesToLong(plain),n,e);
		
		return myDM.longToThreeBytes(cipher);
	}

	// Decifratura RSA byte[3] -> byte[2]
	private byte[] RSAdecrypt3bytes(byte cipher[], long n, long d) {
		if (cipher.length!=3) return null;
		
		long plain = RSAdecryptLong(myDM.threeBytesToLong(cipher),n,d);
		
		return myDM.longToTwoBytes(plain);
	}

	// Cifratura RSA byte[] -> byte[] ( dim. *2 -> *3 )
	public byte[] RSAencrypt (byte plain[], long n, long e) {
		// Calcola il numero di blocchi da cifrare
		int numblocks = ((plain.length-1)/2+1);

		// Copia plain in nuovo array newplain di dimensione pari (n*2)
		byte newplain[] = new byte[numblocks*2];
		System.arraycopy(plain,0,newplain,0,plain.length);
		if (newplain.length>plain.length) newplain[newplain.length-1]=0;
		
		// Crea array cipher di dimensione 3/2 di newplain
		byte cipher[] = new byte[numblocks*3];

		// Riempie tre alla volta gli elementi di cipher		
		byte temp[] = new byte[2];
		for (int i=0; i<numblocks; i++) {
			System.arraycopy(newplain,2*i,temp,0,2);
			System.arraycopy(RSAencrypt2bytes(temp,n,e),0,cipher,3*i,3);
		}
		return cipher;
	}

	// Decifratura RSA byte[] -> byte[] ( dim. *3 -> *2 )
	public byte[] RSAdecrypt (byte cipher[], long n, long d) {
		// Calcola il numero di blocchi da cifrare
		int numblocks = ((cipher.length-1)/3+1);
		
		// Copia cipher in nuovo array newcipher (dim=k*3)
		byte newcipher[] = new byte[numblocks*3];
		System.arraycopy(cipher,0,newcipher,0,cipher.length);
		if (newcipher.length>cipher.length) {
			newcipher[newcipher.length-1]=0;
			if (newcipher.length>cipher.length+1)
				newcipher[newcipher.length-2]=0;
		}
		
		// Crea array plain di dimensione 2/3 di newcipher
		byte plain[] = new byte[numblocks*2];

		// Riempie due alla volta gli elementi di cipher		
		byte temp[] = new byte[3];
		for (int i=0; i<numblocks; i++) {
			System.arraycopy(newcipher,3*i,temp,0,3);
			System.arraycopy(RSAdecrypt3bytes(temp,n,d),0,plain,2*i,2);
		}
		return plain;
	}

	// Procedura di prova dell'algoritmo RSA
	public void testRSA() {

		// Inizializzo RSA
		long data[] = RSAstart();
		long n = data[0];
		long e = data[1];
		long d = data[2];

		// Prova
		byte plain[] = { 0, 12, 34, -68, -13, 127, -128 };
		byte cipher[];
		byte replain[];

		System.out.println("(n,e,d)="+n+","+e+","+d);
		System.out.print("Plain : ");
		myDM.printBytes(plain);

		cipher = RSAencrypt(plain,n,e);
		System.out.print("Cipher : ");
		myDM.printBytes(cipher);

		replain = RSAdecrypt(cipher,n,d);
		System.out.print("Replain : ");
		myDM.printBytes(replain);
	}	
	

	// Procedura principale usata per la prova
	public static void main(String args[]) {
		RSA myRSA = new RSA();

		myRSA.testRSA();
	}

}
