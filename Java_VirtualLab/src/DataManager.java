/*
 * @(#)DataManager.java
 *
 * Classe di supporto per impacchettare e ricomporre i dati
 *
 * @author	Fabrizio Fazzino
 * @version	1.0		1996/XI/16
 */

import java.io.*;

public class DataManager {

	/* Quando voglio spedire delle stringhe nel socket,
	esse non vengono trasformate direttamente in bytes
	ma viene creata una struttura del seguente tipo:

		bytes[0] = n = numero di stringhe;
		bytes[1]...bytes[n] = lunghezza di ognuna delle n stringhe;
		bytes[n+1]...bytes[n+bytes[1]] = stringa 0;
		bytes[n+bytes[1]+1]...bytes[n+bytes[1]+bytes[2]] = stringa 1;
		...
		bytes[n+bytes[1]+...+bytes[n-1]+1]...bytes[n+bytes[1]+..+bytes[n]] =
			= stringa n-1

	In tal modo la destinazione può facilmente compiere
	il procedimento inverso per ricavare le stringhe.

	Nel caso in cui i dati debbano essere cifrati, essi alla sorgente
	vanno prima impacchettati in array di byte, poi cifrati e spediti,
	e alla destinazione vanno decifrati e ricomposti come stringhe.

	N.B. Si vede che deve valere la proprietà:
		bytes.length == bytes[0]+bytes[1]+...+bytes[n]+1
	In pratica però mi accontento che sia >= , perché la cifratura
	potrebbe richiedere l'aggiunta di caratteri di riempimento.
	*/

	// Impacchetta le stringhe in array di byte con formattazione
	// ( String[] -> byte[] )
	public byte[] packStringsIntoBytes(String strings[]) {
		byte bytes[] = null;

		if (strings!=null && strings.length!=0) {
			int args = strings.length;
			int totalLength = 0;
			for (int s=0; s<args; s++)
				totalLength += strings[s].length();

			bytes = new byte[1+args+totalLength];
			bytes[0] = (byte)args;
			for (int a=0; a<args; a++) {
				int offset = 1+args;
				for (int k=0; k<a; k++)
					offset += strings[k].length();
				
				bytes[a+1] = (byte)strings[a].length();
				strings[a].getBytes(0,strings[a].length(),bytes,offset);
			}
		}

		return bytes;
	}

	// Ricompone l'array di stringhe originario
	// ( byte[] -> String[] )
	public String[] unpackStringsFromBytes(byte bytes[]) {
		String strings[] = null;

		if (bytes==null || bytes.length==0) {
			return strings;
		} else {
			int n = bytes[0];
			if (bytes.length < n+1) {
				return strings;
			} else {
				int utilBytes=1;
				for (int z=0; z<=n; z++)
					utilBytes += bytes[z];
				if (utilBytes > bytes.length) {
					return strings;
				} else {
					strings = new String[n];
					for (int i=0; i<n; i++) {
						int count = (int)bytes[i+1];
						int offset=1;
						for (int x=0; x<=i; x++)
							offset += bytes[x];
						strings[i] = new String(bytes,0,offset,count);
					}
				}
			}
		}
		return strings;
	}
/*
	// La stessa formattazione può applicarsi anche ai bytes

	// Impacchetta le stringhe in array di byte da spedire
	public byte[] packStringsIntoBytes(String strings[]) {
		byte bytes[] = null;

		if (strings!=null && strings.length!=0) {
			int args = strings.length;
			int totalLength = 0;
			for (int s=0; s<args; s++)
				totalLength += strings[s].length();

			bytes = new byte[1+args+totalLength];
			bytes[0] = (byte)args;
			for (int a=0; a<args; a++) {
				int offset = 1+args;
				for (int k=0; k<a; k++)
					offset += strings[k].length();
				
				bytes[a+1] = (byte)strings[a].length();
				strings[a].getBytes(0,strings[a].length(),bytes,offset);
			}
		}

		return bytes;
	}

	// Ricompone i dati tirati fuori dal socket
	public String[] unpackStringsFromBytes(byte bytes[]) {
		String strings[] = null;

		if (bytes==null || bytes.length==0) {
			return strings;
		} else {
			int n = bytes[0];
			if (bytes.length < n+1) {
				return strings;
			} else {
				int utilBytes=1;
				for (int z=0; z<=n; z++)
					utilBytes += bytes[z];
				if (utilBytes > bytes.length) {
					return strings;
				} else {
					strings = new String[n];
					for (int i=0; i<n; i++) {
						int count = (int)bytes[i+1];
						int offset=1;
						for (int x=0; x<=i; x++)
							offset += bytes[x];
						strings[i] = new String(bytes,0,offset,count);
					}
				}
			}
		}
		return strings;
	}
*/
	// Metodi utili per la stampa

