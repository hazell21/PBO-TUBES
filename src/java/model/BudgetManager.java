package model;

import java.util.List;

public class BudgetManager {
    private double totalBudget;

    public BudgetManager(double totalBudget) {
        this.totalBudget = totalBudget;
    }

    public String CekBudget(double pengeluaran) {
        if (pengeluaran > totalBudget) {
            return "Overbudget! Kurangi menu mahal.";
        }
        return "Anggaran Aman";
    }

    public double hitungPengeluaran(List<Jadwal> daftarJadwal) {
        double total = 0;
        if (daftarJadwal != null) {
            for (Jadwal j : daftarJadwal) {
                total += j.getMenu().hitungTotalHarga();
            }
        }
        return total;
    }
}