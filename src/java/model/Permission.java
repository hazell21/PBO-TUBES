/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;


public class Permission {

    private String permissionName;

   
    public Permission(String permissionName) {
        this.permissionName = permissionName;
    }

  
    public String getPermission() {
        return permissionName;
    }

    
    public String getPermissionName() {
        return permissionName;
    }

    public void setPermissionName(String permissionName) {
        this.permissionName = permissionName;
    }

    
    @Override
    public String toString() {
        return "Permission{" + permissionName + "}";
    }
}
