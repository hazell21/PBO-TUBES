/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;
import java.util.List;


public class MealPlanner {

    private List<Resep> daftarResep;
    private List<Jadwal> daftarJadwal;
    private String       namaPemilik;

    public MealPlanner(String namaPemilik) {
        this.namaPemilik  = namaPemilik;
        this.daftarResep  = new ArrayList<>();
        this.daftarJadwal = new ArrayList<>();
    }

    public void tambahJadwal(String hari, String waktuMakan, Resep resep) {
        Jadwal jadwalBaru = new Jadwal(hari, waktuMakan, resep);
        daftarJadwal.add(jadwalBaru);
    }

    public void tampilJadwal() {
        System.out.println("╔══════════════════════════════════════════════════════════════╗");
        System.out.println("║              MEAL PLANNER - " + namaPemilik);
        System.out.println("╠══════╦═════════════════╦══════════════════════╦═══════╦════════╣");
        System.out.println("║ Hari ║   Waktu Makan   ║        Menu          ║ Kalori║  Harga ║");
        System.out.println("╠══════╬═════════════════╬══════════════════════╬═══════╬════════╣");

        if (daftarJadwal.isEmpty()) {
            System.out.println("║  (Jadwal masih kosong)                                       ║");
        } else {
            for (Jadwal j : daftarJadwal) {
                j.tampilJadwal();
            }
        }

        System.out.println("╠══════╩═════════════════╩══════════════════════╩═══════╩════════╣");
        System.out.printf ("║  Total Kalori Harian : %-10d kkal                         ║%n",
                hitungTotalGiziHarian());
        System.out.printf ("║  Total Pengeluaran   : Rp %,-.0f                              ║%n",
                hitungTotalPengeluaran());
        System.out.println("╚══════════════════════════════════════════════════════════════╝");
    }

    public int hitungTotalGiziHarian() {
        int total = 0;
        for (Jadwal j : daftarJadwal) {
            total += j.getTotalKalori();
        }
        return total;
    }

    public void tambahResep(Resep resep) {
        daftarResep.add(resep);
    }

    public double hitungTotalPengeluaran() {
        double total = 0;
        for (Jadwal j : daftarJadwal) {
            total += j.getTotalHarga();
        }
        return total;
    }

    public void tampilDaftarResep() {
        System.out.println("=== Daftar Resep Tersedia ===");
        if (daftarResep.isEmpty()) {
            System.out.println("  (Belum ada resep)");
        } else {
            for (int i = 0; i < daftarResep.size(); i++) {
                System.out.printf("  %d. %s%n", i + 1, daftarResep.get(i));
            }
        }
    }

    public Resep cariResep(String namaResep) {
        for (Resep r : daftarResep) {
            if (r.getNama().equalsIgnoreCase(namaResep)) {
                return r;
            }
        }
        return null;
    }

    public void hapusJadwal(int index) {
        if (index >= 0 && index < daftarJadwal.size()) {
            daftarJadwal.remove(index);
        }
    }

  
    public List<Resep> getDaftarResep() {
        return daftarResep;
    }

    public List<Jadwal> getDaftarJadwal() {
        return daftarJadwal;
    }

    public String getNamaPemilik() {
        return namaPemilik;
    }

    public void setNamaPemilik(String namaPemilik) {
        this.namaPemilik = namaPemilik;
    }

    @Override
    public String toString() {
        return "MealPlanner{pemilik='" + namaPemilik
                + "', jumlahJadwal=" + daftarJadwal.size()
                + ", jumlahResep=" + daftarResep.size() + "}";
    }
    
    public int HitungTotalGiziHarian() {
        int totalKalori = 0;
        if (this.daftarJadwal != null) {
            for (Jadwal j : this.daftarJadwal) {
                totalKalori += j.getMenu().getKalori();
            }
        }
        return totalKalori;
    }
}
