// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package ch.epfl.psytest.domain;

import java.lang.String;

privileged aspect Slide_Roo_JavaBean {
    
    public String Slide.getDescription() {
        return this.description;
    }
    
    public void Slide.setDescription(String description) {
        this.description = description;
    }
    
    public String Slide.getFileName() {
        return this.fileName;
    }
    
    public void Slide.setFileName(String fileName) {
        this.fileName = fileName;
    }
    
    public long Slide.getSize() {
        return this.size;
    }
    
    public void Slide.setSize(long size) {
        this.size = size;
    }
    
}