	// Stampa un array di boolean come sequenza di 0 e 1
	public void printBooleans(boolean array[]) {
		for(int z=0; z<array.length; z++)
			System.out.print((array[z] ? 1 : 0));
		System.out.println();
	}	

	// Stampa array di byte come numeri separati da virgole
	public void printBytes(byte array[]) {
		if(array!=null && array.length>0) {
			System.out.print(array[0]);
			for(int z=1; z<array.length; z++) {
				System.out.print(","+array[z]);
			}
			System.out.println();
		}
	}

    // Indica se il numero e' dispari o meno:
    public boolean dispari(long numero) {
		return ((numero%2)==1);
	}

	// Metodi di conversione
    
	// Converte da long (es.hex) a boolean[64] (piu' significativo a sx)
    // Modifica: out[64], hex
    public void hexToBooleans(long hex, boolean out[]) {
        if ((hex>=0)&&(hex<=0x7fffffffffffffffL)) {
            for (int n=0; n<64; n++) {
                out[n] = dispari (hex >> (63-n));
            }
        } else {         
            hex += (0x7fffffffffffffffL+1);
            out[0] = true;
            for (int n=1; n<64; n++) {
                out[n] = dispari (hex >> (63-n));
            }
        }
    }

	// Converte stringa di 0 e 1 in boolean[]
	public boolean[] stringToBooleans(String string) {
		boolean booleans[] = new boolean[string.length()];

		for (int i=0; i<string.length(); i++) {
			if (string.charAt(i)=='0') booleans[i]=false;
			else if (string.charAt(i)=='1') booleans[i]=true;
			else return null;
		}
		return booleans;
	}

	// Converte boolean[] in stringa di 0 e 1
	public String booleansToString(boolean booleans[]) {
		StringBuffer string = new StringBuffer();

		for (int i=0; i<booleans.length; i++) {
			if (booleans[i]) string.append('1');
			else string.append('0');
		}
		return string.toString();
	}

	// Conversione singola byte -> boolean[8] usata dalla seguente
	public boolean[] byteToBooleans(byte input) {
		boolean output[] = new boolean[8];
		
		if (input<0) {
			output[0] = true;
			input = (byte)(128+(int)input);
		} else {
			output[0] = false;
		}
		for (int i=0; i<7; i++) {
			if (dispari(input >> i)) output[7-i]=true;
			else output[7-i]=false;
		}
		return output;
	}

	// Converte byte[] -> boolean[] (dim*8)
	public boolean[] bytesToBooleans(byte bytes[]) {
		boolean booleans[];
		
		if (bytes==null || bytes.length==0) return null;
		else booleans = new boolean[bytes.length*8];

		for (int s=0; s<bytes.length; s++) {
			System.arraycopy(byteToBooleans(bytes[s]),0,booleans,s*8,8);
		}

		return booleans;
	}

	// Conversione singola boolean[8] -> byte usata dalla seguente
	public byte booleansToByte(boolean input[]) {
		byte output = 0;

		for (int i=0; i<8; i++) {
			if (input[i]) output += (byte)Math.pow(2,7-i);
		}
		return output;
	}

