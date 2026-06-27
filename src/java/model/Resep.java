package model;

import java.util.ArrayList;
import java.util.List;

public class Resep {
    private String nama;
    private int kalori;
    private String kategori;
    private String caraMasak;
    private List<Bahan> daftarBahan;

    public Resep() {
        this.daftarBahan = new ArrayList<>();
    }

    public Resep(String nama, int kalori, String kategori, String caraMasak) {
        this.nama = nama;
        this.kalori = kalori;
        this.kategori = kategori;
        this.caraMasak = caraMasak;
        this.daftarBahan = new ArrayList<>();
    }

    public String getNama() { return nama; }
    public void setNama(String nama) { this.nama = nama; }

    public int getKalori() { return kalori; }
    public void setKalori(int kalori) { this.kalori = kalori; }

    public String getKategori() { return kategori; }
    public void setKategori(String kategori) { this.kategori = kategori; }

    public String getCaraMasak() { return caraMasak; }
    public void setCaraMasak(String caraMasak) { this.caraMasak = caraMasak; }

    public List<Bahan> getDaftarBahan() { return daftarBahan; }
    public void setDaftarBahan(List<Bahan> daftarBahan) { this.daftarBahan = daftarBahan; }

    public void tambahBahan(Bahan bahan) {
        this.daftarBahan.add(bahan);
    }

    public double hitungTotalHarga() {
        double total = 0;
        for (Bahan b : daftarBahan) {
            total += b.getHarga() * b.getJumlah();
        }
        return total;
    }

    @Override
    public String toString() {
        return "Resep{" +
                "nama='" + nama + '\'' +
                ", kalori=" + kalori +
                ", kategori='" + kategori + '\'' +
                ", caraMasak='" + caraMasak + '\'' +
                ", jumlahBahan=" + (daftarBahan != null ? daftarBahan.size() : 0) +
                '}';
    }
}