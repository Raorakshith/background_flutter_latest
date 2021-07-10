package com.example.background_flutter_latest.background_flutter_latest;

import android.Manifest;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Timer;
import java.util.TimerTask;

import static android.content.ContentValues.TAG;

public class MyService extends Service {
    private String lats,longs;
private RequestQueue mRequestQueue;
private StringRequest mStringRequest;
LocationManager locationManager;
private Timer timer;
private TimerTask timerTask;
    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        createNotificationChannel();
        createNotificationChannel1();
        Intent intent1 = new Intent(this,MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this,0,intent1,0);
        Notification notification = new NotificationCompat.Builder(this,"ChannelId1").setContentTitle("Background Check")
                .setContentText("Applicaton running...")
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentIntent(pendingIntent).build();
        startForeground(1,notification);
        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
        if (!locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {

        } else {
            startTimer();
        }
        //getLocation();
        return START_STICKY;
    }

    @Override
    public void onCreate() {

        super.onCreate();

    }

    private void apiCall(String latt, String longr){
        String url = "https://api.weatherbit.io/v2.0/current?lat="+latt+"&lon="+longr+"&key=ac09fe29ca4b4e82875275042501e5d7";

        mRequestQueue = Volley.newRequestQueue(this);
        mStringRequest = new StringRequest(Request.Method.GET,url,new Response.Listener<String>(){

            @Override
            public void onResponse(String response) {
               // Toast.makeText(MyService.this, "Response:"+response.toString(), Toast.LENGTH_SHORT).show();
                try {
                    //getting the whole json object from the response
                    JSONObject obj = new JSONObject(response);

                    //we have the array named tutorial inside the object
                    //so here we are getting that json array
                    JSONArray tutorialsArray = obj.getJSONArray("data");

                    //now looping through all the elements of the json array
                    for (int i = 0; i < 1; i++) {
                        //getting the json object of the particular index inside the array
                        JSONObject tutorialsObject = tutorialsArray.getJSONObject(i);
                        String uvvalue = tutorialsObject.getString("uv").substring(0,1);
                        //Toast.makeText(MyService.this, "uvvalue:"+uvvalue, Toast.LENGTH_SHORT).show();
                        int uvindex = Integer.parseInt(uvvalue);
                        if(uvindex >= 3 && uvindex<=5){
                            buildNotification();
                        }
                        //creating a tutorial object and giving them the values from json object
//                        Tutorial tutorial = new Tutorial(tutorialsObject.getString("name"), tutorialsObject.getString("imageurl"),tutorialsObject.getString("description"));
//
//                        //adding the tutorial to tutoriallist
//                        tutorialList.add(tutorial);
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }

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
    private void getLocation() {
        if (ActivityCompat.checkSelfPermission(
                this,Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
           // ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_LOCATION);
        } else {
            Location locationGPS = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
            if (locationGPS != null) {
                double lat = locationGPS.getLatitude();
                double longi = locationGPS.getLongitude();
                lats = String.valueOf(lat);
                longs = String.valueOf(longi);
                apiCall(lats,longs);
            } else {
                //Toast.makeText(this, "Unable to find location.", Toast.LENGTH_SHORT).show();
            }
        }
    }
    private void createNotificationChannel1() {
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
        {
            NotificationChannel notificationChannel= new NotificationChannel(
                    "Reminder","Foreground Notification", NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(notificationChannel);
        }
    }
    private void buildNotification(){
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this,"Reminder");
        builder.setContentTitle("Reminder");
        builder.setContentText("This is your vitamin D robot. This is the best time to get more vitamin D to get more sunlight");
        builder.setSmallIcon(R.mipmap.ic_launcher);
        builder.setAutoCancel(true);
        NotificationManagerCompat managerCompat = NotificationManagerCompat.from(this);
        managerCompat.notify(2,builder.build());
    }
    private void startTimer(){
        timer = new Timer();
        timerTask = new TimerTask() {
            @Override
            public void run() {
                Log.d("Running", "run: good");
                //Toast.makeText(MyService.this, "running", Toast.LENGTH_SHORT).show();
                getLocation();
            }
        };
        timer.schedule(timerTask,5000,300000);
    }
}
