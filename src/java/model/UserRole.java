/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;
import java.util.List;

public class UserRole {

    private User user;
    private Role role;
    private List<Permission> permissions;


    public UserRole(User user, Role role) {
        this.user        = user;
        this.role        = role;
        this.permissions = new ArrayList<>();
        initDefaultPermissions();
    }

    private void initDefaultPermissions() {
        if (role == Role.MAHASISWA) {
            permissions.add(new Permission("VIEW_RECIPE"));
            permissions.add(new Permission("ADD_MEAL_PLAN"));
            permissions.add(new Permission("VIEW_BUDGET"));
            permissions.add(new Permission("EDIT_BUDGET"));
        } else if (role == Role.ADMIN) {
            permissions.add(new Permission("VIEW_RECIPE"));
            permissions.add(new Permission("ADD_RECIPE"));
            permissions.add(new Permission("DELETE_RECIPE"));
            permissions.add(new Permission("MANAGE_USER"));
            permissions.add(new Permission("VIEW_BUDGET"));
        }
    }

    public boolean hasPermission(String permissionName) {
        for (Permission p : permissions) {
            if (p.getPermission().equalsIgnoreCase(permissionName)) {
                return true;
            }
        }
        return false;
    }

    public void tampilPermissions() {
        System.out.println("Permission untuk role [" + role + "] - " + user.getNama() + ":");
        for (Permission p : permissions) {
            System.out.println("  - " + p.getPermission());
        }
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public List<Permission> getPermissions() {
        return permissions;
    }

    @Override
    public String toString() {
        return "UserRole{user=" + user.getNama() + ", role=" + role + "}";
    }
}
