/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

// Reparse trigger comment to refresh NetBeans IDE parser cache
import java.util.ArrayList;
import java.util.List;
import model.Resep;
import model.Bahan;


public class RekomendasiMakanan implements Rekomendasi {

    private double  budgetHarian;       
    private List<String> bahanTersedia; 

    public RekomendasiMakanan(double budgetHarian) {
        this.budgetHarian  = budgetHarian;
        this.bahanTersedia = new ArrayList<>();
    }

    public RekomendasiMakanan(double budgetHarian, List<String> bahanTersedia) {
        this.budgetHarian  = budgetHarian;
        this.bahanTersedia = bahanTersedia;
    }

    @Override
    public List generateRekomendasi(List daftarResep) {
        List hasil = new ArrayList();
        if (daftarResep != null) {
            for (Object obj : daftarResep) {
                Resep r = (Resep) obj;
                if (r.hitungTotalHarga() <= budgetHarian) {
                    hasil.add(r);
                }
            }
        }
        return hasil;
    }

    @Override
    public void tampilRekomendasi(List daftarResep) {
        List rekomendasi = generateRekomendasi(daftarResep);
        System.out.println("╔══════════════════════════════════════╗");
        System.out.println("║     REKOMENDASI MENU HARI INI        ║");
        System.out.printf ("║  Budget harian : Rp %,.0f%-13s║%n", budgetHarian, "");
        System.out.println("╠══════════════════════════════════════╣");

        if (rekomendasi == null || rekomendasi.isEmpty()) {
            System.out.println("║  Tidak ada resep sesuai budget.      ║");
        } else {
            for (Object obj : rekomendasi) {
                Resep r = (Resep) obj;
                System.out.printf("║  %-20s Rp %,6.0f  ║%n",
                        r.getNama(), r.hitungTotalHarga());
            }
        }
        System.out.println("╚══════════════════════════════════════╝");
    }

    public List<Resep> rekomendasiBerdasarkanBahan(List<Resep> daftarResep) {
        List<Resep> hasil = new ArrayList<>();
        if (bahanTersedia == null || bahanTersedia.isEmpty()) {
            return hasil;
        }
        for (Resep r : daftarResep) {
            boolean adaBahanCocok = false;
            for (Bahan b : r.getDaftarBahan()) {
                for (String namaBahan : bahanTersedia) {
                    if (namaBahan.equalsIgnoreCase(b.getNama())) {
                        adaBahanCocok = true;
                        break;
                    }
                }
                if (adaBahanCocok) {
                    break;
                }
            }
            if (adaBahanCocok) {
                hasil.add(r);
            }
        }
        return hasil;
    }

    public double getBudgetHarian() {
        return budgetHarian;
    }

    public void setBudgetHarian(double budgetHarian) {
        this.budgetHarian = budgetHarian;
    }

    public List<String> getBahanTersedia() {
        return bahanTersedia;
    }

    public void setBahanTersedia(List<String> bahanTersedia) {
        this.bahanTersedia = bahanTersedia;
    }

    public void tambahBahanTersedia(String namaBahan) {
        this.bahanTersedia.add(namaBahan);
    }

    @Override
    public String toString() {
        return "RekomendasiMakanan{budgetHarian=Rp" + budgetHarian + "}";
    }
}
