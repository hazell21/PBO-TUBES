<%@page import="model.Mahasiswa" %>
<%@page import="model.MealPlanner" %>
<%@page import="model.Resep" %>
<%@page import="model.Bahan" %>
<%@page import="model.BudgetManager" %>
<%@page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<%
    Mahasiswa mhs = (Mahasiswa) session.getAttribute("mahasiswa");
    MealPlanner planner = (MealPlanner) session.getAttribute("planner");
    List<Bahan> daftarBahanGlobal = (List<Bahan>) session.getAttribute("daftarBahanGlobal");

    if (mhs == null || planner == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    BudgetManager bgManager = new BudgetManager(mhs.getBudget());
    double totalPengeluaran = 0;
    if (planner.getDaftarJadwal() != null) {
        totalPengeluaran = bgManager.hitungPengeluaran(planner.getDaftarJadwal());
    }
    String statusAnggaran = bgManager.CekBudget(totalPengeluaran);
    int totalGiziKalori = planner.HitungTotalGiziHarian();

    String successMsg = (String) session.getAttribute("successMessage");
    String errorMsg = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");

    double budgetAwal = mhs.getBudget() + totalPengeluaran;
    double persentaseTerpakai = budgetAwal > 0 ? (totalPengeluaran / budgetAwal) * 100 : 0;
    boolean isOverBudget = statusAnggaran.toLowerCase().contains("over") || statusAnggaran.toLowerCase().contains("boros");
    boolean isWarning = statusAnggaran.toLowerCase().contains("warning") || statusAnggaran.toLowerCase().contains("waspada");
%>
<html lang="id">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – Smart Meal Planner</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f0fdf4; color: #1e293b; min-height: 100vh; }
        h1,h2,h3,h4,h5,h6,.navbar-brand { font-family: 'Outfit', sans-serif; }

        ::-webkit-scrollbar { width: 5px; }
        ::-webkit-scrollbar-track { background: #f1f5f9; }
        ::-webkit-scrollbar-thumb { background: #cbd5e1; border-radius: 3px; }

        /* NAVBAR */
        .navbar-premium {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid #e2e8f0;
        }
        .navbar-brand { font-size: 1.3rem; font-weight: 800; letter-spacing: -0.5px; }
        .nav-pill {
            border-radius: 10px; font-weight: 600; font-size: 0.82rem;
            padding: 7px 14px; transition: all 0.2s;
            display: inline-flex; align-items: center; gap: 6px;
        }
        .np-outline { border: 1.5px solid #e2e8f0; color: #475569; background: transparent; }
        .np-outline:hover { background: #f1f5f9; color: #1e293b; }
        .np-green { background: #ecfdf5; color: #0f766e; border: 1.5px solid #a7f3d0; }
        .np-green:hover { background: #d1fae5; }
        .np-danger { background: #fef2f2; color: #dc2626; border: 1.5px solid #fecaca; }
        .np-danger:hover { background: #fee2e2; }

        /* ALERTS */
        .alert-custom {
            padding: 12px 16px; border-radius: 12px;
            display: flex; align-items: center; gap: 10px;
            font-size: 0.85rem; font-weight: 500; margin-bottom: 1.25rem;
        }
        .alert-success-c { background: #f0fdf4; border: 1px solid #86efac; color: #166534; }
        .alert-danger-c { background: #fef2f2; border: 1px solid #fca5a5; color: #991b1b; }
        .alert-close { margin-left: auto; cursor: pointer; background: none; border: none; font-size: 1rem; opacity: 0.6; }
        .alert-close:hover { opacity: 1; }

        /* STAT CARDS */
        .stat-card {
            background: white; border-radius: 14px;
            border: 1px solid rgba(226,232,240,0.8);
            box-shadow: 0 2px 12px rgba(15,23,42,0.04);
            padding: 1.1rem 1.2rem;
            display: flex; align-items: center; gap: 1rem;
            transition: all 0.2s;
        }
        .stat-card:hover { box-shadow: 0 6px 24px rgba(15,23,42,0.08); transform: translateY(-2px); }
        .stat-icon {
            width: 44px; height: 44px; flex-shrink: 0;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.1rem;
        }
        .stat-val { font-family: 'Outfit', sans-serif; font-size: 1.1rem; font-weight: 800; color: #1e293b; letter-spacing: -0.3px; line-height: 1.1; }
        .stat-lbl { font-size: 0.7rem; color: #94a3b8; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }

        /* PROFILE CARD */
        .profile-card {
            background: linear-gradient(135deg, #064e3b, #0f766e, #0d9488);
            border-radius: 16px; padding: 1.4rem;
            color: white; position: relative; overflow: hidden;
            box-shadow: 0 6px 24px rgba(15,118,110,0.25);
            margin-bottom: 1rem;
        }
        .profile-card::before {
            content: ''; position: absolute; top: -40%; right: -20%;
            width: 200px; height: 200px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }
        .profile-card-inner { position: relative; z-index: 1; }
        .avatar {
            width: 46px; height: 46px; border-radius: 10px;
            background: rgba(255,255,255,0.18);
            border: 2px solid rgba(255,255,255,0.3);
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem; font-weight: 800; color: white;
            font-family: 'Outfit', sans-serif; flex-shrink: 0;
        }
        .budget-amount {
            font-family: 'Outfit', sans-serif;
            font-size: 1.5rem; font-weight: 800;
            letter-spacing: -0.8px; line-height: 1;
        }
        .progress-slim { height: 4px; border-radius: 10px; background: rgba(255,255,255,0.2); margin: 7px 0 3px; }
        .progress-slim .bar { height: 100%; border-radius: 10px; background: white; }
        .edit-link {
            display: inline-flex; align-items: center; gap: 5px;
            background: rgba(255,255,255,0.12); border: 1px solid rgba(255,255,255,0.2);
            color: white; padding: 5px 12px; border-radius: 7px;
            font-size: 0.77rem; font-weight: 600;
            text-decoration: none; transition: all 0.2s; margin-top: 8px;
        }
        .edit-link:hover { background: rgba(255,255,255,0.22); color: white; }

        /* ANALYTICS CARD */
        .analytics-card {
            background: white; border-radius: 14px;
            border: 1px solid rgba(226,232,240,0.8);
            box-shadow: 0 2px 12px rgba(15,23,42,0.04);
            padding: 1.1rem; margin-bottom: 1rem;
        }
        .section-title {
            font-size: 0.7rem; font-weight: 700;
            text-transform: uppercase; color: #94a3b8;
            letter-spacing: 0.6px; margin-bottom: 0.75rem;
        }
        .progress-track {
            height: 6px; border-radius: 10px; background: #f1f5f9; overflow: hidden;
        }
        .progress-fill { height: 100%; border-radius: 10px; transition: width 0.6s ease; }
        .status-tag {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 5px 12px; border-radius: 8px;
            font-size: 0.77rem; font-weight: 700;
            margin-top: 0.6rem; width: 100%; justify-content: center;
        }
        .tag-ok { background: #ecfdf5; color: #0f766e; }
        .tag-warn { background: #fffbeb; color: #d97706; }
        .tag-over { background: #fef2f2; color: #dc2626; }

        /* MAIN CARD */
        .main-card {
            background: white; border-radius: 14px;
            border: 1px solid rgba(226,232,240,0.8);
            box-shadow: 0 2px 12px rgba(15,23,42,0.04);
            overflow: hidden; margin-bottom: 1rem;
        }
        .main-card-header {
            padding: 0.875rem 1.25rem;
            border-bottom: 1px solid #f8fafc;
            display: flex; align-items: center; gap: 9px;
            background: #fafafa;
        }
        .card-icon-badge {
            width: 30px; height: 30px; border-radius: 8px;
            display: flex; align-items: center; justify-content: center; font-size: 0.82rem;
        }
        .main-card-body { padding: 1.1rem 1.25rem; }

        /* ACCORDION */
        .acc-btn {
            width: 100%; background: none; border: none;
            padding: 0.7rem 0; text-align: left;
            font-size: 0.82rem; font-weight: 600; color: #475569;
            cursor: pointer; display: flex; align-items: center;
            justify-content: space-between;
            font-family: 'Plus Jakarta Sans', sans-serif;
            border-bottom: 1px solid #f8fafc;
        }
        .acc-btn:last-of-type { border-bottom: none; }
        .acc-btn[aria-expanded="true"] { color: #0f766e; }
        .acc-btn .chevron { font-size: 0.7rem; transition: transform 0.2s; }
        .acc-btn[aria-expanded="true"] .chevron { transform: rotate(90deg); }

        /* FORM */
        .f-label {
            font-size: 0.7rem; font-weight: 700; text-transform: uppercase;
            color: #64748b; letter-spacing: 0.5px; margin-bottom: 0.25rem; display: block;
        }
        .f-input {
            width: 100%; height: 36px; padding: 0 10px;
            border: 1.5px solid #e2e8f0; border-radius: 8px;
            font-size: 0.83rem; color: #1e293b; background: white;
            outline: none; transition: all 0.2s;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .f-input:focus { border-color: #0f766e; box-shadow: 0 0 0 3px rgba(15,118,110,0.1); }
        .f-select {
            width: 100%; height: 36px; padding: 0 10px;
            border: 1.5px solid #e2e8f0; border-radius: 8px;
            font-size: 0.83rem; color: #1e293b; background: white;
            outline: none; cursor: pointer;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .f-select:focus { border-color: #0f766e; box-shadow: 0 0 0 3px rgba(15,118,110,0.1); }
        .f-textarea {
            width: 100%; padding: 8px 10px;
            border: 1.5px solid #e2e8f0; border-radius: 8px;
            font-size: 0.83rem; color: #1e293b; background: white;
            outline: none; resize: vertical; min-height: 56px;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .f-textarea:focus { border-color: #0f766e; box-shadow: 0 0 0 3px rgba(15,118,110,0.1); }

        /* BUTTONS */
        .btn-primary-c {
            height: 36px; background: linear-gradient(135deg, #0f766e, #0d9488);
            color: white; border: none; border-radius: 8px;
            font-size: 0.82rem; font-weight: 600; padding: 0 16px;
            cursor: pointer; transition: all 0.2s;
            font-family: 'Plus Jakarta Sans', sans-serif;
            display: inline-flex; align-items: center; gap: 6px;
            box-shadow: 0 3px 10px rgba(15,118,110,0.2);
        }
        .btn-primary-c:hover { box-shadow: 0 5px 16px rgba(15,118,110,0.3); transform: translateY(-1px); }

        .btn-secondary-c {
            height: 36px; background: #1e293b; color: white;
            border: none; border-radius: 8px;
            font-size: 0.82rem; font-weight: 600; padding: 0 16px;
            cursor: pointer; transition: all 0.2s;
            font-family: 'Plus Jakarta Sans', sans-serif;
            display: inline-flex; align-items: center; gap: 6px;
        }
        .btn-secondary-c:hover { background: #0f172a; transform: translateY(-1px); }

        .btn-ghost-sm {
            height: 28px; background: #f1f5f9; color: #475569;
            border: 1px solid #e2e8f0; border-radius: 6px;
            font-size: 0.75rem; font-weight: 600; padding: 0 10px;
            cursor: pointer; font-family: 'Plus Jakarta Sans', sans-serif;
            display: inline-flex; align-items: center; gap: 4px;
        }
        .btn-ghost-sm:hover { background: #e2e8f0; }

        .btn-danger-sm {
            height: 32px; background: #fef2f2; color: #dc2626;
            border: 1.5px solid #fecaca; border-radius: 7px;
            font-size: 0.8rem; padding: 0 8px; cursor: pointer;
            width: 32px; justify-content: center;
            display: inline-flex; align-items: center;
        }
        .btn-danger-sm:hover { background: #fee2e2; }

        /* BAHAN ROW */
        .bahan-row { display: grid; grid-template-columns: 1fr 90px 32px; gap: 6px; align-items: end; margin-bottom: 6px; }

        /* INGREDIENT SECTION */
        .ingredient-section {
            background: #f8fafc; border: 1.5px dashed #e2e8f0;
            border-radius: 10px; padding: 0.875rem; margin-top: 0.75rem;
        }
        .ingredient-section-header {
            font-size: 0.7rem; font-weight: 700; color: #64748b;
            text-transform: uppercase; letter-spacing: 0.5px;
        }

        /* TABLE */
        .tbl { width: 100%; border-collapse: collapse; }
        .tbl th {
            padding: 9px 14px; font-size: 0.7rem; font-weight: 700;
            color: #94a3b8; text-transform: uppercase; letter-spacing: 0.5px;
            border-bottom: 1px solid #f1f5f9; text-align: left;
            background: #fafafa;
        }
        .tbl td {
            padding: 10px 14px; font-size: 0.84rem;
            border-bottom: 1px solid #f8fafc; vertical-align: middle;
        }
        .tbl tr:last-child td { border-bottom: none; }
        .tbl tr:hover td { background: #fafaf9; }
        .tbl .hari { font-weight: 700; color: #0f766e; }
        .tbl .waktu { font-size: 0.76rem; color: #64748b; }
        .tbl .menu-nm { font-weight: 600; }
        .tbl .kal { color: #f59e0b; font-weight: 600; font-size: 0.8rem; }
        .tbl .cost { font-weight: 700; color: #0f766e; font-family: 'Outfit', sans-serif; }
        .empty-td { text-align: center; padding: 2rem; color: #94a3b8; font-size: 0.84rem; }
    </style>
</head>
<body>

    <!-- NAVBAR -->
    <nav class="navbar navbar-premium navbar-expand-lg shadow-sm sticky-top py-2">
        <div class="container-fluid" style="max-width:1200px;">
            <a class="navbar-brand text-success d-flex align-items-center gap-2" href="dashboard.jsp">
                <i class="fa-solid fa-utensils"></i> Smart Meal Planner
            </a>
            <div class="ms-auto d-flex align-items-center gap-2">
                <a href="MealPlannerServlet?action=profilePage" class="btn nav-pill np-outline">
                    <i class="fa-solid fa-user"></i> Profil
                </a>
                <a href="MealPlannerServlet?action=rekomendasiBahanPage" class="btn nav-pill np-green">
                    <i class="fa-solid fa-lightbulb"></i> Rekomendasi
                </a>
                <a href="MealPlannerServlet?action=logout" class="btn nav-pill np-danger">
                    <i class="fa-solid fa-right-from-bracket"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid py-4" style="max-width:1200px;">

        <!-- ALERTS -->
        <% if (successMsg != null) { %>
        <div class="alert-custom alert-success-c" id="alertOk">
            <i class="fa-solid fa-circle-check"></i>
            <span><%= successMsg %></span>
            <button class="alert-close" onclick="this.parentElement.remove()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <% } %>
        <% if (errorMsg != null) { %>
        <div class="alert-custom alert-danger-c" id="alertErr">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <span><%= errorMsg %></span>
            <button class="alert-close" onclick="this.parentElement.remove()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <% } %>

        <!-- PAGE TITLE -->
        <div style="margin-bottom:1.25rem;">
            <div style="font-family:'Outfit',sans-serif;font-size:1.3rem;font-weight:800;color:#1e293b;letter-spacing:-0.4px;">Dashboard</div>
            <div style="font-size:0.82rem;color:#94a3b8;margin-top:2px;">Halo, <strong><%= mhs.getNama() %></strong> &mdash; berikut ringkasan rencana makan Anda.</div>
        </div>

        <!-- STAT CARDS -->
        <div class="row g-3 mb-4">
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#ecfdf5;"><i class="fa-solid fa-wallet" style="color:#0f766e;"></i></div>
                    <div>
                        <div class="stat-lbl">Sisa Anggaran</div>
                        <div class="stat-val" style="font-size:0.95rem;color:#0f766e;">Rp <%= String.format("%,.0f", mhs.getBudget()) %></div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#fef2f2;"><i class="fa-solid fa-cart-shopping" style="color:#dc2626;"></i></div>
                    <div>
                        <div class="stat-lbl">Total Pengeluaran</div>
                        <div class="stat-val" style="font-size:0.95rem;">Rp <%= String.format("%,.0f", totalPengeluaran) %></div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#fef3c7;"><i class="fa-solid fa-bolt" style="color:#f59e0b;"></i></div>
                    <div>
                        <div class="stat-lbl">Energi Harian</div>
                        <div class="stat-val"><%= totalGiziKalori %> <span style="font-size:0.7rem;font-weight:500;color:#94a3b8;">kkal</span></div>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-3">
                <div class="stat-card">
                    <div class="stat-icon" style="background:<%= isOverBudget ? "#fef2f2" : isWarning ? "#fffbeb" : "#ecfdf5" %>;">
                        <i class="fa-solid fa-shield-halved" style="color:<%= isOverBudget ? "#dc2626" : isWarning ? "#d97706" : "#0f766e" %>;"></i>
                    </div>
                    <div>
                        <div class="stat-lbl">Status</div>
                        <div class="stat-val" style="font-size:0.8rem;color:<%= isOverBudget ? "#dc2626" : isWarning ? "#d97706" : "#0f766e" %>;"><%= statusAnggaran %></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-3">

            <!-- SIDEBAR -->
            <div class="col-lg-4">

                <!-- Profile Card -->
                <div class="profile-card">
                    <div class="profile-card-inner">
                        <div class="d-flex align-items-center gap-3 mb-3">
                            <div class="avatar"><%= mhs.getNama().substring(0,1).toUpperCase() %></div>
                            <div>
                                <div style="font-weight:700;font-size:0.95rem;color:white;line-height:1.2;"><%= mhs.getNama() %></div>
                                <div style="font-size:0.73rem;color:rgba(255,255,255,0.6);">NIM <%= mhs.getNim() %></div>
                                <div style="font-size:0.71rem;color:rgba(255,255,255,0.5);margin-top:1px;"><%= mhs.getEmail() %></div>
                            </div>
                        </div>
                        <hr style="border-color:rgba(255,255,255,0.2);margin:0.6rem 0;">
                        <div style="font-size:0.67rem;text-transform:uppercase;color:rgba(255,255,255,0.55);letter-spacing:0.7px;font-weight:600;">Sisa Anggaran</div>
                        <div class="budget-amount">Rp <%= String.format("%,.0f", mhs.getBudget()) %></div>
                        <div class="progress-slim">
                            <div class="bar" style="width:<%= Math.min(persentaseTerpakai, 100) %>%;"></div>
                        </div>
                        <div style="font-size:0.7rem;color:rgba(255,255,255,0.55);">Terpakai: <%= String.format("%.1f", persentaseTerpakai) %>%</div>
                        <a href="MealPlannerServlet?action=profilePage" class="edit-link">
                            <i class="fa-solid fa-pen-to-square fa-xs"></i> Edit Profil & Anggaran
                        </a>
                    </div>
                </div>

                <!-- Analytics -->
                <div class="analytics-card">
                    <div class="section-title"><i class="fa-solid fa-chart-pie me-1"></i> Analisis Anggaran</div>
                    <div class="row g-2 mb-2">
                        <div class="col-6">
                            <div style="background:#f8fafc;border-radius:8px;padding:9px 11px;border:1px solid #e2e8f0;">
                                <div style="font-size:0.66rem;color:#94a3b8;font-weight:600;text-transform:uppercase;">Pengeluaran</div>
                                <div style="font-family:'Outfit',sans-serif;font-size:0.95rem;font-weight:700;color:#1e293b;">Rp <%= String.format("%,.0f", totalPengeluaran) %></div>
                            </div>
                        </div>
                        <div class="col-6">
                            <div style="background:#f8fafc;border-radius:8px;padding:9px 11px;border:1px solid #e2e8f0;">
                                <div style="font-size:0.66rem;color:#94a3b8;font-weight:600;text-transform:uppercase;">Energi</div>
                                <div style="font-family:'Outfit',sans-serif;font-size:0.95rem;font-weight:700;color:#1e293b;"><%= totalGiziKalori %> kkal</div>
                            </div>
                        </div>
                    </div>
                    <div style="font-size:0.7rem;color:#64748b;font-weight:600;display:flex;justify-content:space-between;margin-bottom:3px;">
                        <span>Pemakaian</span><span><%= String.format("%.1f", persentaseTerpakai) %>%</span>
                    </div>
                    <div class="progress-track">
                        <div class="progress-fill" style="width:<%= Math.min(persentaseTerpakai, 100) %>%;background:<%= isOverBudget ? "#ef4444" : isWarning ? "#f59e0b" : "#0f766e" %>;"></div>
                    </div>
                    <div class="status-tag <%= isOverBudget ? "tag-over" : isWarning ? "tag-warn" : "tag-ok" %>">
                        <i class="fa-solid fa-shield-halved fa-xs"></i> <%= statusAnggaran %>
                    </div>
                </div>

                <!-- Bahan Baku Card -->
                <div class="main-card">
                    <div class="main-card-header">
                        <div class="card-icon-badge" style="background:#fef3c7;"><i class="fa-solid fa-carrot" style="color:#d97706;font-size:0.8rem;"></i></div>
                        <div>
                            <div style="font-weight:700;font-size:0.85rem;">Bahan Baku Gudang</div>
                            <div style="font-size:0.7rem;color:#94a3b8;">Kelola inventaris bahan</div>
                        </div>
                    </div>
                    <div style="padding:0 1.25rem;">
                        <!-- Add Bahan -->
                        <button class="acc-btn" type="button" data-bs-toggle="collapse" data-bs-target="#addBahan" aria-expanded="false">
                            <span><i class="fa-solid fa-plus me-2" style="color:#0f766e;font-size:0.75rem;"></i>Tambah bahan baru</span>
                            <span class="chevron">&#9654;</span>
                        </button>
                        <div id="addBahan" class="collapse" style="padding-bottom:1rem;">
                            <form action="MealPlannerServlet" method="POST">
                                <input type="hidden" name="action" value="addBahanMaster">
                                <div class="mb-2">
                                    <label class="f-label">Nama Bahan</label>
                                    <input type="text" name="namaBahanMaster" class="f-input" placeholder="Contoh: Telur" required>
                                </div>
                                <div class="row g-2 mb-2">
                                    <div class="col-6">
                                        <label class="f-label">Harga/Unit (Rp)</label>
                                        <input type="number" name="hargaBahanMaster" class="f-input" placeholder="2000" required>
                                    </div>
                                    <div class="col-6">
                                        <label class="f-label">Satuan</label>
                                        <input type="text" name="satuanBahanMaster" class="f-input" placeholder="butir" required>
                                    </div>
                                </div>
                                <button type="submit" class="btn-primary-c w-100" style="justify-content:center;">
                                    <i class="fa-solid fa-plus-circle"></i> Tambahkan
                                </button>
                            </form>
                        </div>

                        <!-- Edit Bahan -->
                        <button class="acc-btn" type="button" data-bs-toggle="collapse" data-bs-target="#editBahan" aria-expanded="false">
                            <span><i class="fa-solid fa-pen-to-square me-2" style="color:#f59e0b;font-size:0.75rem;"></i>Edit bahan yang ada</span>
                            <span class="chevron">&#9654;</span>
                        </button>
                        <div id="editBahan" class="collapse" style="padding-bottom:1rem;">
                            <form action="MealPlannerServlet" method="POST">
                                <input type="hidden" name="action" value="editBahanMaster">
                                <div class="mb-2">
                                    <label class="f-label">Pilih Bahan</label>
                                    <select name="namaBahanLama" class="f-select" required>
                                        <option value="" disabled selected>-- Pilih --</option>
                                        <% if (daftarBahanGlobal != null) {
                                               for (Bahan b : daftarBahanGlobal) { %>
                                        <option value="<%= b.getNama() %>"><%= b.getNama() %></option>
                                        <% } } %>
                                    </select>
                                </div>
                                <div class="mb-2">
                                    <label class="f-label">Nama Baru</label>
                                    <input type="text" name="namaBahanBaru" class="f-input" placeholder="Nama baru" required>
                                </div>
                                <div class="row g-2 mb-2">
                                    <div class="col-6">
                                        <label class="f-label">Harga Baru (Rp)</label>
                                        <input type="number" name="hargaBahanBaru" class="f-input" placeholder="2000" required>
                                    </div>
                                    <div class="col-6">
                                        <label class="f-label">Satuan Baru</label>
                                        <input type="text" name="satuanBahanBaru" class="f-input" placeholder="butir" required>
                                    </div>
                                </div>
                                <button type="submit" class="btn-primary-c w-100" style="background:linear-gradient(135deg,#f59e0b,#d97706);box-shadow:0 3px 10px rgba(245,158,11,0.2);justify-content:center;">
                                    <i class="fa-solid fa-arrows-rotate"></i> Update Bahan
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

            </div><!-- /sidebar -->

            <!-- MAIN CONTENT -->
            <div class="col-lg-8">

                <!-- Tambah Jadwal -->
                <div class="main-card">
                    <div class="main-card-header">
                        <div class="card-icon-badge" style="background:#ecfdf5;"><i class="fa-solid fa-calendar-plus" style="color:#0f766e;font-size:0.8rem;"></i></div>
                        <div>
                            <div style="font-weight:700;font-size:0.875rem;">Atur Rencana Makanan</div>
                            <div style="font-size:0.7rem;color:#94a3b8;">Tambahkan jadwal ke rencana mingguan</div>
                        </div>
                    </div>
                    <div class="main-card-body">
                        <form action="MealPlannerServlet" method="POST">
                            <input type="hidden" name="action" value="addJadwal">
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label class="f-label">Pilih Hari</label>
                                    <select name="hari" class="f-select" required>
                                        <option value="Senin">Senin</option>
                                        <option value="Selasa">Selasa</option>
                                        <option value="Rabu">Rabu</option>
                                        <option value="Kamis">Kamis</option>
                                        <option value="Jumat">Jumat</option>
                                        <option value="Sabtu">Sabtu</option>
                                        <option value="Minggu">Minggu</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="f-label">Waktu Makan</label>
                                    <select name="waktuMakan" class="f-select" required>
                                        <option value="Sarapan">Sarapan</option>
                                        <option value="Makan Siang">Makan Siang</option>
                                        <option value="Makan Malam">Makan Malam</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="f-label">Menu</label>
                                    <select name="namaResep" class="f-select" required>
                                        <% for (Resep r : planner.getDaftarResep()) { %>
                                        <option value="<%= r.getNama() %>"><%= r.getNama() %> (Rp <%= String.format("%,.0f", r.hitungTotalHarga()) %>)</option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-12 text-end">
                                    <button type="submit" class="btn-primary-c">
                                        <i class="fa-solid fa-plus-circle"></i> Tambah ke Jadwal
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Tambah Resep -->
                <div class="main-card">
                    <div class="main-card-header">
                        <div class="card-icon-badge" style="background:#eff6ff;"><i class="fa-solid fa-kitchen-set" style="color:#3b82f6;font-size:0.8rem;"></i></div>
                        <div>
                            <div style="font-weight:700;font-size:0.875rem;">Daftarkan Menu Baru</div>
                            <div style="font-size:0.7rem;color:#94a3b8;">Tambah resep ke database lokal</div>
                        </div>
                    </div>
                    <div class="main-card-body">
                        <form action="MealPlannerServlet" method="POST">
                            <input type="hidden" name="action" value="addResepBaru">
                            <div class="row g-3 mb-2">
                                <div class="col-md-5">
                                    <label class="f-label">Nama Menu</label>
                                    <input type="text" name="namaResep" class="f-input" placeholder="Contoh: Nasi Goreng" required>
                                </div>
                                <div class="col-md-3">
                                    <label class="f-label">Kalori (kkal)</label>
                                    <input type="number" name="calori" class="f-input" placeholder="350" required>
                                </div>
                                <div class="col-md-4">
                                    <label class="f-label">Kategori</label>
                                    <select name="kategori" class="f-select" required>
                                        <option value="Sarapan">Sarapan</option>
                                        <option value="Makan Siang">Makan Siang</option>
                                        <option value="Makan Malam">Makan Malam</option>
                                    </select>
                                </div>
                                <div class="col-12">
                                    <label class="f-label">Cara Memasak</label>
                                    <textarea name="caraMasak" class="f-textarea" placeholder="Tuliskan langkah-langkah memasak..." required></textarea>
                                </div>
                            </div>

                            <div class="ingredient-section">
                                <div class="d-flex align-items-center justify-content-between mb-2">
                                    <span class="ingredient-section-header"><i class="fa-solid fa-list-check me-1"></i>Bahan & Takaran</span>
                                    <button type="button" class="btn-ghost-sm" onclick="tambahBaris()">
                                        <i class="fa-solid fa-plus fa-xs"></i> Tambah Baris
                                    </button>
                                </div>
                                <div id="containerBahanResep">
                                    <div class="bahan-row">
                                        <select name="namaBahan[]" class="f-select" style="height:32px;font-size:0.8rem;" required>
                                            <option value="" disabled selected>Pilih bahan</option>
                                            <% if (daftarBahanGlobal != null) {
                                                   for (Bahan b : daftarBahanGlobal) { %>
                                            <option value="<%= b.getNama() %>"><%= b.getNama() %> (Rp <%= String.format("%,.0f", b.getHargaDasar()) %>/<%= b.getSatuan() %>)</option>
                                            <% } } %>
                                        </select>
                                        <input type="number" step="0.01" name="jumlahBahan[]" class="f-input" style="height:32px;font-size:0.8rem;" placeholder="Jumlah" required>
                                        <button type="button" class="btn-danger-sm" onclick="hapusBaris(this)"><i class="fa-solid fa-trash-can fa-xs"></i></button>
                                    </div>
                                </div>
                            </div>

                            <div class="text-end mt-3">
                                <button type="submit" class="btn-secondary-c">
                                    <i class="fa-solid fa-floppy-disk"></i> Simpan Resep
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Jadwal Table -->
                <div class="main-card">
                    <div class="main-card-header">
                        <div class="card-icon-badge" style="background:#f5f3ff;"><i class="fa-solid fa-clock-rotate-left" style="color:#7c3aed;font-size:0.8rem;"></i></div>
                        <div>
                            <div style="font-weight:700;font-size:0.875rem;">Jadwal Makan Mingguan</div>
                            <div style="font-size:0.7rem;color:#94a3b8;">
                                <% if (planner.getDaftarJadwal() != null && !planner.getDaftarJadwal().isEmpty()) { %>
                                <%= planner.getDaftarJadwal().size() %> jadwal terdaftar
                                <% } else { %>Belum ada jadwal<% } %>
                            </div>
                        </div>
                    </div>
                    <div style="overflow-x:auto;">
                        <table class="tbl">
                            <thead>
                                <tr>
                                    <th>Hari</th>
                                    <th>Waktu Makan</th>
                                    <th>Menu</th>
                                    <th>Kalori</th>
                                    <th>Estimasi Biaya</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (planner.getDaftarJadwal() == null || planner.getDaftarJadwal().isEmpty()) { %>
                                <tr><td colspan="5" class="empty-td"><i class="fa-solid fa-inbox d-block fs-4 mb-2 opacity-50"></i>Belum ada jadwal makan.</td></tr>
                                <% } else {
                                       for (model.Jadwal j : planner.getDaftarJadwal()) { %>
                                <tr>
                                    <td><span class="hari"><%= j.getHari() %></span></td>
                                    <td><span class="waktu"><%= j.getWaktuMakan() %></span></td>
                                    <td><span class="menu-nm"><%= j.getMenu().getNama() %></span></td>
                                    <td><span class="kal"><i class="fa-solid fa-bolt fa-xs me-1"></i><%= j.getMenu().getKalori() %> kkal</span></td>
                                    <td><span class="cost">Rp <%= String.format("%,.0f", j.getMenu().hitungTotalHarga()) %></span></td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div><!-- /main -->
        </div><!-- /row -->
    </div><!-- /container -->

    <!-- TEMPLATE BAHAN (hidden) -->
    <div id="templateBaris" style="display:none;">
        <div class="bahan-row">
            <select name="namaBahan[]" class="f-select" style="height:32px;font-size:0.8rem;" required>
                <option value="" disabled selected>Pilih bahan</option>
                <% if (daftarBahanGlobal != null) {
                       for (Bahan b : daftarBahanGlobal) { %>
                <option value="<%= b.getNama() %>"><%= b.getNama() %> (Rp <%= String.format("%,.0f", b.getHargaDasar()) %>/<%= b.getSatuan() %>)</option>
                <% } } %>
            </select>
            <input type="number" step="0.01" name="jumlahBahan[]" class="f-input" style="height:32px;font-size:0.8rem;" placeholder="Jumlah" required>
            <button type="button" class="btn-danger-sm" onclick="hapusBaris(this)"><i class="fa-solid fa-trash-can fa-xs"></i></button>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function tambahBaris() {
            var tmpl = document.querySelector("#templateBaris .bahan-row");
            var clone = tmpl.cloneNode(true);
            clone.querySelector("select").selectedIndex = 0;
            clone.querySelector("input").value = "";
            document.getElementById("containerBahanResep").appendChild(clone);
        }
        function hapusBaris(btn) {
            var c = document.getElementById("containerBahanResep");
            if (c.getElementsByClassName("bahan-row").length > 1) {
                btn.closest(".bahan-row").remove();
            } else {
                alert("Minimal satu bahan diperlukan.");
            }
        }
        setTimeout(() => {
            ["alertOk","alertErr"].forEach(id => {
                const el = document.getElementById(id);
                if (el) { el.style.transition = "opacity 0.4s"; el.style.opacity = "0"; setTimeout(()=>el.remove(), 400); }
            });
        }, 4500);
    </script>
</body>
</html>