<%@page import="org.json.JSONObject" %>
    <%@page import="org.json.JSONArray" %>
        <%@page import="model.Resep" %>
            <%@page import="model.Bahan" %>
                <%@page contentType="text/html" pageEncoding="UTF-8" %>
                    <!DOCTYPE html>
                    <html lang="id">

                    <head>
                        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <title>Detail Resep – Smart Meal Planner</title>
                        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
                            rel="stylesheet">
                        <link
                            href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
                            rel="stylesheet">
                        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
                            rel="stylesheet">
                        <style>
                            *,
                            *::before,
                            *::after {
                                box-sizing: border-box;
                            }

                            body {
                                font-family: 'Plus Jakarta Sans', sans-serif;
                                background: #f8fafc;
                                color: #1e293b;
                                min-height: 100vh;
                            }

                            h1,
                            h2,
                            h3,
                            h4,
                            h5,
                            h6,
                            .navbar-brand {
                                font-family: 'Outfit', sans-serif;
                            }

                            /* NAVBAR */
                            .navbar-premium {
                                background: rgba(255, 255, 255, 0.95);
                                backdrop-filter: blur(12px);
                                border-bottom: 1px solid #e2e8f0;
                            }

                            .navbar-brand {
                                font-size: 1.3rem;
                                font-weight: 800;
                                letter-spacing: -0.5px;
                            }

                            .nav-pill {
                                border-radius: 10px;
                                font-weight: 600;
                                font-size: 0.83rem;
                                padding: 7px 15px;
                                transition: all 0.2s;
                                display: inline-flex;
                                align-items: center;
                                gap: 6px;
                            }

                            .np-outline {
                                border: 1.5px solid #e2e8f0;
                                color: #475569;
                                background: transparent;
                            }

                            .np-outline:hover {
                                background: #f1f5f9;
                                color: #1e293b;
                            }

                            .np-green {
                                background: #ecfdf5;
                                color: #0f766e;
                                border: 1.5px solid #a7f3d0;
                            }

                            .np-green:hover {
                                background: #d1fae5;
                            }

                            /* HERO */
                            .recipe-hero {
                                padding: 2.5rem 0 5rem;
                                position: relative;
                                overflow: hidden;
                            }

                            .recipe-hero-api {
                                background: linear-gradient(135deg, #064e3b 0%, #0f766e 60%, #0d9488 100%);
                            }

                            .recipe-hero-local {
                                background: linear-gradient(135deg, #1e1b4b 0%, #3730a3 60%, #4f46e5 100%);
                            }

                            .recipe-hero::before {
                                content: '';
                                position: absolute;
                                inset: 0;
                                background: radial-gradient(ellipse at 80% 40%, rgba(255, 255, 255, 0.07) 0%, transparent 60%);
                            }

                            .hero-inner-c {
                                position: relative;
                                z-index: 1;
                            }

                            .hero-source-tag {
                                display: inline-flex;
                                align-items: center;
                                gap: 6px;
                                padding: 4px 12px;
                                border-radius: 20px;
                                font-size: 0.75rem;
                                font-weight: 700;
                                letter-spacing: 0.4px;
                                margin-bottom: 0.75rem;
                            }

                            .ht-api {
                                background: rgba(253, 224, 71, 0.15);
                                color: #fde047;
                                border: 1px solid rgba(253, 224, 71, 0.3);
                            }

                            .ht-local {
                                background: rgba(167, 139, 250, 0.15);
                                color: #c4b5fd;
                                border: 1px solid rgba(167, 139, 250, 0.3);
                            }

                            .hero-title {
                                font-size: 2rem;
                                font-weight: 800;
                                color: white;
                                letter-spacing: -0.5px;
                                line-height: 1.2;
                                margin-bottom: 0.875rem;
                            }

                            .hero-pills {
                                display: flex;
                                gap: 8px;
                                flex-wrap: wrap;
                            }

                            .hero-pill {
                                display: inline-flex;
                                align-items: center;
                                gap: 5px;
                                background: rgba(255, 255, 255, 0.12);
                                border: 1px solid rgba(255, 255, 255, 0.2);
                                color: rgba(255, 255, 255, 0.9);
                                padding: 5px 12px;
                                border-radius: 20px;
                                font-size: 0.8rem;
                                font-weight: 500;
                            }

                            /* CONTENT */
                            .content-section {
                                margin-top: -3.5rem;
                                padding-bottom: 3rem;
                            }

                            .container-content {
                                max-width: 900px;
                                margin: 0 auto;
                                padding: 0 1rem;
                            }

                            .btn-back {
                                display: inline-flex;
                                align-items: center;
                                gap: 6px;
                                background: white;
                                border: 1.5px solid #e2e8f0;
                                border-radius: 8px;
                                padding: 7px 14px;
                                font-size: 0.8rem;
                                font-weight: 600;
                                color: #475569;
                                text-decoration: none;
                                transition: all 0.2s;
                                margin-bottom: 1.25rem;
                                box-shadow: 0 2px 8px rgba(15, 23, 42, 0.05);
                            }

                            .btn-back:hover {
                                background: #f1f5f9;
                                color: #1e293b;
                            }

                            /* CARDS */
                            .card-premium {
                                background: white;
                                border-radius: 14px;
                                border: 1px solid rgba(226, 232, 240, 0.8);
                                box-shadow: 0 3px 14px rgba(15, 23, 42, 0.05);
                                overflow: hidden;
                                margin-bottom: 1rem;
                            }

                            .card-header-premium {
                                padding: 0.875rem 1.1rem;
                                border-bottom: 1px solid #f1f5f9;
                                display: flex;
                                align-items: center;
                                gap: 8px;
                            }

                            .card-icon {
                                width: 28px;
                                height: 28px;
                                border-radius: 7px;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-size: 0.78rem;
                                flex-shrink: 0;
                            }

                            .card-body-premium {
                                padding: 1.1rem;
                            }

                            /* STATS */
                            .stats-grid {
                                display: grid;
                                grid-template-columns: 1fr 1fr;
                                gap: 8px;
                            }

                            .stat-mini {
                                background: #f8fafc;
                                border: 1px solid #e2e8f0;
                                border-radius: 8px;
                                padding: 10px 12px;
                            }

                            .stat-mini-val {
                                font-family: 'Outfit', sans-serif;
                                font-size: 1.1rem;
                                font-weight: 800;
                                color: #1e293b;
                            }

                            .stat-mini-lbl {
                                font-size: 0.68rem;
                                color: #94a3b8;
                                font-weight: 600;
                                text-transform: uppercase;
                                letter-spacing: 0.4px;
                            }

                            /* COST DISPLAY */
                            .cost-display {
                                background: linear-gradient(135deg, #ecfdf5, #d1fae5);
                                border: 1px solid #a7f3d0;
                                border-radius: 10px;
                                padding: 0.875rem 1rem;
                                display: flex;
                                align-items: center;
                                gap: 10px;
                                margin-top: 0.875rem;
                            }

                            .cost-icon {
                                width: 36px;
                                height: 36px;
                                border-radius: 9px;
                                background: linear-gradient(135deg, #0f766e, #0d9488);
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                font-size: 0.9rem;
                                color: white;
                                flex-shrink: 0;
                            }

                            .cost-lbl {
                                font-size: 0.68rem;
                                color: #059669;
                                font-weight: 700;
                                text-transform: uppercase;
                                letter-spacing: 0.4px;
                            }

                            .cost-val {
                                font-family: 'Outfit', sans-serif;
                                font-size: 1.35rem;
                                font-weight: 800;
                                color: #065f46;
                                letter-spacing: -0.5px;
                            }

                            /* RECIPE IMAGE */
                            .recipe-img-wrap {
                                border-radius: 14px;
                                overflow: hidden;
                                margin-bottom: 1rem;
                                position: relative;
                            }

                            .recipe-img {
                                width: 100%;
                                display: block;
                                max-height: 260px;
                                object-fit: cover;
                            }

                            .recipe-img-overlay {
                                position: absolute;
                                inset: 0;
                                background: linear-gradient(to top, rgba(0, 0, 0, 0.1), transparent);
                            }

                            /* INGREDIENT */
                            .ingredient-item {
                                display: flex;
                                align-items: center;
                                justify-content: space-between;
                                padding: 7px 0;
                                border-bottom: 1px solid #f8fafc;
                            }

                            .ingredient-item:last-child {
                                border-bottom: none;
                            }

                            .ingredient-name {
                                display: flex;
                                align-items: center;
                                gap: 8px;
                                font-size: 0.83rem;
                            }

                            .ing-dot {
                                width: 6px;
                                height: 6px;
                                border-radius: 50%;
                                background: #0f766e;
                                flex-shrink: 0;
                            }

                            .ingredient-price {
                                font-size: 0.78rem;
                                color: #64748b;
                                font-weight: 600;
                            }

                            /* INSTRUCTION */
                            .instruction-step {
                                display: flex;
                                gap: 10px;
                                margin-bottom: 0.65rem;
                                align-items: flex-start;
                            }

                            .step-num {
                                width: 24px;
                                height: 24px;
                                border-radius: 6px;
                                background: linear-gradient(135deg, #0f766e, #0d9488);
                                color: white;
                                font-size: 0.7rem;
                                font-weight: 700;
                                display: flex;
                                align-items: center;
                                justify-content: center;
                                flex-shrink: 0;
                                margin-top: 1px;
                            }

                            .step-text {
                                font-size: 0.83rem;
                                color: #475569;
                                line-height: 1.6;
                            }

                            /* SUMMARY */
                            .summary-text {
                                font-size: 0.83rem;
                                color: #475569;
                                line-height: 1.65;
                            }

                            /* ALERT */
                            .error-box {
                                background: #fef2f2;
                                border: 1px solid #fca5a5;
                                border-radius: 10px;
                                padding: 12px 16px;
                                font-size: 0.83rem;
                                color: #991b1b;
                                display: flex;
                                align-items: center;
                                gap: 8px;
                                margin: 2rem 0;
                            }
                        </style>
                    </head>

                    <body>

                        <nav class="navbar navbar-premium navbar-expand-lg shadow-sm sticky-top py-2">
                            <div class="container">
                                <a class="navbar-brand text-success d-flex align-items-center gap-2"
                                    href="dashboard.jsp">
                                    <i class="fa-solid fa-utensils"></i> Smart Meal Planner
                                </a>
                                <div class="ms-auto d-flex gap-2">
                                    <a href="MealPlannerServlet?action=rekomendasiBahanPage"
                                        class="btn nav-pill np-green">
                                        <i class="fa-solid fa-lightbulb"></i> Rekomendasi
                                    </a>
                                    <a href="dashboard.jsp" class="btn nav-pill np-outline">
                                        <i class="fa-solid fa-house"></i> Dashboard
                                    </a>
                                </div>
                            </div>
                        </nav>

                        <% String recipeType=(String) request.getAttribute("recipeType"); if
                            ("api".equalsIgnoreCase(recipeType)) { JSONObject detail=(JSONObject)
                            request.getAttribute("detailResepJSON"); if (detail==null) { %>
                            <div class="container my-4">
                                <div class="error-box"><i class="fa-solid fa-circle-exclamation"></i><span><strong>Gagal
                                            memuat detail.</strong> Koneksi ke Spoonacular API terputus atau resep tidak
                                        ditemukan.</span></div>
                            </div>
                            <% } else { String title=detail.optString("title", "Resep Tanpa Judul" ); String
                                image=detail.optString("image", "" ); int readyInMinutes=detail.optInt("readyInMinutes",
                                0); int servings=detail.optInt("servings", 0); String
                                summary=detail.optString("summary", "" ).replaceAll("<[^>]*>", "");
                                String instructions = detail.optString("instructions", "Langkah memasak tidak tersedia.");
                                JSONArray ingredients = detail.optJSONArray("extendedIngredients");
                                %>

                                <div class="recipe-hero recipe-hero-api">
                                    <div class="container hero-inner-c">
                                        <span class="hero-source-tag ht-api"><i class="fa-solid fa-globe fa-xs"></i>
                                            Resep Online &middot; Spoonacular</span>
                                        <h1 class="hero-title">
                                            <%= title %>
                                        </h1>
                                        <div class="hero-pills">
                                            <% if (readyInMinutes> 0) { %><span class="hero-pill"><i
                                                        class="fa-solid fa-clock fa-xs"></i>
                                                    <%= readyInMinutes %> menit
                                                </span>
                                                <% } %>
                                                    <% if (servings> 0) { %><span class="hero-pill"><i
                                                                class="fa-solid fa-users fa-xs"></i>
                                                            <%= servings %> porsi
                                                        </span>
                                                        <% } %>
                                                            <span class="hero-pill"><i
                                                                    class="fa-solid fa-star fa-xs"></i> API
                                                                Recipe</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="content-section">
                                    <div class="container-content">
                                        <a href="MealPlannerServlet?action=rekomendasiBahanPage" class="btn-back">
                                            <i class="fa-solid fa-arrow-left fa-xs"></i> Kembali ke Rekomendasi
                                        </a>
                                        <div class="row g-4">
                                            <div class="col-md-5">
                                                <% if (!image.isEmpty()) { %>
                                                    <div class="recipe-img-wrap" id="recipeImgWrap">
                                                        <img src="<%= image %>" alt="<%= title %>" class="recipe-img" onerror="document.getElementById('recipeImgWrap').style.display='none';">
                                                        <div class="recipe-img-overlay"></div>
                                                    </div>
                                                    <% } %>
                                                        <div class="card-premium">
                                                            <div class="card-header-premium">
                                                                <div class="card-icon" style="background:#ecfdf5;"><i
                                                                        class="fa-solid fa-chart-bar"
                                                                        style="color:#0f766e;"></i></div>
                                                                <span style="font-weight:700;font-size:0.875rem;">Info
                                                                    Resep</span>
                                                            </div>
                                                            <div class="card-body-premium">
                                                                <div class="stats-grid">
                                                                    <div class="stat-mini">
                                                                        <div class="stat-mini-val">
                                                                            <%= readyInMinutes %>
                                                                        </div>
                                                                        <div class="stat-mini-lbl">Menit</div>
                                                                    </div>
                                                                    <div class="stat-mini">
                                                                        <div class="stat-mini-val">
                                                                            <%= servings %>
                                                                        </div>
                                                                        <div class="stat-mini-lbl">Porsi</div>
                                                                    </div>
                                                                </div>
                                                                <% if (!summary.isEmpty()) { %>
                                                                    <div style="margin-top:0.875rem;">
                                                                        <div
                                                                            style="font-size:0.68rem;font-weight:700;text-transform:uppercase;color:#94a3b8;letter-spacing:0.5px;margin-bottom:0.4rem;">
                                                                            Ringkasan</div>
                                                                        <div class="summary-text">
                                                                            <%= summary.length()> 300 ?
                                                                                summary.substring(0, 300) + "..." :
                                                                                summary %>
                                                                        </div>
                                                                    </div>
                                                                    <% } %>
                                                            </div>
                                                        </div>
                                            </div>
                                            <div class="col-md-7">
                                                <div class="card-premium">
                                                    <div class="card-header-premium">
                                                        <div class="card-icon" style="background:#fef3c7;"><i
                                                                class="fa-solid fa-carrot" style="color:#d97706;"></i>
                                                        </div>
                                                        <span
                                                            style="font-weight:700;font-size:0.875rem;">Bahan-bahan</span>
                                                        <% if (ingredients !=null) { %>
                                                            <span
                                                                style="margin-left:auto;background:#ecfdf5;color:#0f766e;font-size:0.72rem;font-weight:700;padding:2px 9px;border-radius:20px;">
                                                                <%= ingredients.length() %> bahan
                                                            </span>
                                                            <% } %>
                                                    </div>
                                                    <div class="card-body-premium">
                                                        <% if (ingredients !=null && ingredients.length()> 0) {
                                                            for (int i = 0; i < ingredients.length(); i++) { JSONObject
                                                                ing=ingredients.getJSONObject(i); String
                                                                original=ing.optString("original",
                                                                ing.optString("name")); %>
                                                                <div class="ingredient-item">
                                                                    <div class="ingredient-name">
                                                                        <div class="ing-dot"></div><span>
                                                                            <%= original %>
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                                <% } } else { %>
                                                                    <p style="font-size:0.83rem;color:#94a3b8;">Daftar
                                                                        bahan tidak tersedia.</p>
                                                                    <% } %>
                                                    </div>
                                                </div>
                                                <div class="card-premium">
                                                    <div class="card-header-premium">
                                                        <div class="card-icon" style="background:#f5f3ff;"><i
                                                                class="fa-solid fa-list-check"
                                                                style="color:#7c3aed;"></i></div>
                                                        <span style="font-weight:700;font-size:0.875rem;">Cara
                                                            Memasak</span>
                                                    </div>
                                                    <div class="card-body-premium">
                                                        <% String[] steps=instructions.split("\\.\\s+|\\n+"); int
                                                            stepNum=0; for (String step : steps) { step=step.trim(); if
                                                            (!step.isEmpty() && step.length()> 10) { stepNum++; %>
                                                            <div class="instruction-step">
                                                                <div class="step-num">
                                                                    <%= stepNum %>
                                                                </div>
                                                                <div class="step-text">
                                                                    <%= step %>.
                                                                </div>
                                                            </div>
                                                            <% } } if (stepNum==0) { %>
                                                                <p class="summary-text">
                                                                    <%= instructions %>
                                                                </p>
                                                                <% } %>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <% } } else { Resep resepLokal=(Resep) request.getAttribute("resepLokal"); if
                                    (resepLokal==null) { %>
                                    <div class="container my-4">
                                        <div class="error-box"><i
                                                class="fa-solid fa-circle-exclamation"></i><span><strong>Gagal!</strong>
                                                Resep lokal tidak ditemukan.</span></div>
                                    </div>
                                    <% } else { %>

                                        <div class="recipe-hero recipe-hero-local">
                                            <div class="container hero-inner-c">
                                                <span class="hero-source-tag ht-local"><i
                                                        class="fa-solid fa-database fa-xs"></i> Database Lokal</span>
                                                <h1 class="hero-title">
                                                    <%= resepLokal.getNama() %>
                                                </h1>
                                                <div class="hero-pills">
                                                    <span class="hero-pill"><i class="fa-solid fa-fire fa-xs"></i>
                                                        <%= resepLokal.getKalori() %> kkal
                                                    </span>
                                                    <span class="hero-pill"><i class="fa-solid fa-tag fa-xs"></i>
                                                        <%= resepLokal.getKategori() %>
                                                    </span>
                                                    <span class="hero-pill"><i class="fa-solid fa-coins fa-xs"></i> Rp
                                                        <%= String.format("%,.0f", resepLokal.hitungTotalHarga()) %>
                                                            </span>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="content-section">
                                            <div class="container-content">
                                                <a href="javascript:history.back()" class="btn-back">
                                                    <i class="fa-solid fa-arrow-left fa-xs"></i> Kembali
                                                </a>
                                                <div class="row g-4">
                                                    <div class="col-md-5">
                                                        <div class="card-premium">
                                                            <div class="card-header-premium">
                                                                <div class="card-icon" style="background:#f5f3ff;"><i
                                                                        class="fa-solid fa-chart-pie"
                                                                        style="color:#7c3aed;"></i></div>
                                                                <span
                                                                    style="font-weight:700;font-size:0.875rem;">Nutrisi
                                                                    & Biaya</span>
                                                            </div>
                                                            <div class="card-body-premium">
                                                                <div class="stats-grid" style="margin-bottom:0.875rem;">
                                                                    <div class="stat-mini">
                                                                        <div class="stat-mini-val">
                                                                            <%= resepLokal.getKalori() %>
                                                                        </div>
                                                                        <div class="stat-mini-lbl">Kkal</div>
                                                                    </div>
                                                                    <div class="stat-mini">
                                                                        <div class="stat-mini-val"
                                                                            style="font-size:0.88rem;">
                                                                            <%= resepLokal.getKategori() %>
                                                                        </div>
                                                                        <div class="stat-mini-lbl">Kategori</div>
                                                                    </div>
                                                                </div>
                                                                <div class="cost-display">
                                                                    <div class="cost-icon"><i
                                                                            class="fa-solid fa-coins fa-sm"></i></div>
                                                                    <div>
                                                                        <div class="cost-lbl">Total Estimasi Biaya</div>
                                                                        <div class="cost-val">Rp <%=
                                                                                String.format("%,.0f",
                                                                                resepLokal.hitungTotalHarga()) %>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="col-md-7">
                                                        <div class="card-premium">
                                                            <div class="card-header-premium">
                                                                <div class="card-icon" style="background:#fef3c7;"><i
                                                                        class="fa-solid fa-carrot"
                                                                        style="color:#d97706;"></i></div>
                                                                <span
                                                                    style="font-weight:700;font-size:0.875rem;">Komponen
                                                                    Bahan Baku</span>
                                                                <% if (resepLokal.getDaftarBahan() !=null) { %>
                                                                    <span
                                                                        style="margin-left:auto;background:#ecfdf5;color:#0f766e;font-size:0.72rem;font-weight:700;padding:2px 9px;border-radius:20px;">
                                                                        <%= resepLokal.getDaftarBahan().size() %> bahan
                                                                    </span>
                                                                    <% } %>
                                                            </div>
                                                            <div class="card-body-premium">
                                                                <% if (resepLokal.getDaftarBahan() !=null &&
                                                                    !resepLokal.getDaftarBahan().isEmpty()) { for (Bahan
                                                                    b : resepLokal.getDaftarBahan()) { %>
                                                                    <div class="ingredient-item">
                                                                        <div class="ingredient-name">
                                                                            <div class="ing-dot"></div>
                                                                            <strong>
                                                                                <%= b.getNama() %>
                                                                            </strong>
                                                                            <span
                                                                                style="color:#94a3b8;font-size:0.78rem;">
                                                                                <%= String.format("%.0f", b.getJumlah())
                                                                                    %>
                                                                                    <%= b.getSatuan() %>
                                                                            </span>
                                                                        </div>
                                                                        <div class="ingredient-price">~Rp <%=
                                                                                String.format("%,.0f", b.getHarga() *
                                                                                b.getJumlah()) %>
                                                                        </div>
                                                                    </div>
                                                                    <% } } else { %>
                                                                        <p style="font-size:0.83rem;color:#94a3b8;">
                                                                            Tidak ada bahan terdaftar.</p>
                                                                        <% } %>
                                                            </div>
                                                        </div>
                                                        <div class="card-premium">
                                                            <div class="card-header-premium">
                                                                <div class="card-icon" style="background:#ecfdf5;"><i
                                                                        class="fa-solid fa-list-check"
                                                                        style="color:#0f766e;"></i></div>
                                                                <span style="font-weight:700;font-size:0.875rem;">Cara
                                                                    Memasak</span>
                                                            </div>
                                                            <div class="card-body-premium">
                                                                <% String caraMasak=resepLokal.getCaraMasak(); if
                                                                    (caraMasak !=null && !caraMasak.trim().isEmpty()) {
                                                                    String[] localSteps=caraMasak.split("\n+"); int
                                                                    sNum=0; for (String s : localSteps) { s=s.trim(); if
                                                                    (!s.isEmpty()) { sNum++; %>
                                                                    <div class="instruction-step">
                                                                        <div class="step-num">
                                                                            <%= sNum %>
                                                                        </div>
                                                                        <div class="step-text">
                                                                            <%= s %>
                                                                        </div>
                                                                    </div>
                                                                    <% } } if (sNum==0) { %>
                                                                        <div class="step-text">
                                                                            <%= caraMasak %>
                                                                        </div>
                                                                        <% } } else { %>
                                                                            <p style="font-size:0.83rem;color:#94a3b8;">
                                                                                Panduan memasak tidak tersedia.</p>
                                                                            <% } %>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <% } } %>

                                            <script
                                                src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                    </body>

                    </html>