<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="id">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Smart Meal Planner – Masuk</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link
            href="https://fonts.googleapis.com/css2?family=Outfit:wght@400;600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap"
            rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            *,
            *::before,
            *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Plus Jakarta Sans', sans-serif;
                background: #0f172a;
                min-height: 100vh;
                display: flex;
                align-items: stretch;
            }

            h1,
            h2,
            h3,
            h4,
            h5,
            h6 {
                font-family: 'Outfit', sans-serif;
            }

            /* SPLIT LAYOUT */
            .login-split {
                display: flex;
                width: 100%;
                min-height: 100vh;
            }

            /* LEFT PANEL */
            .panel-left {
                flex: 1;
                background: linear-gradient(145deg, #064e3b 0%, #0f766e 55%, #0d9488 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 3rem 2.5rem;
                position: relative;
                overflow: hidden;
            }

            .panel-left::before {
                content: '';
                position: absolute;
                inset: 0;
                background:
                    radial-gradient(ellipse at 20% 20%, rgba(52, 211, 153, 0.25) 0%, transparent 50%),
                    radial-gradient(ellipse at 80% 80%, rgba(6, 78, 59, 0.4) 0%, transparent 60%);
            }

            .blob {
                position: absolute;
                border-radius: 50%;
                filter: blur(60px);
                opacity: 0.2;
            }

            .blob-1 {
                width: 300px;
                height: 300px;
                background: #34d399;
                top: -80px;
                right: -60px;
                animation: blobFloat 7s ease-in-out infinite;
            }

            .blob-2 {
                width: 200px;
                height: 200px;
                background: #6ee7b7;
                bottom: -40px;
                left: -30px;
                animation: blobFloat 9s ease-in-out infinite reverse;
            }

            .blob-3 {
                width: 150px;
                height: 150px;
                background: #a7f3d0;
                top: 50%;
                left: 10%;
                animation: blobFloat 11s ease-in-out infinite 2s;
            }

            @keyframes blobFloat {

                0%,
                100% {
                    transform: translateY(0) scale(1);
                }

                50% {
                    transform: translateY(-20px) scale(1.05);
                }
            }

            .left-content {
                position: relative;
                z-index: 1;
                max-width: 400px;
            }

            .brand-logo {
                display: inline-flex;
                align-items: center;
                gap: 10px;
                margin-bottom: 2.5rem;
            }

            .brand-icon {
                width: 46px;
                height: 46px;
                background: rgba(255, 255, 255, 0.15);
                border: 1.5px solid rgba(255, 255, 255, 0.3);
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.2rem;
                color: white;
            }

            .brand-name {
                font-family: 'Outfit', sans-serif;
                font-size: 1.1rem;
                font-weight: 700;
                color: white;
                letter-spacing: -0.3px;
            }

            .hero-headline {
                font-size: 2.6rem;
                font-weight: 800;
                color: white;
                letter-spacing: -1px;
                line-height: 1.15;
                margin-bottom: 1rem;
            }

            .hero-sub {
                color: rgba(255, 255, 255, 0.7);
                font-size: 0.95rem;
                line-height: 1.7;
                margin-bottom: 2rem;
            }

            .feature-list {
                list-style: none;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            .feature-item {
                display: flex;
                align-items: center;
                gap: 10px;
                background: rgba(255, 255, 255, 0.08);
                border: 1px solid rgba(255, 255, 255, 0.15);
                border-radius: 10px;
                padding: 10px 14px;
                font-size: 0.85rem;
                color: rgba(255, 255, 255, 0.85);
                font-weight: 500;
            }

            .feature-item i {
                color: #6ee7b7;
                width: 16px;
            }

            /* RIGHT PANEL */
            .panel-right {
                width: 460px;
                background: #f8fafc;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 2.5rem 2rem;
            }

            .login-box {
                width: 100%;
                max-width: 380px;
            }

            .login-title {
                font-family: 'Outfit', sans-serif;
                font-size: 1.7rem;
                font-weight: 800;
                color: #1e293b;
                letter-spacing: -0.5px;
                margin-bottom: 0.3rem;
            }

            .login-sub {
                font-size: 0.87rem;
                color: #94a3b8;
                margin-bottom: 2rem;
            }

            .error-alert {
                background: #fef2f2;
                border: 1px solid #fecaca;
                border-radius: 10px;
                padding: 10px 14px;
                font-size: 0.83rem;
                color: #dc2626;
                font-weight: 500;
                display: flex;
                align-items: center;
                gap: 8px;
                margin-bottom: 1.25rem;
            }

            .form-group {
                margin-bottom: 1rem;
            }

            .form-group label {
                display: block;
                font-size: 0.78rem;
                font-weight: 600;
                color: #475569;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 0.4rem;
            }

            .input-wrap {
                position: relative;
            }

            .input-icon {
                position: absolute;
                left: 13px;
                top: 50%;
                transform: translateY(-50%);
                color: #94a3b8;
                font-size: 0.85rem;
                pointer-events: none;
            }

            .form-input {
                width: 100%;
                height: 46px;
                padding: 0 14px 0 38px;
                border: 1.5px solid #e2e8f0;
                border-radius: 10px;
                font-size: 0.9rem;
                color: #1e293b;
                background: white;
                outline: none;
                transition: border-color 0.2s, box-shadow 0.2s;
                font-family: 'Plus Jakarta Sans', sans-serif;
            }

            .form-input:focus {
                border-color: #0f766e;
                box-shadow: 0 0 0 3px rgba(15, 118, 110, 0.12);
            }

            .form-input::placeholder {
                color: #cbd5e1;
            }

            .btn-login {
                width: 100%;
                height: 46px;
                background: linear-gradient(135deg, #0f766e, #0d9488);
                color: white;
                border: none;
                border-radius: 10px;
                font-family: 'Outfit', sans-serif;
                font-size: 0.95rem;
                font-weight: 700;
                cursor: pointer;
                transition: all 0.2s;
                box-shadow: 0 4px 14px rgba(15, 118, 110, 0.3);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 8px;
                margin-top: 1.5rem;
            }

            .btn-login:hover {
                box-shadow: 0 6px 20px rgba(15, 118, 110, 0.4);
                transform: translateY(-1px);
            }

            .footer-note {
                text-align: center;
                margin-top: 1.75rem;
                font-size: 0.78rem;
                color: #94a3b8;
            }

            @media (max-width: 768px) {
                .panel-left {
                    display: none;
                }

                .panel-right {
                    width: 100%;
                }
            }
        </style>
    </head>

    <body>
        <div class="login-split">

            <!-- LEFT PANEL -->
            <div class="panel-left">
                <div class="blob blob-1"></div>
                <div class="blob blob-2"></div>
                <div class="blob blob-3"></div>

                <div class="left-content">
                    <div class="brand-logo">
                        <div class="brand-icon"><i class="fa-solid fa-utensils"></i></div>
                        <span class="brand-name">Smart Meal Planner</span>
                    </div>

                    <h1 class="hero-headline">Kelola Makan<br>Sehat & Hemat</h1>
                    <p class="hero-sub">Rencanakan menu harian, pantau anggaran belanja, dan dapatkan rekomendasi resep
                        cerdas berbasis AI.</p>

                    <ul class="feature-list">
                        <li class="feature-item">
                            <i class="fa-solid fa-calendar-check"></i>
                            Jadwal makan mingguan otomatis
                        </li>
                        <li class="feature-item">
                            <i class="fa-solid fa-piggy-bank"></i>
                            Pantau anggaran makan secara real-time
                        </li>
                        <li class="feature-item">
                            <i class="fa-solid fa-lightbulb"></i>
                            Rekomendasi resep dari bahan di kulkas
                        </li>
                        <li class="feature-item">
                            <i class="fa-solid fa-globe"></i>
                            Integrasi dengan Spoonacular API
                        </li>
                    </ul>
                </div>
            </div>

            <!-- RIGHT PANEL -->
            <div class="panel-right">
                <div class="login-box">
                    <div class="login-title">Selamat datang</div>
                    <div class="login-sub">Masuk untuk mengelola rencana makan Anda</div>

                    <% if (request.getParameter("error") !=null) { %>
                        <div class="error-alert">
                            <i class="fa-solid fa-circle-exclamation"></i>
                            Email atau password salah. Silakan coba lagi.
                        </div>
                        <% } %>

                            <form action="MealPlannerServlet" method="POST">
                                <input type="hidden" name="action" value="login">

                                <div class="form-group">
                                    <label for="emailInput">Email</label>
                                    <div class="input-wrap">
                                        <i class="fa-solid fa-envelope input-icon"></i>
                                        <input type="text" name="email" id="emailInput" class="form-input"
                                            placeholder="nama@email.com" required autocomplete="email">
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label for="passInput">Password</label>
                                    <div class="input-wrap">
                                        <i class="fa-solid fa-lock input-icon"></i>
                                        <input type="password" name="password" id="passInput" class="form-input"
                                            placeholder="••••••••" required autocomplete="current-password">
                                    </div>
                                </div>

                                <button type="submit" class="btn-login">
                                    <i class="fa-solid fa-right-to-bracket"></i> Masuk ke Dashboard
                                </button>
                            </form>

                            <div class="footer-note">&copy; Smart Meal Planner</div>
                </div>
            </div>

        </div>
    </body>

    </html>