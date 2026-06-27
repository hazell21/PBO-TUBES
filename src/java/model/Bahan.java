/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;


public class Bahan {

    private String nama;
    private double harga;
    private String satuan;   
    private double jumlah;   

 
    public Bahan() {
        this("", 0.0, "unit", 0.0);
    }

    public Bahan(String nama, double harga, String satuan, double jumlah) {
        this.nama   = nama;
        this.harga  = harga;
        this.satuan = satuan;
        this.jumlah = jumlah;
    }

    public Bahan(String nama, double harga) {
        this(nama, harga, "unit", 1);
    }

    public double getHarga() {
        return harga ;
    }

    public double getHargaSatuan() {
        return harga;
    }
    
    public double getHargaDasar() {
    return this.harga;
}

    public void tampilBahan() {
        System.out.printf("  %-20s %6.0f %-6s @ Rp %,.0f  = Rp %,.0f%n",
                nama, jumlah, satuan, harga, getHarga());
    }


    public String getNama() {
        return nama;
    }

    public void setNama(String nama) {
        this.nama = nama;
    }

    public void setHarga(double harga) {
        this.harga = harga;
    }

    public String getSatuan() {
        return satuan;
    }

    public void setSatuan(String satuan) {
        this.satuan = satuan;
    }

    public double getJumlah() {
        return jumlah;
    }

    public void setJumlah(double jumlah) {
        this.jumlah = jumlah;
    }

    @Override
    public String toString() {
        return String.format("Bahan{nama='%s', jumlah=%.0f %s, harga=Rp%.0f}",
                nama, jumlah, satuan, getHarga());
    }
}
