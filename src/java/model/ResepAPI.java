package model;

public class ResepAPI {
    private int id;
    private String judul;
    private String imageUrl;

    public ResepAPI() {}

    public ResepAPI(int id, String judul, String imageUrl) {
        this.id = id;
        this.judul = judul;
        this.imageUrl = imageUrl;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getJudul() { return judul; }
    public void setJudul(String judul) { this.judul = judul; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}