package com.example.background_flutter_latest.background_flutter_latest;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.location.LocationManager;
import android.os.Build;
import android.os.IBinder;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

public class MyService extends Service {
    private String lats,longs;
private RequestQueue mRequestQueue;
private StringRequest mStringRequest;
LocationManager locationManager;
private String url = "https://api.weatherbit.io/v2.0/current?lat="+lats+"&lon="+longs+"&key=ac09fe29ca4b4e82875275042501e5d7";
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        createNotificationChannel();
        Intent intent1 = new Intent(this,MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this,0,intent1,0);
        Notification notification = new NotificationCompat.Builder(this,"ChannelId1").setContentTitle("Background Check")
                .setContentText("Applicaton running...")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentIntent(pendingIntent).build();
        startForeground(1,notification);
        apiCall();
        return START_STICKY;
    }

    @Override
    public void onCreate() {
        super.onCreate();
    }

    private void apiCall(){
        mRequestQueue = Volley.newRequestQueue(this);
        mStringRequest = new StringRequest(Request.Method.GET,url,new Response.Listener<String>(){

            @Override
            public void onResponse(String response) {
                Toast.makeText(MyService.this, "Response:"+response.toString(), Toast.LENGTH_SHORT).show();
            }
        },new Response.ErrorListener(){

            @Override
            public void onErrorResponse(VolleyError error) {

            }
        });
        mRequestQueue.add(mStringRequest);
}
    private void createNotificationChannel() {
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
        {
            NotificationChannel notificationChannel= new NotificationChannel(
                    "ChannelId1","Foreground Notification", NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(notificationChannel);
        }
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        Intent broadcastintent = new Intent();
        broadcastintent.setAction("restartservice");
        broadcastintent.setClass(this,Restarter.class);
        this.sendBroadcast(broadcastintent);
        super.onDestroy();
    }
}
