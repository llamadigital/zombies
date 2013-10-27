package com.example.zombie;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.IntentFilter.MalformedMimeTypeException;
import android.nfc.NdefMessage;
import android.nfc.NdefRecord;
import android.nfc.NfcAdapter;
import android.nfc.Tag;
import android.nfc.tech.Ndef;
import android.nfc.tech.NdefFormatable;
import android.os.Bundle;
import android.os.Parcelable;
import android.os.StrictMode;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.util.EntityUtils;

public class MainActivity extends Activity {
	private WebView webView;
    private static final String baseUrl = "http://172.20.10.2:27015/";
    private static final String TAG = "Zombie";
    private boolean isInsideBluetoothArea = true;
    private String bluetoothAddressArea = "00:22:58:C9:09:42";
    private boolean mResumed = false;
    private boolean mWriteMode = false;
    NfcAdapter mNfcAdapter;
    EditText mNote;

    PendingIntent mNfcPendingIntent;
    IntentFilter[] mWriteTagFilters;
    IntentFilter[] mNdefExchangeFilters;
    BluetoothAdapter bluetoothAdapter;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy); 
        
        mNfcAdapter = NfcAdapter.getDefaultAdapter(this);
        //bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
        //bluetoothAdapter.startDiscovery();
        
        setContentView(R.layout.activity_main);
        webView = (WebView) findViewById(R.id.webView); 
        webView.setWebViewClient(new WebViewClient());
        webView.loadUrl(baseUrl);
        

        // Handle all of our received NFC intents in this activity.
        //mNfcPendingIntent = PendingIntent.getActivity(this, 0,
        //        new Intent(this, getClass()).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP), 0);

        // Intent filters for reading a note from a tag or exchanging over p2p.
        IntentFilter ndefDetected = new IntentFilter(NfcAdapter.ACTION_NDEF_DISCOVERED);
        try {
            ndefDetected.addDataType("text/plain");
        } catch (MalformedMimeTypeException e) { }
        mNdefExchangeFilters = new IntentFilter[] { ndefDetected };
        
        /*registerReceiver(ActionFoundReceiver, 
                new IntentFilter(BluetoothDevice.ACTION_FOUND));
        registerReceiver(ActionFoundReceiver, 
                new IntentFilter(BluetoothAdapter.ACTION_DISCOVERY_FINISHED));*/

    }
 
   /* @Override
    protected void onDestroy() {
     // TODO Auto-generated method stub
     super.onDestroy();
     unregisterReceiver(ActionFoundReceiver);
    }*/    
    
    private void CheckBlueToothState(){
        if (bluetoothAdapter == null){
            Log.i("Bluetooth Response","Bluetooth NOT support");
           }else{
            if (bluetoothAdapter.isEnabled()){
             if(bluetoothAdapter.isDiscovering()){
            	 Log.i("Bluetooth Response","Bluetooth is currently in device discovery process.");
             }else{
            	 Log.i("Bluetooth Response","Bluetooth is Enabled.");
             }
            }else{
             Log.i("Bluetooth Response","Bluetooth is NOT Enabled!");
             Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
                startActivityForResult(enableBtIntent, 1);
            }
        }
     }
    
    private final BroadcastReceiver ActionFoundReceiver = new BroadcastReceiver(){

    	  @Override
    	  public void onReceive(Context context, Intent intent) {
    	   // TODO Auto-generated method stub
    	   String action = intent.getAction();
    	   if(BluetoothDevice.ACTION_FOUND.equals(action)) {
    	       BluetoothDevice device = intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE);
    	       int rssi = intent.getShortExtra(BluetoothDevice.EXTRA_RSSI,Short.MIN_VALUE);
               Log.i("Device available",device.getName() + "\n" + device.getAddress()+ "\n" + rssi + "dBm\n");
               if(checkBluetoothMac(device.getAddress())){
            	   isInsideBluetoothArea = true; 
            	   bluetoothAddressArea = device.getAddress();
               }
    	   }else if (BluetoothAdapter.ACTION_DISCOVERY_FINISHED.equals(action))
           {
    		   if(isInsideBluetoothArea){
    			   isInsideBluetoothArea = false;
    			   bluetoothAddressArea = "";
    		   }else{
    			   getJsonRequest(baseUrl + bluetoothAddressArea + "/" + "outofrange");
    		   }
               Log.v(TAG,"Entered the Finished ");
               //bluetoothAdapter.startDiscovery();
           }
    	   
    	  }
    };
    
    private boolean checkBluetoothMac(String mac){
    	String json_response = "true";//getJsonRequest(baseUrl + mac);
    	if(json_response.equals("true")){
    		return true;
    	}else{
    		return false;
    	}
    }
    
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
     super.onActivityResult(requestCode, resultCode, data);
     if(resultCode==RESULT_OK){
        Intent refresh = new Intent(this, MainActivity.class);
        startActivity(refresh);
        this.finish();
     }
    }    

    @Override
    protected void onResume() {
        super.onResume();
        // Sticky notes received from Android
        if (NfcAdapter.ACTION_NDEF_DISCOVERED.equals(getIntent().getAction())) {
        	mResumed = true;
            NdefMessage[] messages = getNdefMessages(getIntent());
            byte[] payload = messages[0].getRecords()[0].getPayload();
            String result = "";
            for (int b = 3; b<payload.length; b++) {
                result += (char) payload[b];
            }
            setNoteBody(result);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        mResumed = false;
        mNfcAdapter.disableForegroundNdefPush(this);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        if (mWriteMode && NfcAdapter.ACTION_TAG_DISCOVERED.equals(intent.getAction())) {
            Tag detectedTag = intent.getParcelableExtra(NfcAdapter.EXTRA_TAG);
            writeTag(getNoteAsNdef(), detectedTag);
        }
    }

    private void setNoteBody(String arg) {
    	if(mResumed){
    		String url = "";
    		try{
    			Integer.parseInt(arg);
    			url = getJsonRequest(baseUrl + "api/tag/" + arg) ;
    		}catch(Exception e){
    			url = baseUrl + arg;
    		}
	        webView.getSettings().setJavaScriptEnabled(true);
	        webView.loadUrl(url);
	        mResumed = false;
    	}
    }
    
    private String getJsonRequest(String url){
    	Log.i("Tag id",url);
    	HttpClient httpClient = new DefaultHttpClient();
    	HttpPost httpPost = new HttpPost(url);
    	// Depends on your web service
    	httpPost.setHeader("Content-type", "application/json");

    	InputStream inputStream = null;
    	String result = "";
    	try {
    	    HttpResponse response = httpClient.execute(httpPost);   
		    HttpEntity entity = response.getEntity();
	
		    if (entity != null) {
		    	InputStream instream = entity.getContent();
		        result= convertStreamToString(instream);
		        instream.close();
		    }
		    Log.i("Response",result);
    	}catch (Exception e) { 
    		Log.i("IOException", e.toString());
    	}
    	return result;
   }

    private static String convertStreamToString(InputStream is) {
	    BufferedReader reader = new BufferedReader(new InputStreamReader(is));
	    StringBuilder sb = new StringBuilder();
	
	    String line = null;
	    try {
	        while ((line = reader.readLine()) != null) {
	            sb.append(line + "\n");
	        }
	    } catch (IOException e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            is.close();
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    }
	    return sb.toString();
    }    
    
    private NdefMessage getNoteAsNdef() {
        byte[] textBytes = mNote.getText().toString().getBytes();
        NdefRecord textRecord = new NdefRecord(NdefRecord.TNF_MIME_MEDIA, "text/plain".getBytes(),
                new byte[] {}, textBytes);
        return new NdefMessage(new NdefRecord[] {
            textRecord
        });
    }

    NdefMessage[] getNdefMessages(Intent intent) {
        // Parse the intent
        NdefMessage[] msgs = null;
        String action = intent.getAction();
        if (NfcAdapter.ACTION_TAG_DISCOVERED.equals(action)
                || NfcAdapter.ACTION_NDEF_DISCOVERED.equals(action)) {
            Parcelable[] rawMsgs = intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES);
            if (rawMsgs != null) {
                msgs = new NdefMessage[rawMsgs.length];
                for (int i = 0; i < rawMsgs.length; i++) {
                    msgs[i] = (NdefMessage) rawMsgs[i];
                }
            } else {
                // Unknown tag type
                byte[] empty = new byte[] {};
                NdefRecord record = new NdefRecord(NdefRecord.TNF_UNKNOWN, empty, empty, empty);
                NdefMessage msg = new NdefMessage(new NdefRecord[] {
                    record
                });
                msgs = new NdefMessage[] {
                    msg
                };
            }
        } else {
            Log.d(TAG, "Unknown intent.");
            finish();
        }
        return msgs;
    }

    boolean writeTag(NdefMessage message, Tag tag) {
        int size = message.toByteArray().length;

        try {
            Ndef ndef = Ndef.get(tag);
            if (ndef != null) {
                ndef.connect();

                if (!ndef.isWritable()) {
                    toast("Tag is read-only.");
                    return false;
                }
                if (ndef.getMaxSize() < size) {
                    toast("Tag capacity is " + ndef.getMaxSize() + " bytes, message is " + size
                            + " bytes.");
                    return false;
                }

                ndef.writeNdefMessage(message);
                toast("Wrote message to pre-formatted tag.");
                return true;
            } else {
                NdefFormatable format = NdefFormatable.get(tag);
                if (format != null) {
                    try {
                        format.connect();
                        format.format(message);
                        toast("Formatted tag and wrote message");
                        return true;
                    } catch (IOException e) {
                        toast("Failed to format tag.");
                        return false;
                    }
                } else {
                    toast("Tag doesn't support NDEF.");
                    return false;
                }
            }
        } catch (Exception e) {
            toast("Failed to write tag");
        }

        return false;
    }

    private void toast(String text) {
        Toast.makeText(this, text, Toast.LENGTH_SHORT).show();
    }
}