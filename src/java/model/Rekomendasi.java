/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package model;

// Reparse trigger comment to refresh NetBeans IDE parser cache
import java.util.List;
import model.Resep;

public interface Rekomendasi {

    List generateRekomendasi(List daftarResep);
    void tampilRekomendasi(List daftarResep);
}