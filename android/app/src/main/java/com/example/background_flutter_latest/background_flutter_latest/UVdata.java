package com.example.background_flutter_latest.background_flutter_latest;
public class UVdata {
    public String uvindex;
    public String time;

    public UVdata(String uvindex, String time) {
        this.uvindex = uvindex;
        this.time = time;
    }

    public UVdata() {
    }

    public String getUvindex() {
        return uvindex;
    }

    public void setUvindex(String uvindex) {
        this.uvindex = uvindex;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }
}
