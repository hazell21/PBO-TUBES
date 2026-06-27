package model;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

public class RecipeAPIService {
    private static final String API_KEY = "c3bd929508ce43349f3c028f4d9d0fce"; 
    private static final String BASE_URL = "https://api.spoonacular.com/recipes/complexSearch";

    private String ambilDaftarBahanDariDBLokal() {
        List<String> listBahan = new ArrayList<>();
        String sql = "SELECT nama FROM bahan";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                listBahan.add(rs.getString("nama").trim().toLowerCase());
            }
        } catch (SQLException e) {
            System.err.println("Gagal baca DB lokal: " + e.getMessage());
        }
        return String.join(",", listBahan);
    }

    public List<Resep> getRekomendasiDariAPI(double budgetMaks) {
        List<Resep> hasilAPI = new ArrayList<>();
        String stringBahanGudang = ambilDaftarBahanDariDBLokal();
        
        int maxPriceCent = (int) (budgetMaks / 150); 
        if (maxPriceCent < 200) maxPriceCent = 250; 

        String urlString = BASE_URL + "?apiKey=" + API_KEY 
                         + "&maxPriceByServing=" + maxPriceCent 
                         + "&fillIngredients=true" // <── KUNCI UTAMA 1
                         + "&includeIngredients=" + URLEncoder.encode(stringBahanGudang, StandardCharsets.UTF_8) 
                         + "&addRecipeInformation=true&addRecipeNutrition=true&number=5";

        hasilAPI = tembakServerAPI(urlString);

        if (hasilAPI.isEmpty()) {
            String urlFallback = BASE_URL + "?apiKey=" + API_KEY 
                               + "&maxPriceByServing=" + maxPriceCent 
                               + "&fillIngredients=true" // <── KUNCI UTAMA 2
                               + "&addRecipeInformation=true&addRecipeNutrition=true&number=5";
            hasilAPI = tembakServerAPI(urlFallback);
        }

        return hasilAPI;
    }

    public List<ResepAPI> getRekomendasiByBahan(String listBahan) {
        List<ResepAPI> listRekomendasi = new ArrayList<>();
        try {
            String encodedBahan = URLEncoder.encode(listBahan, StandardCharsets.UTF_8.toString());
            String urlString = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=" 
                               + encodedBahan + "&number=6&apiKey=" + API_KEY;
            
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder().uri(URI.create(urlString)).GET().build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            
            if (response.statusCode() == 200) {
                JSONArray jsonArray = new JSONArray(response.body());
                for (int i = 0; i < jsonArray.length(); i++) {
                    JSONObject recipeObj = jsonArray.getJSONObject(i);
                    ResepAPI resep = new ResepAPI();
                    resep.setId(recipeObj.getInt("id"));
                    resep.setJudul(recipeObj.getString("title"));
                    resep.setImageUrl(recipeObj.getString("image"));
                    listRekomendasi.add(resep);
                }
            }
        } catch (Exception e) {
            System.err.println("Gagal rekomendasi by bahan dari API: " + e.getMessage());
        }
        return listRekomendasi;
    }

    public JSONObject getDetailResepDariAPI(int id) {
        try {
            String urlString = "https://api.spoonacular.com/recipes/" + id + "/information?apiKey=" + API_KEY;
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder().uri(URI.create(urlString)).GET().build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            
            if (response.statusCode() == 200) {
                return new JSONObject(response.body());
            }
        } catch (Exception e) {
            System.err.println("Gagal mengambil detail resep dari API: " + e.getMessage());
        }
        return null;
    }

    private List<Resep> tembakServerAPI(String urlTembak) {
        List<Resep> listHasil = new ArrayList<>();
        try {
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder().uri(URI.create(urlTembak)).GET().build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                JSONObject jsonResponse = new JSONObject(response.body());
                JSONArray results = jsonResponse.getJSONArray("results");

                for (int i = 0; i < results.length(); i++) {
                    JSONObject recipeJson = results.getJSONObject(i);
                    String namaMenu = recipeJson.getString("title");
                    
                    int kalori = 300; 
                    if (recipeJson.has("nutrition")) {
                        JSONArray nutrients = recipeJson.getJSONObject("nutrition").getJSONArray("nutrients");
                        for (int j = 0; j < nutrients.length(); j++) {
                            JSONObject n = nutrients.getJSONObject(j);
                            if (n.getString("name").equalsIgnoreCase("Calories")) {
                                kalori = (int) n.getDouble("amount");
                                break;
                            }
                        }
                    }
                    
                    String kategori = recipeJson.getJSONArray("dishTypes").length() > 0 
                                      ? recipeJson.getJSONArray("dishTypes").getString(0) : "Lunch";
                    String caraMasak = recipeJson.has("summary") 
                                       ? recipeJson.getString("summary").replaceAll("<[^>]*>", "") : "Instan via API.";

                    Resep resepAPI = new Resep(namaMenu, kalori, kategori, caraMasak);

                    try (Connection conn = DatabaseConnection.getConnection()) {
                        List<JSONObject> gabunganBahanAPI = new ArrayList<>();
                        
                        if (recipeJson.has("missedIngredients")) {
                            JSONArray missed = recipeJson.getJSONArray("missedIngredients");
                            for (int m = 0; m < missed.length(); m++) gabunganBahanAPI.add(missed.getJSONObject(m));
                        }
                        if (recipeJson.has("usedIngredients")) {
                            JSONArray used = recipeJson.getJSONArray("usedIngredients");
                            for (int u = 0; u < used.length(); u++) gabunganBahanAPI.add(used.getJSONObject(u));
                        }

                        String sqlCek = "SELECT harga FROM bahan WHERE LOWER(nama) LIKE ? OR ? LIKE CONCAT('%', LOWER(nama), '%')";
                        
                        for (JSONObject ing : gabunganBahanAPI) {
                            String namaBahanAPI = ing.getString("name").toLowerCase();
                            String satuan = ing.has("unit") ? ing.getString("unit") : "gram";
                            double jumlah = ing.has("amount") ? ing.getDouble("amount") : 1.0;
                            
                            double hargaBahanFinal = 1500.0; 
                            
                            try (PreparedStatement stmtCek = conn.prepareStatement(sqlCek)) {
                                stmtCek.setString(1, "%" + namaBahanAPI + "%");
                                stmtCek.setString(2, namaBahanAPI);
                                try (ResultSet rs = stmtCek.executeQuery()) {
                                    if (rs.next()) {
                                        hargaBahanFinal = rs.getDouble("harga"); // Pakai harga asli dari phpMyAdmin lo kalau sinkron!
                                    }
                                }
                            }
                            resepAPI.tambahBahan(new Bahan(namaBahanAPI, hargaBahanFinal, satuan, jumlah));
                        }
                    } catch (SQLException e) {
                        System.err.println("Gagal sinkronisasi DB: " + e.getMessage());
                    }

                    listHasil.add(resepAPI);
                }
            }
        } catch (Exception e) {
            System.err.println("Eror Parser API: " + e.getMessage());
        }
        return listHasil;
    }
}