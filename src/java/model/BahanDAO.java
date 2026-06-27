package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BahanDAO {
    
    public List<Bahan> getBahanReadyStock() {
        List<Bahan> listBahan = new ArrayList<>();
        String query = "SELECT nama_bahan, stok FROM bahan WHERE stok > 0";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Bahan bahan = new Bahan();
                bahan.setNama(rs.getString("nama_bahan"));
                bahan.setJumlah(rs.getDouble("stok"));
                listBahan.add(bahan);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listBahan;
    }
}