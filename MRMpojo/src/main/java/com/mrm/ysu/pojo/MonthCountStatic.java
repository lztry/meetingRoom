package com.mrm.ysu.pojo;

public class MonthCountStatic {
    Integer monthValue;
    String monthDate;
    Integer appointCount = 0;
    public Integer getMonthValue() {
        return monthValue;
    }
    public void setMonthValue(Integer monthValue) {
        this.monthValue = monthValue;
    }
    public String getMonthDate() {
        return monthDate;
    }
    public void setMonthDate(String monthDate) {
        this.monthDate = monthDate;
    }
    public Integer getAppointCount() {
        return appointCount;
    }
    public void setAppointCount(Integer appointCount) {
        this.appointCount = appointCount;
    }
    @Override
    public String toString() {
        return "MonthCountStatic [" + (monthValue != null ? "monthValue=" + monthValue + ", " : "")
                + (monthDate != null ? "monthDate=" + monthDate + ", " : "")
                + (appointCount != null ? "appointCount=" + appointCount : "") + "]";
    }
}
