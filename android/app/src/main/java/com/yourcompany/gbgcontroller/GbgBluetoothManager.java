package com.yourcompany.gbgcontroller;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Handler;
import android.content.BroadcastReceiver;
import android.os.ParcelUuid;
import android.bluetooth.le.ScanSettings;
import android.bluetooth.le.ScanFilter;
import android.bluetooth.le.ScanResult;
import android.bluetooth.le.ScanCallback;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.BluetoothGattCallback;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothProfile;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattService;
import java.util.UUID;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Timer;
import java.util.TimerTask;

public class GbgBluetoothManager {

  private MainActivity activity;

  //Final variables associated with connecting to the arduino 
  private final String blueAddress = "30:AE:A4:38:7B:6A";
  private final UUID btUuid = UUID.fromString("000000ff-0000-1000-8000-00805f9b34fb");
  private final UUID SERVICE_UUID = UUID.fromString("000000ff-0000-1000-8000-00805f9b34fb");
  private final UUID CHARACTERISTIC_UUID = UUID.fromString("0000ff01-0000-1000-8000-00805f9b34fb");
  
  //Used to scan and then connect to a bluetooth device
  private BluetoothAdapter btAdapter;
  private BluetoothLeScanner bluetoothLeScanner;
  private BluetoothGatt btGatt;

  //Objects for handling the results of scans and connection attempts
  private GattCallback gattCallback;
  private BlueScanCallback scanCallback;
  private ArrayList<BluetoothDevice> scanResults; 

  //The bluetooth device that the app will try to connect to, determined currently by if the
  //scan finds a device matching blueAddress above
  private BluetoothDevice btDevice;

  //Is the app connected to a bluetooth device
  private boolean btConnected;
  //Has the bluetooth service and characteristic been connected, is the app to read and write to the device
  private boolean serviceReady = false;

  //Is the light on or off, currently is set at runtime without regard to the status
  //of the physical light upon connection
  private boolean on = false;

  private Timer timer = new Timer();
  private int SCAN_TIME = 10*1000;

  public GbgBluetoothManager(MainActivity activity) {
    this.activity = activity;

    final BluetoothManager bluetoothManager = (BluetoothManager) activity.getSystemService(Context.BLUETOOTH_SERVICE);
    btAdapter = bluetoothManager.getAdapter();

    requestForBluetoothIfDisabled();
  }

  public void scanBt() {
    scanBt(new Task() {
      @Override
      public void run() {}
    });
  }

  public void scanBt(final Task finishTask) {
    ArrayList<ScanFilter> filters = new ArrayList<ScanFilter>();

    //Filters the scan results so only devices with UUID btUUID are found
    //ScanFilter scanFilter = new ScanFilter.Builder().setServiceUuid(new ParcelUuid(btUuid)).build();
    //filters.add(scanFilter);
    ScanSettings settings = new ScanSettings.Builder().build();

    scanResults = new ArrayList<BluetoothDevice>();
    scanCallback = new BlueScanCallback();

    bluetoothLeScanner = btAdapter.getBluetoothLeScanner();
    bluetoothLeScanner.startScan(filters, settings, scanCallback);
    
    timer.schedule(new TimerTask() {
      @Override
      public void run() {
        stopScan();
        filterScanResults();
        getUuids();
        finishTask.run();
      }
    }, SCAN_TIME);
  }

  public void stopScan() {
    bluetoothLeScanner.stopScan(scanCallback);
  }

  public void connectBt() {
    GattCallback gattCallback = new GattCallback();
    btGatt = btDevice.connectGatt(activity, false, gattCallback);
  }

  private void filterScanResults() {
    ArrayList<BluetoothDevice> filtered = new ArrayList<BluetoothDevice>();
    filtered.add(scanResults.get(0));
    for(int i = 1; i < scanResults.size(); i++) {
      boolean found = false;
      for(int j = 0; j < filtered.size(); j++) {
        if(filtered.get(j).getAddress().equals(scanResults.get(i).getAddress())) {
          found = true;
        }
      }
      if(!found) {
        filtered.add(scanResults.get(i));
      }
    }
    scanResults = filtered;
  }

  private void getUuids() {
    /*for(BluetoothDevice d : scanResults) {
      ParcelUuid[] uuids = d.getUuids();
      System.out.println(uuids.length);
    }*/
  }

