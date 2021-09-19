package com.example.background_flutter_latest.background_flutter_latest;

import android.Manifest;
import android.app.ActivityManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.os.Binder;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.android.gms.location.ActivityRecognitionClient;
import com.google.android.gms.location.DetectedActivity;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Timer;
import java.util.TimerTask;

import static android.content.ContentValues.TAG;

public class MyService extends Service {
    private String TAG = MyService.class.getSimpleName();
    BroadcastReceiver broadcastReceiver;
    BackgroundDetectedActivitiesService ab;
    static int v = 0;
    private String lats,longs;
private RequestQueue mRequestQueue;
private StringRequest mStringRequest;
LocationManager locationManager;
private Timer timer;
private TimerTask timerTask;


    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        super.onStartCommand(intent, flags, startId);
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
            ab = new BackgroundDetectedActivitiesService();
            // services not running already
            // start services
            if (!isMyServiceRunning(ab.getClass())) {




                v =0;
                startTracking();

            }

            else{

               // Toast.makeText(MainActivity.this,   "Service Already Running", Toast.LENGTH_LONG).show();

            }
            startTimer();
        }
        broadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (intent.getAction().equals(Constants.BROADCAST_DETECTED_ACTIVITY)) {
                    int type = intent.getIntExtra("type", -1);
                    int confidence = intent.getIntExtra("confidence", 0);
                    handleUserActivity(type, confidence);
                }
            }
        };
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
        timer.schedule(timerTask,1000,300000);
    }




    // check your background services
    private boolean isMyServiceRunning(Class<?> serviceClass) {
        ActivityManager manager = (ActivityManager) getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (serviceClass.getName().equals(service.service.getClassName())) {
                Log.i ("Service statu", "Running");
                return true;
            }
        }
        Log.i ("Service status", "Not running");
        return false;
    }

    private void handleUserActivity(int type, int confidence) {
        String label = getString(R.string.activity_unknown);
       // int icon = R.drawable.ic_baseline_accessibility_24;


        switch (type) {
            case DetectedActivity.IN_VEHICLE: {
                label = getString(R.string.activity_in_vehicle);
               // icon = R.drawable.ic_baseline_drive_eta_24;
                break;
            }
            case DetectedActivity.ON_BICYCLE: {
                label = getString(R.string.activity_on_bicycle);
                //icon = R.drawable.ic_baseline_directions_bike_24;
                break;
            }
            case DetectedActivity.ON_FOOT: {
                label = getString(R.string.activity_on_foot);
               // icon = R.drawable.ic_baseline_directions_walk_24;
                break;
            }
            case DetectedActivity.RUNNING: {
                label = getString(R.string.activity_running);
                //icon = R.drawable.ic_baseline_run_circle_24;
                break;
            }
            case DetectedActivity.STILL: {
                label = getString(R.string.activity_still);
                //icon = R.drawable.ic_baseline_accessibility_24;

                break;
            }
            case DetectedActivity.TILTING: {
                label = getString(R.string.activity_tilting);
               // icon = R.drawable.ic_baseline_filter_tilt_shift_24;
                break;
            }
            case DetectedActivity.WALKING: {
                label = getString(R.string.activity_walking);
                //icon = R.drawable.ic_baseline_directions_walk_24;
                break;
            }
            case DetectedActivity.UNKNOWN: {
                label = getString(R.string.activity_unknown);
                //icon = R.drawable.ic_baseline_device_unknown_24;

                break;
            }
        }

        Log.e(TAG, "User activity: " + label + ", Confidence: " + confidence);



        if(v ==0 ){


            v = confidence;
//            txtActivity.setText(label);
//            txtConfidence.setText("Confidence: " + confidence);
//            imgActivity.setImageResource(icon);

        }
        else{


            if(confidence > 50){

                v = confidence;
//                txtActivity.setText(label);
//                txtConfidence.setText("Confidence: " + confidence);
//                imgActivity.setImageResource(icon);


            }

            else if (v <= confidence) {

//                txtActivity.setText(label);
//                txtConfidence.setText("Confidence: " + confidence);
//                imgActivity.setImageResource(icon);
            }



        }

    }



    // check your background services



//    @Override
//    protected void onResume() {
//        super.onResume();
//
//        LocalBroadcastManager.getInstance(this).registerReceiver(broadcastReceiver,
//                new IntentFilter(Constants.BROADCAST_DETECTED_ACTIVITY));
//    }
//
//    @Override
//    protected void onPause() {
//        super.onPause();
//
//        LocalBroadcastManager.getInstance(this).unregisterReceiver(broadcastReceiver);
//    }

    private void startTracking() {
        Intent intent = new Intent(MyService.this, BackgroundDetectedActivitiesService.class);
        startService(intent);
    }

    private void stopTracking() {
        Intent intent = new Intent(MyService.this, BackgroundDetectedActivitiesService.class);
        stopService(intent);
    }
//    @Override
//    protected void onResume() {
//        super.onResume();
//
//        LocalBroadcastManager.getInstance(this).registerReceiver(broadcastReceiver,
//                new IntentFilter(Constants.BROADCAST_DETECTED_ACTIVITY));
//    }
//
//    @Override
//    protected void onPause() {
//        super.onPause();
//
//        LocalBroadcastManager.getInstance(this).unregisterReceiver(broadcastReceiver);
//    }


}
