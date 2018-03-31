/*
 * @(#)CryptographyLibrary.java
 *
 * Libreria di algoritmi crittografici RSA e DES
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XII/30
 */

public class CryptographyLibrary {
	private RSA myRSA;
	private DES myDES;

	// Costruttore
	public CryptographyLibrary() {
		myRSA = new RSA();
		myDES = new DES();
	}

	// Metodi dell'algoritmo RSA

	// Inizializzazione dell'algoritmo RSA
	// (torna long { n, e, d } )
	public long[] RSAstart() {
//		return myRSA.RSAstart();

		long ret[] = { 0,0,0 };
		return ret;
	}

	// Cifratura RSA byte[] -> byte[] ( dim. *2 -> *3 )
	// (ingresso e' riempito fino ad essere di lunghezza multipla di 2)
	// (l'uscita ha dimensione sempre multipla di 3)
	public byte[] RSAencrypt (byte plain[], long n, long e) {
//		return myRSA.RSAencrypt(plain,n,e);

		byte ret[] = new byte[plain.length];
		System.arraycopy(plain,0,ret,0,plain.length);
		return ret;
	}

	// Decifratura RSA byte[] -> byte[] ( dim. *3 -> *2 )
	public byte[] RSAdecrypt (byte cipher[], long n, long d) {
//		return myRSA.RSAdecrypt(cipher,n,d);

		byte ret[] = new byte[cipher.length];
		System.arraycopy(cipher,0,ret,0,cipher.length);
		return ret;
	}

	// Metodi dell'algoritmo DES

 	// Cifra l'array di byte in ingresso con il DES
	// secondo il Modo di Operazione ECB (Electronic Codebook)
	// ( byte[n*8] -> byte[n*8] )
	// ( se ingresso non e' [n*8] appendo padding casuali )
	public byte[] DESencryptECB(byte plaintext[], byte key[]) {
		return myDES.DESencryptECB(plaintext,key);

//		byte ret[] = new byte[plaintext.length];
//		System.arraycopy(plaintext,0,ret,0,plaintext.length);
//		return ret;
	}

	// Decifra array cifrato col DES in modo ECB
	public byte[] DESdecryptECB(byte ciphertext[], byte key[]) {
		return myDES.DESdecryptECB(ciphertext,key);

//		byte ret[] = new byte[ciphertext.length];
//		System.arraycopy(ciphertext,0,ret,0,ciphertext.length);
//		return ret;
	}

	// Cifra l'array di byte in ingresso con il DES
	// secondo il Modo di Operazione CBC (Cipher Block Chaining)
	public byte[] DESencryptCBC(byte plaintext[], byte key[],
		byte IV[]) {

		return myDES.DESencryptCBC(plaintext,key,IV);

//		byte ret[] = new byte[plaintext.length];
//		System.arraycopy(plaintext,0,ret,0,plaintext.length);
//		return ret;
	}

	// Decifra l'array precedentemente cifrato in modo CBC
	public byte[] DESdecryptCBC(byte ciphertext[], byte key[],
		byte IV[]) {

		return myDES.DESdecryptCBC(ciphertext,key,IV);

//		byte ret[] = new byte[ciphertext.length];
//		System.arraycopy(ciphertext,0,ret,0,ciphertext.length);
//		return ret;
	}
}