	// Converte boolean[] -> byte[] (dim/8 per eccesso)
	public byte[] booleansToBytes(boolean booleans[]) {
		byte bytes[];
		
		if (booleans==null || booleans.length==0) return null;
		else if(booleans.length%8==0) bytes = new byte[booleans.length/8];
		else bytes = new byte[booleans.length/8+1];
		
		boolean temp[] = new boolean[8];
		for (int z=0; z<bytes.length; z++) {
			System.arraycopy(booleans,8*z,temp,0,8);
			bytes[z] = booleansToByte(temp);
		}

		return bytes;
	}

	// Converte long -> byte[2]
	public byte[] longToTwoBytes(long in) {
		byte out[] = new byte[2];

		out[1] = (byte)(in % 256);
		out[0] = (byte)((in/256) % 256);

		return out;
	}

	// Converte long -> byte[3]
	public byte[] longToThreeBytes(long in) {
		byte out[] = new byte[3];

		out[2] = (byte)(in % 256);
		out[1] = (byte)((in/256) % 256);
		out[0] = (byte)(((in/256)/256) % 256);

		return out;
	}

	// Converte long -> byte[8]
	public byte[] longToEightBytes(long in) {
		byte out[] = new byte[8];
		
		boolean sign = (in<0);			// conservo segno e lo tolgo
		if (sign) in+=Long.MAX_VALUE+1;

		for (int i=0; i<8; i++) {
			out[7-i] = (byte)( (in/(long)(Math.pow(256,i))) % 256 );
		}
		
		if (sign) out[0]+=(byte)128;	// rimetto il segno
		
		return out;
	}

	// Converte byte[2] -> long
	public long twoBytesToLong(byte in[]) {
		if (in.length!=2) return 0;
		
		int temp[] = new int[2];
		temp[0] = ( (in[0]>=0) ? (int)in[0] : ((int)in[0])+256 );
		temp[1] = ( (in[1]>=0) ? (int)in[1] : ((int)in[1])+256 );
		
		return (long)(temp[0]*256+temp[1]);
	}

	// Converte byte[3] -> long
	public long threeBytesToLong(byte in[]) {
		if (in.length!=3) return 0;
		
		int temp[] = new int[3];
		temp[0] = ( (in[0]>=0) ? (int)in[0] : ((int)in[0])+256 );
		temp[1] = ( (in[1]>=0) ? (int)in[1] : ((int)in[1])+256 );
		temp[2] = ( (in[2]>=0) ? (int)in[2] : ((int)in[2])+256 );
		
		return (long)(temp[0]*256*256+temp[1]*256+temp[2]);
	}

	// Converte byte[8] -> long
	public long eightBytesToLong(byte in[]) {
		if (in.length!=8) return 0;
		boolean sign = (in[0]<0);
		long out;
		
		if (sign) {
			in[0] += (byte)128;
			out = (-1)*(Long.MAX_VALUE+1);
		} else {
			out = 0;
		}
		int temp[] = new int[8];
		for (int i=0; i<8; i++) {
			temp[i] = ( (in[i]>=0) ? (int)in[i] : ((int)in[i])+256 );
			out += temp[i]*(long)Math.pow(256,7-i);
		}
		
		return out;
	}

	// Converte String -> byte[]
	public byte[] stringToBytes(String in) {
		if (in.length()==0) return null;

		byte out[] = new byte[in.length()];
		
		// String.getBytes(int Str_start, int Str_end+1, byte[], byte_start)
		in.getBytes(0,in.length(),out,0);

		return out;
	}

	// Converte byte[] -> String
	public String bytesToString(byte in[]) {
		if (in.length==0) return null;
		
		// Costr. String(byte[], int hi, int byte_start, int byte_tot)
		// oppure String(byte[], int hi)
		String out = new String(in,0);

		return out;
	}
}