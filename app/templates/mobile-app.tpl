<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>BSA | App</title>
	<link rel="stylesheet" href="/public/css/app.css" />
	<link rel="manifest" href="/mobile/manifest.json" />
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
	<script src="/public/js/mobile-case.js"></script>
	<script src="/public/js/loading-screen.js"></script>
	<script src="/public/js/notification-popup.js"></script>
	<script src="/public/js/mobile-menu.js"></script>
	<script src="/public/js/counter.js"></script>
</head>

<body class="flex flex-col items-center">
	<!-- NOTIFICATION POPUP -->
	<div id="notificationPopup"
		class="hidden mt-2 p-2 absolute w-96 h-fit text-sm border border-gray-200 rounded-lg mx-auto z-50">
		<p id="notificationMessage">Something to say</p>
	</div>

	<!-- HEADER BANNER FOR LOGO AND NAV -->
	<header class="w-full flex justify-center items-center border-b p-2 border-gray-300 shadow-md">
		<!-- NAV -->
		<nav class="w-full h-full flex items-center justify-center space-x-4 bg-white relative">
			<!-- BURGER BUTTON (MOBILE) -->
			<button id="menu-toggle" class="text-gray-700 focus:outline-none">
				<svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
					stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
				</svg>
			</button>
			<!-- LINKS COL -->
			<div id="mobile-menu" class="hidden absolute top-12 right-0 w-full bg-white shadow-lg p-4 space-y-2 z-20">
				<a href="/mobile" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Accueil</a>
				<a href="/mobile/dossiers" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Dossiers</a>
				<a href="/mobile/releves" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Relève</a>
				<a href="/mobile/comptage" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Comptage</a>
			</div>
		</nav>

		<!-- QUICK COUNTING -->
		<div class="top-14 right-4 flex flex-row items-center space-x-2 z-50">
			<button id="quick-counter-increase" class="border w-fit h-fit border-gray-300 p-2 rounded-md bg-gray-50">
				<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="none" stroke="currentColor"
					stroke-width="2" viewBox="0 0 24 24" class="text-gray-700">
					<path stroke-linecap="round" stroke-linejoin="round" d="M12 5l7 7H5l7-7z" />
				</svg>
			</button>
			<input id="quick-counter" type="number" class="w-11 h-10 border border-gray-300 p-2 rounded-md bg-gray-50">
			<button id="quick-counter-decrease" class="border w-fit h-fit border-gray-300 p-2 rounded-md bg-gray-50">
				<svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" fill="none" stroke="currentColor"
					stroke-width="2" viewBox="0 0 24 24" class="text-gray-700">
					<path stroke-linecap="round" stroke-linejoin="round" d="M12 19l-7-7h14l-7 7z" />
				</svg>
			</button>
		</div>
	</header>

	<main class="relative w-full p-4">
		<!-- LOADING SCREEN -->
		<div id="loadingScreen"
			class="absolute inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-30">
			<div class="flex items-center justify-center">
				<!-- ANIMATED CIRCLE -->
				<div class="w-16 h-16 border-4 border-t-4 border-gray-200 border-t-gray-600 rounded-full animate-spin">
				</div>
			</div>
		</div>

		<!-- APPS -->
		<div class="w-full h-[50vh] md:h-[30vh] px-8 flex flex-col md:flex-row items-stretch gap-6 z-10">
			<a href="/mobile/dossiers"
				class="flex-1 px-8 py-5 flex items-center justify-center bg-gray-50 hover:bg-gray-100 border border-gray-300 rounded-xl font-semibold transition text-xl h-full space-x-4">
				<svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-gray-700 flex-shrink-0" fill="none"
					viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
						d="M3 7v10c0 1.1.9 2 2 2h14a2 2 0 002-2V7M7 7V5a2 2 0 012-2h6a2 2 0 012 2v2m-9 4h4m-4 4h4" />
				</svg>
				<span>Dossiers</span>
			</a>
			<a href="/mobile/dossier/formulaire"
				class="flex-1 px-8 py-5 flex items-center justify-center bg-gray-50 hover:bg-gray-100 border border-gray-300 rounded-xl font-semibold transition text-xl h-full space-x-4">
				<svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-gray-700 flex-shrink-0" fill="none"
					viewBox="0 0 24 24" stroke="currentColor">
					<circle cx="12" cy="6" r="4" stroke="currentColor" stroke-width="2" fill="none" />
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h8v6H8z" />
				</svg>
				<span>Nouveau Dossier</span>
			</a>
			<a href=" /mobile/releves"
				class="flex-1 px-8 py-5 flex items-center justify-center bg-gray-50 hover:bg-gray-100 border border-gray-300 rounded-xl font-semibold transition text-xl h-full space-x-4">
				<svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-gray-700 flex-shrink-0" fill="none"
					viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 6h18M3 12h18M3 18h18" />
				</svg>
				<span>Relèves</span>
			</a>
			<a href="/mobile/comptage"
				class="flex-1 px-8 py-5 flex items-center justify-center bg-gray-50 hover:bg-gray-100 border border-gray-300 rounded-xl font-semibold transition text-xl h-full space-x-4">
				<svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-gray-700 flex-shrink-0" fill="none"
					viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
						d="M12 2a4 4 0 00-4 4v2a4 4 0 00-4 4v6a4 4 0 004 4h8a4 4 0 004-4v-6a4 4 0 00-4-4V6a4 4 0 00-4-4zM8 12v6h8v-6H8z" />
				</svg>
				<span>Comptage</span>
			</a>
		</div>
	</main>
</body>

</html>