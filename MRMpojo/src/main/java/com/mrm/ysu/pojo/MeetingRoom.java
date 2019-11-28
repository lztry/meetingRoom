package com.mrm.ysu.pojo;

public class MeetingRoom {
    private Integer id;

    private Integer scale;

    private String name;

    private Integer departmentId;

    private Integer capacity;

    private Integer multimedia;

    private Integer deviceState;

    private Integer isCheck;

    private Integer aheadTime;

    private Integer isDel;
    
    private String departmentName;
    
    private Integer roomState=1; //0表示已被占用  1表示可使用 2表示未到预约时间
    
    private String realName; //预约会议室的人
    
    private Integer appointNum; //预约会议室的数目
    
    private String roomNum; //会议室号
    
    public String getRoomNum() {
        return roomNum;
    }

    public void setRoomNum(String roomNum) {
        this.roomNum = roomNum;
    }

    public Integer getAppointNum() {
        return appointNum;
    }

    public void setAppointNum(Integer appointNum) {
        this.appointNum = appointNum;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public Integer getRoomState() {
        return roomState;
    }

    public void setRoomState(Integer roomState) {
        this.roomState = roomState;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public String getDepartmentName() {
		return departmentName;
	}

	public void setDepartmentname(String departmentName) {
		this.departmentName = departmentName;
	}

	public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getScale() {
        return scale;
    }

    public void setScale(Integer scale) {
        this.scale = scale;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public Integer getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(Integer departmentId) {
        this.departmentId = departmentId;
    }

    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }

    public Integer getMultimedia() {
        return multimedia;
    }

    public void setMultimedia(Integer multimedia) {
        this.multimedia = multimedia;
    }

    public Integer getDeviceState() {
        return deviceState;
    }

    public void setDeviceState(Integer deviceState) {
        this.deviceState = deviceState;
    }

    public Integer getIsCheck() {
        return isCheck;
    }

    public void setIsCheck(Integer isCheck) {
        this.isCheck = isCheck;
    }

    public Integer getAheadTime() {
        return aheadTime;
    }

    public void setAheadTime(Integer aheadTime) {
        this.aheadTime = aheadTime;
    }

    public Integer getIsDel() {
        return isDel;
    }

    public void setIsDel(Integer isDel) {
        this.isDel = isDel;
    }

	@Override
	public String toString() {
		return "MeetingRoom [id=" + id + ", scale=" + scale + ", name=" + name + ", departmentId=" + departmentId
				+ ", capacity=" + capacity + ", multimedia=" + multimedia + ", deviceState=" + deviceState
				+ ", isCheck=" + isCheck + ", aheadTime=" + aheadTime + ", isDel=" + isDel + "]";
	}
    
}