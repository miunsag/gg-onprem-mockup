package SoftwareAG.Mockup.util;

// -----( IS Java Code Template v1.2

import com.wm.data.*;
import com.wm.util.Values;
import com.wm.app.b2b.server.Service;
import com.wm.app.b2b.server.ServiceException;
// --- <<IS-START-IMPORTS>> ---
// --- <<IS-END-IMPORTS>> ---

public final class j

{
	// ---( internal utility methods )---

	final static j _instance = new j();

	static j _newInstance() { return new j(); }

	static j _cast(Object o) { return (j)o; }

	// ---( server methods )---




	public static final void generateRandomStringOfGivenLength (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(generateRandomStringOfGivenLength)>> ---
		// @sigtype java 3.5
		// [i] field:0:required length
		// [o] field:0:required generatedString
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
		String length = IDataUtil.getString(pipelineCursor, "length");
		pipelineCursor.destroy();
		
		Long l = 0l;
		if (null == length || "".equals(length))
			length = "512"; // default value
		try{
			l = Long.parseLong(length);
		}catch(NumberFormatException nfe){
			throw new ServiceException("Cannot generate random string of non number length: " + length);
		}
		
		
		// chose a Character random from this String
		String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "0123456789" + "abcdefghijklmnopqrstuvxyz";
		
		// create StringBuffer size of AlphaNumericString
		StringBuilder sb = new StringBuilder();
		
		for (int i = 0; i < l; i++) {
		
		// generate a random number between
		// 0 to AlphaNumericString variable length
			int index = (int) (AlphaNumericString.length() * Math.random());
		
			// add Character one by one in end of sb
			sb.append(AlphaNumericString.charAt(index));
		}
		
		// pipeline
		IDataCursor pipelineCursor_1 = pipeline.getCursor();
		IDataUtil.put(pipelineCursor_1, "generatedString", sb.toString());
		pipelineCursor_1.destroy();
			
		// --- <<IS-END>> ---

                
	}



	public static final void probabilityException (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(probabilityException)>> ---
		// @sigtype java 3.5
		// [i] field:0:required probability
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
			String	probability = IDataUtil.getString( pipelineCursor, "probability" );
		pipelineCursor.destroy();
		
		if( null == probability || "".equals(probability))
			throw new ServiceException("Null or empty probability number!");
		
		try{
			Double p = Double.parseDouble(probability);
			if (p<0  || p>1)
				throw new ServiceException("Probability must be >0 and <1, actual value is " + p);
			if( new java.util.Random().nextDouble() <= p ) {  
				   throw new ServiceException("Random probability exception hit!");
				}
		}catch(NumberFormatException nfe){
			throw new ServiceException("Given probability is not a valid number: " + probability );
		}
		
		// pipeline
			
		// --- <<IS-END>> ---

                
	}



	public static final void sleep (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(sleep)>> ---
		// @sigtype java 3.5
		// [i] field:0:required sleepMillis
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
			String	sleepMillis = IDataUtil.getString( pipelineCursor, "sleepMillis" );
		pipelineCursor.destroy();
		
		if ( null != sleepMillis && (! "".equals(sleepMillis)))
			try {
				Long l=Long.parseLong(sleepMillis);
				Thread.sleep(l);
			} catch (InterruptedException e) {
				throw new ServiceException("Sleeping beauty awakened!");
			} catch (NumberFormatException nfe){
				throw new ServiceException("Cannot sleep for a non number value: " + sleepMillis);
			}
		// --- <<IS-END>> ---

                
	}
}

