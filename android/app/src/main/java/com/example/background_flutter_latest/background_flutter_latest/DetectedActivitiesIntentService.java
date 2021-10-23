package com.example.background_flutter_latest.background_flutter_latest;
import android.Manifest;
import android.app.IntentService;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationManager;
import android.util.Log;

import androidx.core.app.ActivityCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.google.android.gms.location.ActivityRecognitionResult;
import com.google.android.gms.location.DetectedActivity;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

public class DetectedActivitiesIntentService extends IntentService {
    private FirebaseUser user;
    protected static final String TAG = DetectedActivitiesIntentService.class.getSimpleName();
    private DatabaseReference mRef;
    private FirebaseAuth mAuth = FirebaseAuth.getInstance();
    private String lats,longs;
    private RequestQueue mRequestQueue;
    private StringRequest mStringRequest;
    LocationManager locationManager;
    Calendar cal = Calendar.getInstance();
    int uvindex;
    SimpleDateFormat simpleformat = new SimpleDateFormat("hh:mm:a");
    public DetectedActivitiesIntentService() {
// Use the TAG to name the worker thread.
        super(TAG);
    }

    @Override
    public void onCreate() {
        super.onCreate();

        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);

    }

    @SuppressWarnings("unchecked")
    @Override
    protected void onHandleIntent(Intent intent) {
        ActivityRecognitionResult result = ActivityRecognitionResult.extractResult(intent);

// Get the list of the probable activities associated with the current state of the
// device. Each activity is associated with a confidence level, which is an int between
// 0 and 100.
        ArrayList<DetectedActivity> detectedActivities = (ArrayList) result.getProbableActivities();

        for (DetectedActivity activity : detectedActivities) {
            Log.e(TAG, "Detected activity: " + activity.getType() + ", " + activity.getConfidence());
            handleUserActivity(activity.getType(), activity.getConfidence());
            broadcastActivity(activity);
        }
    }

    private void broadcastActivity(DetectedActivity activity) {
        Intent intent = new Intent(Constants.BROADCAST_DETECTED_ACTIVITY);
        intent.putExtra("type", activity.getType());
        intent.putExtra("confidence", activity.getConfidence());
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }
    private void handleUserActivity(int type, int confidence) {
        if (FirebaseAuth.getInstance().getCurrentUser() != null) {
            mRef = FirebaseDatabase.getInstance().getReference("User Data").child(mAuth.getCurrentUser().getUid()).child("SunTrack Data");

            String label = getString(R.string.activity_unknown);
            // int icon = R.drawable.ic_baseline_accessibility_24;


            switch (type) {
                case DetectedActivity.IN_VEHICLE: {
                    label = getString(R.string.activity_in_vehicle);
                    // icon = R.drawable.ic_baseline_drive_eta_24;
                    android.util.Log.d(TAG, "handleUserActivity: VEHICLE");
                    break;
                }
                case DetectedActivity.ON_BICYCLE: {
                    label = getString(R.string.activity_on_bicycle);
                    android.util.Log.d(TAG, "handleUserActivity: BICYCLE");
                    //icon = R.drawable.ic_baseline_directions_bike_24;
                    break;
                }
                case DetectedActivity.ON_FOOT: {
                    label = getString(R.string.activity_on_foot);
                    // icon = R.drawable.ic_baseline_directions_walk_24;
                    android.util.Log.d(TAG, "handleUserActivity: FOOT");
                    break;
                }
                case DetectedActivity.RUNNING: {
                    label = getString(R.string.activity_running);
                    android.util.Log.d(TAG, "handleUserActivity: RUNNING");
                    //icon = R.drawable.ic_baseline_run_circle_24;
                    break;
                }
                case DetectedActivity.STILL: {
                    label = getString(R.string.activity_still);
                    android.util.Log.d(TAG, "handleUserActivity: STILL");
                    //icon = R.drawable.ic_baseline_accessibility_24;

                    break;
                }
                case DetectedActivity.TILTING: {
                    label = getString(R.string.activity_tilting);
                    android.util.Log.d(TAG, "handleUserActivity: TILT");
                    // icon = R.drawable.ic_baseline_filter_tilt_shift_24;
                    break;
                }
                case DetectedActivity.WALKING: {
                    label = getString(R.string.activity_walking);
                    android.util.Log.d(TAG, "handleUserActivity: WALK");
                    //icon = R.drawable.ic_baseline_directions_walk_24;
                    break;
                }
                case DetectedActivity.UNKNOWN: {
                    label = getString(R.string.activity_unknown);
                    android.util.Log.d(TAG, "handleUserActivity: UNKNOWN");
                    //icon = R.drawable.ic_baseline_device_unknown_24;

                    break;
                }
            }
            //SunTrackItem sunTrackItem = new SunTrackItem(simpleformat.format(cal.getTime()), simpleformat.format(cal.getTime()), getLocation(), label);

            //mRef.child(mRef.push().getKey()).setValue(sunTrackItem);

            Log.e(TAG, "User activity: " + label + ", Confidence: " + confidence);


//
//        if(v ==0 ){
//
//
//            v = confidence;
//            android.util.Log.d(TAG, "handleUserActivity: "+label);
////            txtActivity.setText(label);
////            txtConfidence.setText("Confidence: " + confidence);
////            imgActivity.setImageResource(icon);
//
//        }
//        else{
//
//
//            if(confidence > 50){
//
//                v = confidence;
//                android.util.Log.d(TAG, "handleUserActivity: "+label);
//
////                txtActivity.setText(label);
////                txtConfidence.setText("Confidence: " + confidence);
////                imgActivity.setImageResource(icon);
//
//
//            }
//
//            else if (v <= confidence) {
//                android.util.Log.d(TAG, "handleUserActivity: "+label);
//
////                txtActivity.setText(label);
////                txtConfidence.setText("Confidence: " + confidence);
////                imgActivity.setImageResource(icon);
//            }
//
//
//
//        }

        }
    }
