package com.example.background_flutter_latest.background_flutter_latest;
public class SunTrackItem {
    String starttime;
    String endtime;
    String uvindex;
    String activity;

    public SunTrackItem() {
    }

    public SunTrackItem(String starttime, String endtime, String uvindex, String activity) {
        this.starttime = starttime;
        this.endtime = endtime;
        this.uvindex = uvindex;
        this.activity = activity;
    }

    public String getStarttime() {
        return starttime;
    }

    public void setStarttime(String starttime) {
        this.starttime = starttime;
    }

    public String getEndtime() {
        return endtime;
    }

    public void setEndtime(String endtime) {
        this.endtime = endtime;
    }

    public String getUvindex() {
        return uvindex;
    }

    public void setUvindex(String uvindex) {
        this.uvindex = uvindex;
    }

    public String getActivity() {
        return activity;
    }

    public void setActivity(String activity) {
        this.activity = activity;
    }
}
