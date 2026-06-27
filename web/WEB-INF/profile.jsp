<%@page import="model.Mahasiswa" %>
<%@page import="model.MealPlanner" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<%
    Mahasiswa mhs = (Mahasiswa) session.getAttribute("mahasiswa");
    MealPlanner planner = (MealPlanner) session.getAttribute("planner");
    if (mhs == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    String successMsg = (String) session.getAttribute("successMessage");
    String errorMsg = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<html lang="id">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil – Smart Meal Planner</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: #f0fdf4; color: #1e293b; min-height: 100vh; }
        h1,h2,h3,h4,h5,h6,.navbar-brand { font-family: 'Outfit', sans-serif; }

        /* NAVBAR */
        .navbar-premium {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid #e2e8f0;
        }
        .navbar-brand { font-size: 1.3rem; font-weight: 800; letter-spacing: -0.5px; }
        .nav-pill {
            border-radius: 10px; font-weight: 600; font-size: 0.83rem;
            padding: 7px 15px; transition: all 0.2s;
            display: inline-flex; align-items: center; gap: 6px;
        }
        .nav-pill-outline { border: 1.5px solid #e2e8f0; color: #475569; background: transparent; }
        .nav-pill-outline:hover { background: #f1f5f9; color: #1e293b; }
        .nav-pill-green { background: #ecfdf5; color: #0f766e; border: 1.5px solid #a7f3d0; }
        .nav-pill-danger { background: #fef2f2; color: #dc2626; border: 1.5px solid #fecaca; }
        .nav-pill-danger:hover { background: #fee2e2; }

        /* ALERTS */
        .alert-custom {
            border-radius: 12px; padding: 12px 16px;
            display: flex; align-items: center; gap: 10px;
            font-size: 0.85rem; font-weight: 500; margin-bottom: 1.25rem;
        }
        .alert-success-c { background: #f0fdf4; border: 1px solid #86efac; color: #166534; }
        .alert-danger-c { background: #fef2f2; border: 1px solid #fca5a5; color: #991b1b; }

        /* HERO */
        .profile-hero {
            background: linear-gradient(135deg, #064e3b, #0f766e, #0d9488);
            padding: 3rem 0 5rem;
            position: relative; overflow: hidden;
        }
        .profile-hero::before {
            content: ''; position: absolute; inset: 0;
            background: radial-gradient(ellipse at 80% 30%, rgba(52,211,153,0.2) 0%, transparent 55%);
        }
        .hero-inner { position: relative; z-index: 1; }
        .avatar-big {
            width: 72px; height: 72px; border-radius: 18px;
            background: rgba(255,255,255,0.15);
            border: 2px solid rgba(255,255,255,0.3);
            display: flex; align-items: center; justify-content: center;
            font-family: 'Outfit', sans-serif;
            font-size: 1.8rem; font-weight: 800; color: white;
            margin-bottom: 1rem;
        }
        .hero-name { font-size: 1.6rem; font-weight: 800; color: white; letter-spacing: -0.5px; margin-bottom: 0.2rem; }
        .hero-meta { font-size: 0.85rem; color: rgba(255,255,255,0.65); }

        /* CONTENT */
        .content-wrap { margin-top: -4rem; padding-bottom: 3rem; }

        /* CARDS */
        .card-premium {
            background: white; border-radius: 16px;
            border: 1px solid rgba(226,232,240,0.8);
            box-shadow: 0 4px 20px rgba(15,23,42,0.06);
            padding: 1.5rem; margin-bottom: 1.25rem;
        }

        .card-title-sm {
            font-size: 0.7rem; font-weight: 700; text-transform: uppercase;
            color: #94a3b8; letter-spacing: 0.6px; margin-bottom: 1rem;
        }

        /* INFO ROWS */
        .info-row {
            display: flex; align-items: center;
            justify-content: space-between;
            padding: 0.65rem 0; border-bottom: 1px solid #f8fafc;
        }
        .info-row:last-child { border-bottom: none; }
        .info-key { font-size: 0.82rem; color: #64748b; }
        .info-val { font-size: 0.88rem; font-weight: 600; color: #1e293b; }

        /* BUDGET DISPLAY */
        .budget-now {
            background: linear-gradient(135deg, #ecfdf5, #d1fae5);
            border: 1px solid #a7f3d0;
            border-radius: 12px; padding: 1rem 1.25rem;
            display: flex; align-items: center; gap: 12px;
            margin-bottom: 1.25rem;
        }
        .budget-now-icon {
            width: 42px; height: 42px; border-radius: 10px;
            background: linear-gradient(135deg, #0f766e, #0d9488);
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem; color: white; flex-shrink: 0;
        }
        .budget-lbl { font-size: 0.7rem; color: #059669; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
        .budget-val-big { font-family: 'Outfit', sans-serif; font-size: 1.45rem; font-weight: 800; color: #064e3b; letter-spacing: -0.5px; }

        /* FORM */
        .f-label-sm {
            font-size: 0.72rem; font-weight: 700; text-transform: uppercase;
            color: #64748b; letter-spacing: 0.5px; margin-bottom: 0.3rem; display: block;
        }
        .f-desc { font-size: 0.75rem; color: #94a3b8; margin-bottom: 0.4rem; }
        .input-group-budget { display: flex; }
        .budget-prefix {
            height: 42px; padding: 0 12px;
            background: #f1f5f9; border: 1.5px solid #e2e8f0;
            border-right: none; border-radius: 10px 0 0 10px;
            font-size: 0.88rem; font-weight: 600; color: #475569;
            display: flex; align-items: center; flex-shrink: 0;
        }
        .budget-input {
            flex: 1; height: 42px; padding: 0 12px;
            border: 1.5px solid #e2e8f0; border-radius: 0 10px 10px 0;
            font-size: 0.95rem; color: #1e293b;
            background: white; outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .budget-input:focus { border-color: #0f766e; box-shadow: 0 0 0 3px rgba(15,118,110,0.1); }

        .btn-save {
            height: 42px; background: linear-gradient(135deg, #0f766e, #0d9488);
            color: white; border: none; border-radius: 10px;
            font-family: 'Outfit', sans-serif; font-size: 0.9rem; font-weight: 700;
            padding: 0 22px; cursor: pointer; transition: all 0.2s;
            box-shadow: 0 4px 12px rgba(15,118,110,0.25);
            display: inline-flex; align-items: center; gap: 7px;
        }
        .btn-save:hover { box-shadow: 0 6px 20px rgba(15,118,110,0.35); transform: translateY(-1px); }

        /* TIPS */
        .tip-row {
            display: flex; gap: 10px; align-items: flex-start;
            padding: 0.6rem 0; border-bottom: 1px solid #f8fafc;
        }
        .tip-row:last-child { border-bottom: none; }
        .tip-num {
            width: 22px; height: 22px; border-radius: 6px; flex-shrink: 0;
            background: linear-gradient(135deg, #0f766e, #0d9488);
            color: white; font-size: 0.68rem; font-weight: 700;
            display: flex; align-items: center; justify-content: center;
        }
        .tip-text { font-size: 0.83rem; color: #475569; line-height: 1.55; }
    </style>
</head>
<body>

    <nav class="navbar navbar-premium navbar-expand-lg shadow-sm sticky-top py-3">
        <div class="container">
            <a class="navbar-brand text-success d-flex align-items-center gap-2" href="dashboard.jsp">
                <i class="fa-solid fa-utensils"></i> Smart Meal Planner
            </a>
            <div class="ms-auto d-flex gap-2">
                <a href="dashboard.jsp" class="btn nav-pill nav-pill-outline">
                    <i class="fa-solid fa-house"></i> Dashboard
                </a>
                <a href="MealPlannerServlet?action=rekomendasiBahanPage" class="btn nav-pill nav-pill-green">
                    <i class="fa-solid fa-lightbulb"></i> Rekomendasi
                </a>
                <a href="MealPlannerServlet?action=logout" class="btn nav-pill nav-pill-danger">
                    <i class="fa-solid fa-right-from-bracket"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <!-- HERO -->
    <div class="profile-hero">
        <div class="container hero-inner">
            <div class="avatar-big"><%= mhs.getNama().substring(0,1).toUpperCase() %></div>
            <div class="hero-name"><%= mhs.getNama() %></div>
            <div class="hero-meta">NIM <%= mhs.getNim() %> &nbsp;&middot;&nbsp; <%= mhs.getEmail() %></div>
        </div>
    </div>

    <div class="container content-wrap">

        <% if (successMsg != null) { %>
        <div class="alert-custom alert-success-c" id="alertOk">
            <i class="fa-solid fa-circle-check"></i> <%= successMsg %>
        </div>
        <% } %>
        <% if (errorMsg != null) { %>
        <div class="alert-custom alert-danger-c" id="alertErr">
            <i class="fa-solid fa-triangle-exclamation"></i> <%= errorMsg %>
        </div>
        <% } %>

        <div class="row g-4">
            <div class="col-md-5">
                <!-- Info Akun -->
                <div class="card-premium">
                    <div class="card-title-sm"><i class="fa-solid fa-id-card me-1"></i> Informasi Akun</div>
                    <div class="info-row">
                        <span class="info-key">Nama Lengkap</span>
                        <span class="info-val"><%= mhs.getNama() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-key">NIM</span>
                        <span class="info-val"><%= mhs.getNim() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-key">Email</span>
                        <span class="info-val"><%= mhs.getEmail() %></span>
                    </div>
                </div>

                <!-- Tips -->
                <div class="card-premium">
                    <div class="card-title-sm"><i class="fa-solid fa-star me-1"></i> Tips Hemat Anggaran</div>
                    <div class="tip-row">
                        <div class="tip-num">1</div>
                        <div class="tip-text">Masak sendiri secara rutin bisa menghemat hingga 60% dibanding beli makan di luar setiap hari.</div>
                    </div>
                    <div class="tip-row">
                        <div class="tip-num">2</div>
                        <div class="tip-text">Gunakan fitur Rekomendasi untuk temukan menu dari bahan yang sudah ada di dapur Anda.</div>
                    </div>
                    <div class="tip-row">
                        <div class="tip-num">3</div>
                        <div class="tip-text">Pantau status anggaran di dashboard setiap hari agar tidak melebihi batas yang ditetapkan.</div>
                    </div>
                    <div class="tip-row">
                        <div class="tip-num">4</div>
                        <div class="tip-text">Anggaran mingguan ideal untuk mahasiswa berkisar Rp 300.000 – Rp 700.000.</div>
                    </div>
                </div>
            </div>

            <div class="col-md-7">
                <!-- Budget Card -->
                <div class="card-premium">
                    <div class="card-title-sm"><i class="fa-solid fa-wallet me-1"></i> Kelola Anggaran Makan</div>

                    <div class="budget-now">
                        <div class="budget-now-icon"><i class="fa-solid fa-coins"></i></div>
                        <div>
                            <div class="budget-lbl">Anggaran Saat Ini</div>
                            <div class="budget-val-big" id="previewBudget">Rp <%= String.format("%,.0f", mhs.getBudget()) %></div>
                        </div>
                    </div>

                    <form action="MealPlannerServlet" method="POST" id="budgetForm">
                        <input type="hidden" name="action" value="updateBudget">
                        <div style="margin-bottom: 0.75rem;">
                            <label class="f-label-sm">Nominal Anggaran Baru</label>
                            <div class="f-desc">Perubahan akan langsung berlaku setelah disimpan</div>
                            <div class="input-group-budget">
                                <span class="budget-prefix">Rp</span>
                                <input type="number" name="budgetBaru" id="budgetInput" class="budget-input"
                                       value="<%= (int)mhs.getBudget() %>"
                                       placeholder="Masukkan nominal baru" required min="1"
                                       oninput="previewBudget(this.value)">
                            </div>
                        </div>
                        <button type="submit" class="btn-save" id="saveBtn">
                            <i class="fa-solid fa-floppy-disk"></i> Simpan Anggaran
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function previewBudget(val) {
            const num = parseInt(val);
            const el = document.getElementById("previewBudget");
            if (!isNaN(num) && num > 0) {
                el.textContent = "Rp " + num.toLocaleString("id-ID");
            } else {
                el.textContent = "Rp –";
            }
        }
        document.getElementById("budgetForm").addEventListener("submit", function() {
            const btn = document.getElementById("saveBtn");
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Menyimpan...';
            btn.disabled = true;
        });
        setTimeout(() => {
            ["alertOk","alertErr"].forEach(id => {
                const el = document.getElementById(id);
                if (el) { el.style.transition = "opacity 0.4s"; el.style.opacity = "0"; setTimeout(()=>el.remove(), 400); }
            });
        }, 4500);
    </script>
</body>
</html>