  /* Sends a byte to the connected device based on whether boolean on is true or false.
   * Fails if device is not connected or services have not been discovered.
   */
  public boolean toggle() {
    if(!btConnected) {
      System.out.println("Failed to write to bluetooth because no device is connected");
      return false;
    }
    if(!serviceReady) {
      System.out.println("Failed to write to bluetooth because the service has not been discovered. Call gatt.discoverServices()");
      return false;
    }
    else { 
      System.out.println("Attempting to write to bluetooth connection");
      BluetoothGattService service = btGatt.getService(SERVICE_UUID);
      BluetoothGattCharacteristic characteristic = service.getCharacteristic(CHARACTERISTIC_UUID);
      byte[] b = new byte[1];
      on = !on;
      if(on) {
        b[0] = 1;
      } else {
        b[0] = 0;
      }
      characteristic.setValue(b);
      boolean success = btGatt.writeCharacteristic(characteristic);
      System.out.println("Bluetooth write: " + success);
      return true;
    }
  }

  /* Determines whether the phone's bluetooth is on and if not, pops up a dialog box asking to
   * turn it on.
   */
  private void requestForBluetoothIfDisabled() {
    if(btAdapter == null || !btAdapter.isEnabled()) {
      Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);

      //The second argument below is the request code that can be used
      //to identify an intent activity in the case of multiple ones
      activity.startActivityForResult(enableBtIntent, 1);
    }
  }

  public ArrayList<BluetoothDevice> getFoundDevices() {
    return scanResults;
  }

  public ArrayList<String> getFoundAddresses() {
    ArrayList<String> add = new ArrayList<String>();
    for(BluetoothDevice d : scanResults) {
      add.add(d.getAddress());
    }
    return add;
  }

  /* This class handles the results of btAdapter's scan and puts all found devices 
   * into the HashMap scanResults 
   */
  private class BlueScanCallback extends ScanCallback {
    @Override
    public void onScanResult(int callbackType, ScanResult result) {
      addScanResult(result);
    }

    @Override
    public void onBatchScanResults(List<ScanResult> results) {
      for (ScanResult result : results) {
        addScanResult(result);
      }
    }

    @Override
    public void onScanFailed(int errorCode) {
      System.out.println("Bluetooth: Scanning failed with code " + errorCode);
    }

    /* Adds devices found in the scan to the HashMap scanResults.
     * Devices are accessed in the HashMap by their bluetooth address
     */
    private void addScanResult(ScanResult result) {
      BluetoothDevice device = result.getDevice();
      String deviceAddress = device.getAddress();
      System.out.println("Discovered bluetooth device " + deviceAddress + " - " + device.getName());
      
      scanResults.add(device);
      

      //Bypasses the user choosing a device to connect to by setting btDevice (the device that is
      //attmpted to connect to) to whichever device has the bluetooth address blueAddress.
      //In other words, the device the app will connect to is hard-coded in right now. 
      if(deviceAddress.equals(blueAddress)) {
        btDevice = device;
      }
    }
  }

  /* Handles the results of a connection attempt. Closes the gatt server if connection fails, and discovers the device's services if connection succeeds.
   */
  private class GattCallback extends BluetoothGattCallback {
    @Override
    public void onConnectionStateChange(BluetoothGatt gatt, int status, int newState) {
      super.onConnectionStateChange(gatt, status, newState);

      if(status == BluetoothGatt.GATT_FAILURE) {
        disconnectGattServer();
        System.out.println("Connect returned GATT_FAILURE");
        return;
      }
      else if (status != BluetoothGatt.GATT_SUCCESS) {
        disconnectGattServer();
        System.out.println("Connect returned something other than GATT_SUCCESS");
        return;
      }

      if(newState == BluetoothProfile.STATE_CONNECTED) {
        btConnected = true;
        gatt.discoverServices();
        System.out.println("CONNECTED!!");
      }
      else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
        disconnectGattServer();
        System.out.println("BluetoothProfile returned disconnected");
      }
    }

    /* If the bluetooth devices has been successfully connected to, attempt to connect to the
     * preset service and characterstic the device will be using.
     */
    public void onServicesDiscovered(BluetoothGatt gatt, int status) {
      super.onServicesDiscovered(gatt, status);
      if(status != BluetoothGatt.GATT_SUCCESS) {
        System.out.println("Returned something other than GATT_SUCCESS when discovering services.");
        return;
      }

      BluetoothGattService service = gatt.getService(SERVICE_UUID);
      BluetoothGattCharacteristic characteristic = service.getCharacteristic(CHARACTERISTIC_UUID);
      characteristic.setWriteType(BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT);
      serviceReady = gatt.setCharacteristicNotification(characteristic, true);
    }

    public void disconnectGattServer() {
      btConnected = false;
      if(btGatt != null) {
        btGatt.disconnect();
        btGatt.close();
      }
    }
  }
}
