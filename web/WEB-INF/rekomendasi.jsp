<%@page import="model.Resep"%>
<%@page import="model.Bahan"%>
<%@page import="model.ResepAPI"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rekomendasi Menu – Smart Meal Planner</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f0fdf4; color: #1e293b; min-height: 100vh; }
        h1,h2,h3,h4,h5,h6,.navbar-brand { font-family: 'Outfit', sans-serif; }

        /* NAVBAR */
        .navbar-premium { background: rgba(255,255,255,0.95); backdrop-filter: blur(12px); border-bottom: 1px solid #e2e8f0; }
        .navbar-brand { font-size: 1.3rem; font-weight: 800; letter-spacing: -0.5px; }
        .nav-pill { border-radius: 10px; font-weight: 600; font-size: 0.83rem; padding: 7px 15px; transition: all 0.2s; display: inline-flex; align-items: center; gap: 6px; }
        .np-outline { border: 1.5px solid #e2e8f0; color: #475569; background: transparent; }
        .np-outline:hover { background: #f1f5f9; color: #1e293b; }
        .np-green { background: #ecfdf5; color: #0f766e; border: 1.5px solid #a7f3d0; }
        .np-danger { background: #fef2f2; color: #dc2626; border: 1.5px solid #fecaca; }

        /* PAGE HERO */
        .page-hero {
            background: linear-gradient(135deg, #064e3b 0%, #0f766e 55%, #0d9488 100%);
            padding: 3rem 0 6rem; position: relative; overflow: hidden;
        }
        .page-hero::before {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse at 75% 40%, rgba(52,211,153,0.18) 0%, transparent 60%);
        }
        .blob { position: absolute; border-radius: 50%; filter: blur(60px); opacity: 0.18; }
        .blob-a { width: 300px; height: 300px; background: #34d399; top: -60px; right: -40px; animation: blobF 7s ease-in-out infinite; }
        .blob-b { width: 180px; height: 180px; background: #6ee7b7; bottom: -20px; left: 5%; animation: blobF 9s ease-in-out infinite reverse; }
        @keyframes blobF { 0%,100%{transform:translateY(0)scale(1)} 50%{transform:translateY(-15px)scale(1.04)} }
        .hero-inner { position: relative; z-index: 1; }
        .hero-tag {
            display: inline-flex; align-items: center; gap: 6px;
            background: rgba(255,255,255,0.12); border: 1px solid rgba(255,255,255,0.2);
            color: rgba(255,255,255,0.9); padding: 5px 13px; border-radius: 30px;
            font-size: 0.77rem; font-weight: 600; margin-bottom: 0.875rem;
        }
        .hero-title { font-size: 2.2rem; font-weight: 800; color: white; letter-spacing: -0.5px; line-height: 1.2; margin-bottom: 0.5rem; }
        .hero-sub { color: rgba(255,255,255,0.65); font-size: 0.88rem; line-height: 1.65; }

        /* CONTENT WRAP */
        .content-wrap { margin-top: -4.5rem; padding-bottom: 3rem; position: relative; z-index: 5; }

        /* SIDEBAR CARDS */
        .sidebar-card {
            background: white; border-radius: 16px;
            border: 1px solid rgba(226,232,240,0.8);
            box-shadow: 0 4px 20px rgba(15,23,42,0.05);
            overflow: hidden; margin-bottom: 1rem;
            transition: box-shadow 0.2s;
        }
        .sidebar-card:hover { box-shadow: 0 8px 30px rgba(15,23,42,0.09); }
        .sidebar-card-header {
            padding: 0.875rem 1.1rem; border-bottom: 1px solid #f1f5f9;
            display: flex; align-items: center; gap: 9px;
        }
        .sc-icon { width: 30px; height: 30px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 0.82rem; }
        .sidebar-card-body { padding: 1.1rem; }
        .sc-title { font-size: 0.86rem; font-weight: 700; color: #1e293b; }
        .sc-sub { font-size: 0.72rem; color: #94a3b8; margin-top: 1px; }

        /* FORM */
        .f-lbl { font-size: 0.7rem; font-weight: 700; text-transform: uppercase; color: #64748b; letter-spacing: 0.5px; margin-bottom: 0.25rem; display: block; }
        .f-inp {
            width: 100%; height: 36px; padding: 0 10px;
            border: 1.5px solid #e2e8f0; border-radius: 8px;
            font-size: 0.83rem; color: #1e293b; background: white;
            outline: none; transition: all 0.2s;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .f-inp:focus { border-color: #0f766e; box-shadow: 0 0 0 3px rgba(15,118,110,0.1); }

        /* CHECKBOX SCROLL */
        .checkbox-scroll {
            max-height: 180px; overflow-y: auto;
            border: 1.5px solid #e2e8f0; border-radius: 8px; padding: 8px;
            background: #f8fafc;
        }
        .checkbox-scroll::-webkit-scrollbar { width: 3px; }
        .checkbox-scroll::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 2px; }
        .form-check-input:checked { background-color: #0f766e; border-color: #0f766e; }
        .form-check-label { font-size: 0.82rem; color: #475569; }

        /* SOURCE TOGGLE */
        .source-toggle { display: grid; grid-template-columns: 1fr 1fr; gap: 6px; }
        .source-opt { position: relative; }
        .source-opt input { position: absolute; opacity: 0; }
        .source-lbl {
            display: flex; align-items: center; justify-content: center; gap: 5px;
            border: 1.5px solid #e2e8f0; border-radius: 8px; padding: 7px;
            font-size: 0.78rem; font-weight: 600; color: #64748b;
            cursor: pointer; transition: all 0.15s; background: #f8fafc;
        }
        .source-opt input:checked + .source-lbl { border-color: #0f766e; background: #ecfdf5; color: #0f766e; }
        .source-lbl:hover { border-color: #94a3b8; background: #f1f5f9; }

        /* BUTTONS */
        .btn-scan-outline {
            width: 100%; height: 36px; background: transparent;
            border: 1.5px solid #0f766e; color: #0f766e;
            border-radius: 8px; font-size: 0.82rem; font-weight: 600;
            cursor: pointer; transition: all 0.2s; margin-bottom: 6px;
            display: flex; align-items: center; justify-content: center; gap: 6px;
            text-decoration: none; font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .btn-scan-outline:hover { background: #ecfdf5; }

        .btn-scan-solid {
            width: 100%; height: 36px;
            background: linear-gradient(135deg, #0f766e, #0d9488); color: white;
            border: none; border-radius: 8px; font-size: 0.82rem; font-weight: 600;
            cursor: pointer; transition: all 0.2s;
            display: flex; align-items: center; justify-content: center; gap: 6px;
            text-decoration: none; font-family: 'Plus Jakarta Sans', sans-serif;
            box-shadow: 0 3px 10px rgba(15,118,110,0.2);
        }
        .btn-scan-solid:hover { box-shadow: 0 5px 16px rgba(15,118,110,0.3); transform: translateY(-1px); }

        .btn-run {
            width: 100%; height: 38px;
            background: linear-gradient(135deg, #0f766e, #0d9488); color: white;
            border: none; border-radius: 8px; font-size: 0.85rem; font-weight: 700;
            cursor: pointer; transition: all 0.2s;
            display: flex; align-items: center; justify-content: center; gap: 6px;
            font-family: 'Outfit', sans-serif;
            box-shadow: 0 3px 10px rgba(15,118,110,0.2);
        }
        .btn-run:hover { box-shadow: 0 5px 16px rgba(15,118,110,0.3); transform: translateY(-1px); }

        .btn-budget {
            width: 100%; height: 38px;
            background: linear-gradient(135deg, #f59e0b, #d97706); color: white;
            border: none; border-radius: 8px; font-size: 0.85rem; font-weight: 700;
            cursor: pointer; transition: all 0.2s;
            display: flex; align-items: center; justify-content: center; gap: 6px;
            font-family: 'Outfit', sans-serif;
            box-shadow: 0 3px 10px rgba(245,158,11,0.2);
        }
        .btn-budget:hover { box-shadow: 0 5px 16px rgba(245,158,11,0.3); transform: translateY(-1px); }

        /* BUDGET INPUT */
        .budget-input-group { display: flex; }
        .budget-prefix {
            height: 36px; padding: 0 10px;
            background: #f1f5f9; border: 1.5px solid #e2e8f0; border-right: none;
            border-radius: 8px 0 0 8px; font-size: 0.85rem; font-weight: 600; color: #475569;
            display: flex; align-items: center; flex-shrink: 0;
        }
        .budget-inp {
            flex: 1; height: 36px; padding: 0 10px;
            border: 1.5px solid #e2e8f0; border-radius: 0 8px 8px 0;
            font-size: 0.88rem; color: #1e293b; background: white; outline: none;
            transition: all 0.2s; font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .budget-inp:focus { border-color: #0f766e; box-shadow: 0 0 0 3px rgba(15,118,110,0.1); }

        /* RESULTS */
        .results-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem; flex-wrap: wrap; gap: 8px; }
        .results-title { font-size: 0.95rem; font-weight: 700; color: #1e293b; }
        .results-count { background: #ecfdf5; color: #0f766e; border: 1px solid #a7f3d0; font-size: 0.73rem; font-weight: 700; padding: 3px 10px; border-radius: 20px; }

        /* RECIPE CARD */
        .recipe-card {
            background: white; border-radius: 14px;
            border: 1px solid rgba(226,232,240,0.8);
            box-shadow: 0 3px 14px rgba(15,23,42,0.04);
            overflow: hidden; transition: all 0.2s; height: 100%; display: flex; flex-direction: column;
        }
        .recipe-card:hover { box-shadow: 0 10px 32px rgba(15,23,42,0.1); transform: translateY(-3px); }
        .recipe-card-img { width: 100%; height: 160px; object-fit: cover; display: block; border-bottom: 1px solid #f1f5f9; }
        .recipe-card-placeholder { height: 80px; background: linear-gradient(135deg, #ecfdf5, #d1fae5); display: flex; align-items: center; justify-content: center; color: #a7f3d0; font-size: 1.5rem; border-bottom: 1px solid #f1f5f9; }
        .recipe-card-body { padding: 1rem; flex: 1; display: flex; flex-direction: column; }
        .recipe-tag { font-size: 0.68rem; font-weight: 700; padding: 2px 8px; border-radius: 4px; display: inline-block; margin-bottom: 0.4rem; text-transform: capitalize; }
        .tag-local { background: #eff6ff; color: #3b82f6; }
        .tag-api { background: #fef3c7; color: #92400e; }
        .tag-budget { background: #f5f3ff; color: #7c3aed; }
        .recipe-name { font-size: 0.88rem; font-weight: 700; color: #1e293b; line-height: 1.35; margin-bottom: 0.4rem; }
        .recipe-meta { font-size: 0.73rem; color: #94a3b8; margin-bottom: 0.4rem; }
        .recipe-price { font-size: 0.95rem; font-weight: 800; color: #0f766e; font-family: 'Outfit', sans-serif; letter-spacing: -0.3px; margin-bottom: 0.75rem; }
        .btn-detail {
            margin-top: auto; width: 100%; height: 34px;
            background: linear-gradient(135deg, #0f766e, #0d9488); color: white;
            border: none; border-radius: 8px; font-size: 0.8rem; font-weight: 600;
            cursor: pointer; transition: all 0.2s; text-align: center; text-decoration: none;
            display: flex; align-items: center; justify-content: center; gap: 5px;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .btn-detail:hover { box-shadow: 0 4px 12px rgba(15,118,110,0.3); transform: translateY(-1px); color: white; }
        .btn-detail-outline { background: transparent; border: 1.5px solid #0f766e; color: #0f766e; }
        .btn-detail-outline:hover { background: #ecfdf5; color: #0f766e; }

        /* ALERTS */
        .info-box { padding: 10px 14px; border-radius: 10px; font-size: 0.82rem; background: #eff6ff; border: 1px solid #bfdbfe; color: #1d4ed8; margin-bottom: 1rem; }
        .success-box { padding: 10px 14px; border-radius: 10px; font-size: 0.82rem; background: #f0fdf4; border: 1px solid #86efac; color: #166534; margin-bottom: 1rem; }
        .warn-box { padding: 10px 14px; border-radius: 10px; font-size: 0.82rem; background: #fffbeb; border: 1px solid #fde68a; color: #92400e; }
        .ing-pill { display: inline-block; padding: 3px 9px; background: #ecfdf5; color: #0f766e; border: 1px solid #a7f3d0; border-radius: 20px; font-size: 0.75rem; font-weight: 600; margin: 2px; }

        /* EMPTY */
        .empty-state { background: white; border: 1.5px dashed #e2e8f0; border-radius: 14px; padding: 2.5rem 2rem; text-align: center; color: #94a3b8; }
        .empty-title { font-size: 0.88rem; font-weight: 700; color: #64748b; margin-bottom: 0.3rem; }
        .empty-sub { font-size: 0.8rem; }

        /* MODAL */
        .modal-content { border: none; border-radius: 16px; overflow: hidden; box-shadow: 0 20px 50px rgba(15,23,42,0.2); }
        .modal-hero { background: linear-gradient(135deg, #064e3b, #0f766e); padding: 1.25rem 1.5rem; position: relative; overflow: hidden; }
        .modal-hero::before { content: ''; position: absolute; top: -30%; right: -10%; width: 180px; height: 180px; background: radial-gradient(circle, rgba(255,255,255,0.1), transparent 70%); border-radius: 50%; }
        .modal-title-c { font-size: 1rem; font-weight: 700; color: white; }
        .modal-cat-c { font-size: 0.72rem; color: rgba(255,255,255,0.65); margin-top: 2px; }
        .modal-body-c { padding: 1.25rem; background: #f8fafc; }
        .modal-section { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 1rem; margin-bottom: 0.75rem; }
        .modal-section-title { font-size: 0.68rem; font-weight: 700; text-transform: uppercase; color: #94a3b8; letter-spacing: 0.5px; margin-bottom: 0.6rem; }
        .modal-stat { display: flex; justify-content: space-between; align-items: center; padding: 5px 0; border-bottom: 1px solid #f8fafc; }
        .modal-stat:last-child { border-bottom: none; }
        .modal-sk { font-size: 0.78rem; color: #64748b; }
        .modal-sv { font-size: 0.82rem; font-weight: 600; color: #1e293b; }
        .ing-row-m { display: flex; justify-content: space-between; align-items: center; padding: 5px 0; border-bottom: 1px solid #f8fafc; }
        .ing-row-m:last-child { border-bottom: none; }
        .ing-dot { width: 6px; height: 6px; border-radius: 50%; background: #0f766e; flex-shrink: 0; }
        .total-row-m { display: flex; justify-content: space-between; font-weight: 700; color: #0f766e; margin-top: 0.6rem; padding-top: 0.6rem; border-top: 1.5px solid #a7f3d0; }
        .step-item-m { display: flex; gap: 9px; margin-bottom: 0.6rem; align-items: flex-start; }
        .step-n-m { width: 22px; height: 22px; border-radius: 5px; background: linear-gradient(135deg, #0f766e, #0d9488); color: white; font-size: 0.68rem; font-weight: 700; display: flex; align-items: center; justify-content: center; flex-shrink: 0; margin-top: 1px; }
        .step-t-m { font-size: 0.82rem; color: #475569; line-height: 1.55; }
        .modal-footer-c { padding: 0.875rem 1.25rem; background: white; border-top: 1px solid #f1f5f9; }
        .btn-close-c { height: 34px; background: #f1f5f9; color: #475569; border: 1.5px solid #e2e8f0; border-radius: 8px; font-size: 0.82rem; font-weight: 600; padding: 0 16px; cursor: pointer; font-family: 'Plus Jakarta Sans', sans-serif; }
        .btn-close-c:hover { background: #e2e8f0; }
    </style>
</head>
<body>

    <nav class="navbar navbar-premium navbar-expand-lg shadow-sm sticky-top py-2">
        <div class="container">
            <a class="navbar-brand text-success d-flex align-items-center gap-2" href="dashboard.jsp">
                <i class="fa-solid fa-utensils"></i> Smart Meal Planner
            </a>
            <div class="ms-auto d-flex gap-2">
                <a href="MealPlannerServlet?action=profilePage" class="btn nav-pill np-outline">
                    <i class="fa-solid fa-user"></i> Profil
                </a>
                <a href="dashboard.jsp" class="btn nav-pill np-green">
                    <i class="fa-solid fa-house"></i> Dashboard
                </a>
                <a href="MealPlannerServlet?action=logout" class="btn nav-pill np-danger">
                    <i class="fa-solid fa-right-from-bracket"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <!-- HERO -->
    <div class="page-hero">
        <div class="blob blob-a"></div>
        <div class="blob blob-b"></div>
        <div class="container hero-inner">
            <div class="hero-tag"><i class="fa-solid fa-lightbulb fa-xs"></i> Sistem Rekomendasi Cerdas</div>
            <h1 class="hero-title">Rekomendasi Menu</h1>
            <p class="hero-sub">Temukan resep berdasarkan bahan di kulkas, database lokal, atau API online Spoonacular.</p>
        </div>
    </div>

    <div class="container content-wrap">
        <div class="row g-4">

            <!-- SIDEBAR -->
            <div class="col-lg-4">

                <!-- Scan Gudang -->
                <div class="sidebar-card">
                    <div class="sidebar-card-header">
                        <div class="sc-icon" style="background:#ecfdf5;"><i class="fa-solid fa-magnifying-glass" style="color:#0f766e;"></i></div>
                        <div><div class="sc-title">Pindai Seluruh Gudang</div><div class="sc-sub">Scan semua bahan database</div></div>
                    </div>
                    <div class="sidebar-card-body">
                        <a href="MealPlannerServlet?action=rekomendasiBahanDatabase&source=local" class="btn-scan-outline">
                            <i class="fa-solid fa-database fa-sm"></i> Cari dari Database Lokal
                        </a>
                        <a href="MealPlannerServlet?action=rekomendasiBahanDatabase&source=api" class="btn-scan-solid">
                            <i class="fa-solid fa-globe fa-sm"></i> Cari dari API Online
                        </a>
                    </div>
                </div>

                <!-- Pilih Manual -->
                <div class="sidebar-card">
                    <div class="sidebar-card-header">
                        <div class="sc-icon" style="background:#eff6ff;"><i class="fa-solid fa-sliders" style="color:#3b82f6;"></i></div>
                        <div><div class="sc-title">Pilih Bahan Manual</div><div class="sc-sub">Kombinasi bahan kustom</div></div>
                    </div>
                    <div class="sidebar-card-body">
                        <form action="MealPlannerServlet" method="POST">
                            <input type="hidden" name="action" value="rekomendasiBahanKustom">
                            <div style="margin-bottom:0.75rem;">
                                <label class="f-lbl">Pilih dari bahan tersimpan</label>
                                <div class="checkbox-scroll">
                                    <% List<Bahan> daftarBahanGlobal = (List<Bahan>) session.getAttribute("daftarBahanGlobal");
                                       if (daftarBahanGlobal != null && !daftarBahanGlobal.isEmpty()) {
                                           for (Bahan b : daftarBahanGlobal) { %>
                                    <div class="form-check mb-1">
                                        <input class="form-check-input" type="checkbox" name="bahanPilihan[]" value="<%= b.getNama() %>" id="bhn_<%= b.getNama().replaceAll("\\s+","_") %>">
                                        <label class="form-check-label" for="bhn_<%= b.getNama().replaceAll("\\s+","_") %>"><%= b.getNama() %></label>
                                    </div>
                                    <% } } else { %>
                                    <span style="font-size:0.78rem;color:#94a3b8;">Tidak ada bahan tersimpan.</span>
                                    <% } %>
                                </div>
                            </div>
                            <div style="margin-bottom:0.75rem;">
                                <label class="f-lbl">Tambah bahan lain (opsional)</label>
                                <input type="text" name="bahanKustomText" class="f-inp" placeholder="Contoh: ayam, keju (pisah koma)">
                            </div>
                            <div style="margin-bottom:0.875rem;">
                                <label class="f-lbl">Cari resep dari</label>
                                <div class="source-toggle">
                                    <div class="source-opt">
                                        <input type="radio" name="source" value="local" id="src_local" checked>
                                        <label for="src_local" class="source-lbl"><i class="fa-solid fa-database fa-xs"></i> Lokal (DB)</label>
                                    </div>
                                    <div class="source-opt">
                                        <input type="radio" name="source" value="api" id="src_api">
                                        <label for="src_api" class="source-lbl"><i class="fa-solid fa-globe fa-xs"></i> Online (API)</label>
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn-run"><i class="fa-solid fa-rocket fa-sm"></i> Jalankan Rekomendasi</button>
                        </form>
                    </div>
                </div>

                <!-- Budget -->
                <div class="sidebar-card">
                    <div class="sidebar-card-header">
                        <div class="sc-icon" style="background:#fef3c7;"><i class="fa-solid fa-coins" style="color:#d97706;"></i></div>
                        <div><div class="sc-title">Rekomendasi Budget</div><div class="sc-sub">Menu sesuai anggaran Anda</div></div>
                    </div>
                    <div class="sidebar-card-body">
                        <form action="MealPlannerServlet" method="POST">
                            <input type="hidden" name="action" value="rekomendasi">
                            <div style="margin-bottom:0.75rem;">
                                <label class="f-lbl">Batas anggaran maksimal</label>
                                <div class="budget-input-group">
                                    <span class="budget-prefix">Rp</span>
                                    <input type="number" name="budgetMaksRekomendasi" class="budget-inp" placeholder="Contoh: 25000" required min="1">
                                </div>
                            </div>
                            <button type="submit" class="btn-budget"><i class="fa-solid fa-magnifying-glass-dollar fa-sm"></i> Cari Menu Online</button>
                        </form>
                    </div>
                </div>

            </div><!-- /sidebar -->

            <!-- RESULTS -->
            <div class="col-lg-8">

                <%
                    List<Resep> hasilRekomendasi = (List<Resep>) session.getAttribute("hasilRekomendasi");
                    Double targetBudgetRek = (Double) session.getAttribute("targetBudgetRek");
                    if (hasilRekomendasi != null) {
                %>

                <div class="success-box">
                    <i class="fa-solid fa-circle-check me-2"></i>
                    Rekomendasi berhasil! Menu berikut tidak melebihi anggaran <strong>Rp <%= String.format("%,.0f", targetBudgetRek) %></strong>.
                </div>

                <div class="results-head">
                    <div class="results-title">Menu Online Sesuai Anggaran</div>
                    <span class="results-count"><%= hasilRekomendasi.size() %> resep</span>
                </div>

                <% if (hasilRekomendasi.isEmpty()) { %>
                <div class="warn-box"><i class="fa-solid fa-triangle-exclamation me-2"></i>Tidak ada resep yang cocok. Coba naikkan batas anggaran.</div>
                <% } else { %>
                <div class="row row-cols-1 row-cols-md-2 g-3">
                    <% int ri = 0; for (Resep r : hasilRekomendasi) { ri++; double th = r.hitungTotalHarga(); %>
                    <div class="col">
                        <div class="recipe-card">
                            <div class="recipe-card-body">
                                <span class="recipe-tag tag-budget"><%= r.getKategori() != null ? r.getKategori() : "Budget" %></span>
                                <div class="recipe-name"><%= r.getNama() %></div>
                                <div class="recipe-meta"><i class="fa-solid fa-fire fa-xs me-1"></i><%= r.getKalori() %> kkal</div>
                                <div class="recipe-price">Rp <%= String.format("%,.0f", th) %></div>
                                <button type="button" class="btn-detail" data-bs-toggle="modal" data-bs-target="#bModal_<%= ri %>">
                                    <i class="fa-solid fa-book-open fa-xs"></i> Lihat Detail
                                </button>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } %>

                <% } else { %>

                <% String bahanDigunakan = (String) request.getAttribute("bahanDigunakan");
                   if (bahanDigunakan != null && !bahanDigunakan.isEmpty()) { %>
                <div class="info-box">
                    <strong><i class="fa-solid fa-carrot me-2"></i>Bahan yang dicocokkan:</strong>
                    <div style="margin-top:5px;">
                        <% for (String bhn : bahanDigunakan.split(",")) { bhn = bhn.trim(); if (!bhn.isEmpty()) { %>
                        <span class="ing-pill"><%= bhn %></span>
                        <% } } %>
                    </div>
                </div>
                <% } %>

                <% String activeSource = (String) request.getAttribute("activeSource");
                   if ("api".equalsIgnoreCase(activeSource)) {
                       List<ResepAPI> daftarRekomendasi = (List<ResepAPI>) request.getAttribute("daftarRekomendasi"); %>

                <div class="results-head">
                    <div class="results-title"><i class="fa-solid fa-globe me-2" style="color:#0f766e;"></i>Hasil Rekomendasi Online</div>
                    <% if (daftarRekomendasi != null) { %><span class="results-count"><%= daftarRekomendasi.size() %> resep</span><% } %>
                </div>

                <% if (daftarRekomendasi != null && !daftarRekomendasi.isEmpty()) { %>
                <div class="row row-cols-1 row-cols-md-2 g-3">
                    <% for (ResepAPI resep : daftarRekomendasi) { %>
                    <div class="col">
                        <div class="recipe-card">
                            <img src="<%= resep.getImageUrl() %>" alt="<%= resep.getJudul() %>" class="recipe-card-img" onerror="this.style.display='none';">
                            <div class="recipe-card-body">
                                <span class="recipe-tag tag-api">Online · Spoonacular</span>
                                <div class="recipe-name"><%= resep.getJudul() %></div>
                                <div class="recipe-meta">via API</div>
                                <a href="MealPlannerServlet?action=detailResep&type=api&id=<%= resep.getId() %>" class="btn-detail">
                                    <i class="fa-solid fa-arrow-right fa-xs"></i> Lihat Detail & Langkah
                                </a>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="warn-box"><i class="fa-solid fa-triangle-exclamation me-2"></i>Tidak ada resep online ditemukan. API key mungkin mencapai batas harian.</div>
                <% } %>

                <% } else if ("local".equalsIgnoreCase(activeSource)) {
                       List<Resep> daftarRekomendasiLokal = (List<Resep>) request.getAttribute("daftarRekomendasiLokal"); %>

                <div class="results-head">
                    <div class="results-title"><i class="fa-solid fa-database me-2" style="color:#3b82f6;"></i>Hasil Rekomendasi Lokal</div>
                    <% if (daftarRekomendasiLokal != null) { %><span class="results-count"><%= daftarRekomendasiLokal.size() %> resep</span><% } %>
                </div>

                <% if (daftarRekomendasiLokal != null && !daftarRekomendasiLokal.isEmpty()) { %>
                <div class="row row-cols-1 row-cols-md-2 g-3">
                    <% for (Resep resep : daftarRekomendasiLokal) { %>
                    <div class="col">
                        <div class="recipe-card">
                            <div class="recipe-card-body">
                                <span class="recipe-tag tag-local"><%= resep.getKategori() %></span>
                                <div class="recipe-name"><%= resep.getNama() %></div>
                                <div class="recipe-meta"><i class="fa-solid fa-fire fa-xs me-1"></i><%= resep.getKalori() %> kkal</div>
                                <div class="recipe-price">Rp <%= String.format("%,.0f", resep.hitungTotalHarga()) %></div>
                                <a href="MealPlannerServlet?action=detailResep&type=local&id=<%= resep.getNama() %>" class="btn-detail btn-detail-outline">
                                    <i class="fa-solid fa-book-open fa-xs"></i> Lihat Detail
                                </a>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="warn-box"><i class="fa-solid fa-triangle-exclamation me-2"></i>Tidak ada resep lokal yang cocok dengan kombinasi bahan ini.</div>
                <% } %>

                <% } else { %>
                <div class="empty-state">
                    <div style="font-size:2rem;margin-bottom:0.75rem;opacity:0.4;"><i class="fa-solid fa-magnifying-glass"></i></div>
                    <div class="empty-title">Belum ada hasil</div>
                    <div class="empty-sub">Gunakan panel kiri untuk mencari rekomendasi resep.</div>
                </div>
                <% } %>
                <% } %>

            </div><!-- /results -->
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- MODALS -->
    <% List<Resep> modals = (List<Resep>) session.getAttribute("hasilRekomendasi");
       if (modals != null && !modals.isEmpty()) {
           int mi = 0;
           for (Resep r : modals) { mi++; double th = r.hitungTotalHarga(); %>
    <div class="modal fade" id="bModal_<%= mi %>" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-hero">
                    <button type="button" class="btn-close btn-close-white float-end" data-bs-dismiss="modal"></button>
                    <div class="modal-cat-c"><i class="fa-solid fa-utensils me-1 fa-xs"></i><%= r.getKategori() %></div>
                    <div class="modal-title-c"><%= r.getNama() %></div>
                </div>
                <div class="modal-body-c">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <div class="modal-section">
                                <div class="modal-section-title">Info Menu</div>
                                <div class="modal-stat"><span class="modal-sk">Kategori</span><span class="modal-sv"><%= r.getKategori() %></span></div>
                                <div class="modal-stat"><span class="modal-sk">Kalori</span><span class="modal-sv"><%= r.getKalori() %> kkal</span></div>
                                <div class="modal-stat"><span class="modal-sk">Total Biaya</span><span class="modal-sv" style="color:#0f766e;font-weight:700;">Rp <%= String.format("%,.0f", th) %></span></div>
                            </div>
                        </div>
                        <div class="col-md-8">
                            <div class="modal-section">
                                <div class="modal-section-title"><i class="fa-solid fa-carrot me-1"></i> Bahan yang Dibutuhkan</div>
                                <% if (r.getDaftarBahan() != null && !r.getDaftarBahan().isEmpty()) {
                                       for (Bahan b : r.getDaftarBahan()) { double sub = b.getHarga() * b.getJumlah(); %>
                                <div class="ing-row-m">
                                    <div class="d-flex align-items-center gap-2"><div class="ing-dot"></div><span style="font-size:0.82rem;"><%= b.getNama() %></span><span style="font-size:0.75rem;color:#94a3b8;"><%= String.format("%.0f", b.getJumlah()) %> <%= b.getSatuan() %></span></div>
                                    <span style="font-size:0.8rem;font-weight:500;">Rp <%= String.format("%,.0f", sub) %></span>
                                </div>
                                <% } } else { %><span style="font-size:0.78rem;color:#94a3b8;">Bahan tidak terperinci.</span><% } %>
                                <div class="total-row-m"><span>Total Belanja</span><span>Rp <%= String.format("%,.0f", th) %></span></div>
                            </div>
                        </div>
                    </div>
                    <% if (r.getCaraMasak() != null && !r.getCaraMasak().trim().isEmpty()) { %>
                    <div class="modal-section" style="margin-top:0.75rem;">
                        <div class="modal-section-title"><i class="fa-solid fa-list-check me-1"></i> Cara Memasak</div>
                        <% String[] steps = r.getCaraMasak().split("\n+"); int sn = 0;
                           for (String s : steps) { s = s.trim(); if (!s.isEmpty()) { sn++; %>
                        <div class="step-item-m"><div class="step-n-m"><%= sn %></div><div class="step-t-m"><%= s %></div></div>
                        <% } } %>
                    </div>
                    <% } %>
                </div>
                <div class="modal-footer-c d-flex justify-content-end">
                    <button class="btn-close-c" data-bs-dismiss="modal">Tutup</button>
                </div>
            </div>
        </div>
    </div>
    <% } } %>

    <%
        session.removeAttribute("hasilRekomendasi");
        session.removeAttribute("targetBudgetRek");
    %>
</body>
</html>