//    public String getLocation() {
//        if (ActivityCompat.checkSelfPermission(
//                this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
//                this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
//            // ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, REQUEST_LOCATION);
//        } else {
//            Location locationGPS = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
//            if (locationGPS != null) {
//                double lat = locationGPS.getLatitude();
//                double longi = locationGPS.getLongitude();
//                lats = String.valueOf(lat);
//                longs = String.valueOf(longi);
//                apiCall(lats,longs);
//                Log.d(TAG, "getLocation: "+apiCall(lats,longs));
//                FirebaseDatabase.getInstance().getReference("apicall").setValue(apiCall(lats,longs));
//            } else {
//                //Toast.makeText(this, "Unable to find location.", Toast.LENGTH_SHORT).show();
//            }
//        }
//        return apiCall(lats,longs);
//    }
//    private String apiCall(String latt, String longr){
//        String url = "https://api.weatherbit.io/v2.0/current?lat="+latt+"&lon="+longr+"&key=ac09fe29ca4b4e82875275042501e5d7";
//
//        mRequestQueue = Volley.newRequestQueue(this);
//        mStringRequest = new StringRequest(Request.Method.GET,url,new Response.Listener<String>(){
//
//            @Override
//            public void onResponse(String response) {
//                // Toast.makeText(MyService.this, "Response:"+response.toString(), Toast.LENGTH_SHORT).show();
//                try {
//                    //getting the whole json object from the response
//                    JSONObject obj = new JSONObject(response);
//
//                    //we have the array named tutorial inside the object
//                    //so here we are getting that json array
//                    JSONArray tutorialsArray = obj.getJSONArray("data");
//
//                    //now looping through all the elements of the json array
//                    for (int i = 0; i < 1; i++) {
//                        //getting the json object of the particular index inside the array
//                        JSONObject tutorialsObject = tutorialsArray.getJSONObject(i);
//                        String uvvalue = tutorialsObject.getString("uv").substring(0,1);
//                        //Toast.makeText(MyService.this, "uvvalue:"+uvvalue, Toast.LENGTH_SHORT).show();
//                         uvindex = Integer.parseInt(uvvalue);
//
//                        //creating a tutorial object and giving them the values from json object
////                        Tutorial tutorial = new Tutorial(tutorialsObject.getString("name"), tutorialsObject.getString("imageurl"),tutorialsObject.getString("description"));
////
////                        //adding the tutorial to tutoriallist
////                        tutorialList.add(tutorial);
//                    }
//
//                } catch (JSONException e) {
//                    e.printStackTrace();
//                }
//
//            }
//        },new Response.ErrorListener(){
//
//            @Override
//            public void onErrorResponse(VolleyError error) {
//
//            }
//        });
//        mRequestQueue.add(mStringRequest);
//        return String.valueOf(uvindex);
//    }
}
