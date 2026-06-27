/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;


public class Jadwal {

    private String hari;
    private Resep  menu;
    private String waktuMakan; 

    public Jadwal(String hari, String waktuMakan, Resep menu) {
        this.hari       = hari;
        this.waktuMakan = waktuMakan;
        this.menu       = menu;
    }

    public Jadwal(String hari, Resep menu) {
        this(hari, "Tidak ditentukan", menu);
    }

    public void tampilJadwal() {
        System.out.printf("  %-8s | %-15s | %-20s | %d kkal | Rp %,.0f%n",
                hari,
                waktuMakan,
                (menu != null ? menu.getNama() : "Belum ditentukan"),
                (menu != null ? menu.getKalori() : 0),
                (menu != null ? menu.hitungTotalHarga() : 0.0));
    }

    public double getTotalHarga() {
        return menu != null ? menu.hitungTotalHarga() : 0.0;
    }

    public int getTotalKalori() {
        return menu != null ? menu.getKalori() : 0;
    }

    public String getHari() {
        return hari;
    }

    public void setHari(String hari) {
        this.hari = hari;
    }

    public Resep getMenu() {
        return menu;
    }

    public void setMenu(Resep menu) {
        this.menu = menu;
    }

    public String getWaktuMakan() {
        return waktuMakan;
    }

    public void setWaktuMakan(String waktuMakan) {
        this.waktuMakan = waktuMakan;
    }

    @Override
    public String toString() {
        return String.format("Jadwal{hari='%s', waktu='%s', menu='%s'}",
                hari, waktuMakan, (menu != null ? menu.getNama() : "null"));
    }
}