<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>BSA | Statistiques</title>
	<link rel="stylesheet" href="/public/css/app.css" />
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels"></script>
	<script src="/public/js/loading-screen.js"></script>
	<script src="/public/js/stats.js"></script>
	<script src="/public/js/notification-popup.js"></script>
	<script src="/public/js/mobile-menu.js"></script>
</head>

<body class="flex flex-col items-center relative">
	<!-- NOTIFICATION POPUP -->
	<div id="notificationPopup"
		class="print:hidden hidden mt-2 p-2 absolute w-96 h-fit text-sm border border-gray-200 rounded-lg justify-center">
		<p id="notificationMessage">Something to say</p>
	</div>

	<!-- HEADER BANNER FOR LOGO AND NAV -->
	<header class="print:hidden w-full h-auto flex flex-col shadow-md">
		<div class="w-full flex justify-center border-b border-gray-300">
			<div class="w-full flex items-center justify-center">
				<a href="/">
					<img class="h-20"
						src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmbtLpeNT9LKw5v1M9yODfmXnfot4eWKlwQA&s" alt="" />
				</a>
			</div>
			<ul class="w-full flex items-center justify-center space-x-4 first:ml-4 last:mr-4">
				</li>
				<li><a href="/app/faq">FAQ</a></li>
				<li class="relative group">
					<span class="cursor-pointer">Compte</span>
					<ul
						class="z-[2000] absolute right-0 hidden w-fit bg-white border border-gray-300 rounded-lg shadow-lg group-hover:block">
						<li class="font-semibold block px-4 pt-2">{$user.lastname} {$user.firstname}</li>
						<li class="text-gray-500 block px-4 pb-2">{$user.login}</li>
						<li><a href="/deconnexion"
								class="font-semibold text-gray-500 block px-4 py-2 hover:bg-gray-100">Déconnexion</a></li>
						<li><a href="/mot-de-passe-oublie"
								class="font-semibold text-gray-500 block px-4 py-2 hover:bg-gray-100">Changer de mot de passe</a>
					</ul>
				</li>
			</ul>
		</div>

		<!-- NAV -->
		<nav class="w-full h-12 flex items-center justify-center space-x-4 bg-white shadow-md relative">
			<!-- LINKS ROW (PC) -->
			<div class="hidden h-full md:flex space-x-6">
				<a href="/app" class="h-full hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Tableau
					de
					bord</a>
				<a href="/app/dossiers" class="h-full hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Gestion des
					dossiers</a>
				<a href="/app/agents" class="h-full hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Gestion des
					agents</a>
				<a href="/app/carte" class="h-full hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Carte</a>
				<a href="#"
					class="h-full border-b-2 border-blue-400 hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Statistiques</a>
			</div>

			<!-- BURGER BUTTON (MOBILE) -->
			<button id="menu-toggle" class="block md:hidden text-gray-700 focus:outline-none">
				<svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
				</svg>
			</button>

			<!-- LINKS COL (HIDDEN BY DEFAULT) -->
			<div id="mobile-menu"
				class="hidden md:hidden absolute top-12 right-0 w-full bg-white shadow-lg p-4 space-y-2 z-20">
				<a href="/app" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Tableau de bord</a>
				<a href="/app/dossiers" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Gestion des
					dossiers</a>
				<a href="/app/agents" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Gestion des
					agents</a>
				<a href="/app/carte" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Carte</a>
				<a href="#" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Statistiques</a>
			</div>
		</nav>
	</header>

	<!-- MAIN CONTENT OR APP -->
	<main class="w-full h-fit flex flex-col items-center justify-center px-4 relative">

		<!-- LOADING SCREEN -->
		<div id="loadingScreen" class="absolute inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-[000]">
			<div class="flex items-center justify-center">
				<!-- Animated circle -->
				<div class="w-16 h-16 border-4 border-t-4 border-gray-200 border-t-gray-600 rounded-full animate-spin"></div>
			</div>
		</div>

		<h1 class="text-xl font-semibold text-gray-800 mt-4">Statistiques</h1>

		<div class="w-full max-w-5xl grid grid-cols-1 md:grid-cols-2 gap-4 my-4">

			<!-- Gender Distribution Chart -->
			<div class="p-4 bg-gray-50 shadow-lg rounded-lg break-inside-avoid">
				<h2 class="text-lg font-medium text-gray-700 mb-2">Répartition par genre</h2>
				<canvas id="genderDistributionChart"></canvas>
			</div>

			<!-- Six Months Progression Chart -->
			<div class="p-4 bg-gray-50 shadow-lg rounded-lg break-inside-avoid">
				<h2 class="text-lg font-medium text-gray-700 mb-2">Évolution sur les 6 derniers mois</h2>
				<canvas id="sixMonthsProgressionChart" class="max-h-96"></canvas>
			</div>

			<!-- Typology Distribution Chart -->
			<div class="p-4 bg-gray-50 shadow-lg rounded-lg break-inside-avoid">
				<h2 class="text-lg font-medium text-gray-700 mb-2">Répartition par typologie</h2>
				<canvas id="typologyDistributionChart"></canvas>
			</div>

			<!-- Population Distribution Chart -->
			<div class="p-4 bg-gray-50 shadow-lg rounded-lg break-inside-avoid">
				<h2 class="text-lg font-medium text-gray-700 mb-2">Répartition de la population par zone</h2>
				<label for="zoneType">Sélectionnez un type de zone :</label>
				<select id="zoneType"
					class="block w-full p-3 mb-10 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50">
					<option value="all">Tous les types</option>
					<option value="archipel">Archipel</option>
					<option value="ile">Île</option>
					<option value="commune">Commune</option>
					<option value="zone">Zone</option>
				</select>
				<canvas id="populationDistributionChart" class="max-h-96"></canvas>
			</div>
		</div>
	</main>

	<!-- FOOTER ONLY FOR CONTENT PAGES, NOT FULLSCREEN APPS -->
	<footer class="print:hidden w-full text-gray-600 py-4 border-t border-gray-200">
		<div class="container mx-auto text-center">
			<p class="text-gray-600">&copy; 2025 DSFE (Direction des Solidarités de la Famille et de l'Égalité) - BSA
				(Bureau
				en charge des
				Sans-Abris) . Tous droits réservés.</p>
			<p class="text-gray-600">Site créé en 2025.</p>
			<p>
				<a href="/app/policies/legal-mentions" class="text-blue-400 hover:text-blue-600">Mentions
					légales</a> |
				<a href="/app/policies/general-conditions" class="text-blue-400 hover:text-blue-600">Conditions
					Générales
					d'utilisation</a> |
				<a href="/app/policies/privacy-policy" class="text-blue-400 hover:text-blue-600">Politique de
					Confidentialité</a>
			</p>
		</div>
	</footer>
</body>

</html>