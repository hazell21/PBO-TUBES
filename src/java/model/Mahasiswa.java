/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;


public class Mahasiswa extends User {

    private double budget;
    private String nim;

    
    public Mahasiswa(String nama, String email, String nim, double budget) {
        super(nama, email);   
        this.nim    = nim;
        this.budget = budget;
    }

    @Override
    public void login() {
        System.out.println("====================================");
        System.out.println("  Login berhasil!");
        System.out.println("  Selamat datang, " + nama);
        System.out.println("  NIM   : " + nim);
        System.out.println("  Email : " + email);
        System.out.printf ("  Budget: Rp %.2f%n", budget);
        System.out.println("====================================");
    }

    public boolean kurangiBudget(double jumlah) {
        if (jumlah > budget) {
            System.out.println("[!] Budget tidak mencukupi! Budget sisa: Rp " + budget);
            return false;
        }
        budget -= jumlah;
        System.out.printf("[✓] Pengeluaran Rp %.2f berhasil dicatat. Sisa budget: Rp %.2f%n",
                jumlah, budget);
        return true;
    }

    public void tambahBudget(double jumlah) {
        if (jumlah <= 0) {
            System.out.println("[!] Jumlah penambahan harus lebih dari 0.");
            return;
        }
        budget += jumlah;
        System.out.printf("[✓] Budget berhasil ditambah. Total budget: Rp %.2f%n", budget);
    }

  
    public double getBudget() {
        return budget;
    }

    public void setBudget(double budget) {
        this.budget = budget;
    }

    public String getNim() {
        return nim;
    }

    public void setNim(String nim) {
        this.nim = nim;
    }


    @Override
    public String toString() {
        return String.format("Mahasiswa{nama='%s', nim='%s', email='%s', budget=%.2f}",
                nama, nim, email, budget);
    }
}