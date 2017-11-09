package com.yourcompany.gbgcontroller;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

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

public class MainActivity extends FlutterActivity {

  private GbgBluetoothManager btManager;
  
  private static final String CHANNEL = "gbg.bluetooth";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    
    btManager = new GbgBluetoothManager(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
        new MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall call, Result result) {
            if(call.method.equals("scan")) {
              final Result scanResult = result;
              btManager.scanBt(new Task() {
                @Override
                public void run() {
                  scanResult.success(btManager.getFoundAddresses());  
                }
              });
            } else if(call.method.equals("connect")) {
              btManager.connectBt();
            } else if(call.method.equals("toggle")) {
              btManager.toggle();
            }
          }
        });
  }
}

