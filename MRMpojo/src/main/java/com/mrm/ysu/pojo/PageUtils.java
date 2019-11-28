package com.mrm.ysu.pojo;

import java.util.List;

public class PageUtils<T> {
    private Object page;
    private List<T> resultList;
    public Object getPage() {
        return page;
    }
    public void setPage(Object page) {
        this.page = page;
    }
    public List<T> getResultList() {
        return resultList;
    }
    public void setResultList(List<T> resultList) {
        this.resultList = resultList;
    }
   
   
    

}
