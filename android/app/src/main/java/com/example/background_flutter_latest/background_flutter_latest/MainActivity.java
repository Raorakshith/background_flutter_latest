package com.example.background_flutter_latest.background_flutter_latest;

import android.Manifest;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private Intent forService;
    private static final int REQUEST_LOCATION = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //GeneratedPluginRegistrant.registerWith(this);
        forService = new Intent(MainActivity.this,MyService.class);
        ActivityCompat.requestPermissions( MainActivity.this,
                new String[] {Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_LOCATION);
        new MethodChannel(getFlutterEngine().getDartExecutor(),"my.login_page.vitamind.messages").setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if(call.method.equals("startService")){
                    startservice();
                    result.success("Service started");
                }
            }
        });
        if(!isMyServiceRunning(new MyService().getClass())){
            startservice();
        }
    }
    private void startservice(){
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            startForegroundService(forService);
        }else {
            startService(forService);
        }
    }

    @Override
    protected void onDestroy() {
        stopService(forService);
        Intent broadcastintent = new Intent();
        broadcastintent.setAction("restartservice");
        broadcastintent.setClass(this,Restarter.class);
        this.sendBroadcast(broadcastintent);
        super.onDestroy();
    }
    private  boolean isMyServiceRunning(Class<?> serviceClass){
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        for(ActivityManager.RunningServiceInfo serviceInfo : manager.getRunningServices(Integer.MAX_VALUE)){
            if(serviceClass.getName().equals(serviceInfo.service.getClassName())){
                return true;
            }
        }
        return false;
    }
}
