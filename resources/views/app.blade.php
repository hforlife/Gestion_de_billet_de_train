<!DOCTYPE html>
<html lang="fr-FR">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SOPAFER - Gestion de billets de trains</title>
    <!-- plugins:css -->
    <link rel="stylesheet" href="/assets/vendors/iconfonts/mdi/css/materialdesignicons.min.css">
    <link rel="stylesheet" href="/assets/vendors/iconfonts/ionicons/dist/css/ionicons.css">
    <link rel="stylesheet" href="/assets/vendors/iconfonts/flag-icon-css/css/flag-icon.min.css">
    <link rel="stylesheet" href="/assets/vendors/css/vendor.bundle.base.css">
    <link rel="stylesheet" href="/assets/vendors/css/vendor.bundle.addons.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <link rel="stylesheet" href="/assets/css/shared/style.css">

    <link rel="stylesheet" href="/assets/css/demo_1/style.css">

    <link rel="shortcut icon" href="/assets/images/icon.png" />
    <style>
        * {
            box-sizing: border-box;
            font-family: 'poppins', Arial, Helvetica, sans-serif;
        }
    </style>
    <!-- Balises PWA Manifest -->
    <link rel="manifest" href="/manifest.json">
    <meta name="theme-color" content="#4b49ac">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- iOS support -->
    <link rel="apple-touch-icon" href="/icons/apple-touch-icon.png">
    <meta name="apple-mobile-web-app-status-bar" content="#4b49ac">
    <!-- Ressource link -->
    @routes
    @inertiaHead
    @laravelPWA
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>

<body>
    {{-- Contenu de mes pages --}}
    @inertia

    <!-- plugins:js -->
    <script src="/assets/vendors/js/vendor.bundle.base.js"></script>
    <script src="/assets/vendors/js/vendor.bundle.addons.js"></script>
    <script src="/assets/js/bootstrap.bundle.min.js"></script>

    <script src="/assets/js/shared/off-canvas.js"></script>
    <script src="/assets/js/shared/misc.js"></script>

    <script src="/assets/js/demo_1/dashboard.js"></script>

</body>

</html>
