<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>BSA | Tableau de bord</title>
	<link rel="stylesheet" href="/public/css/app.css" />
	<script src="/public/js/loading-screen.js"></script>
	<script src="/public/js/notification-popup.js"></script>
	<script src="/public/js/mobile-menu.js"></script>
</head>

<body class="flex flex-col items-center h-screen relative">
	<!-- NOTIFICATION POPUP -->
	<div id="notificationPopup"
		class="hidden mt-2 p-2 absolute w-96 h-fit text-sm border border-gray-200 rounded-lg justify-center">
		<p id="notificationMessage">Something to say</p>
	</div>

	<!-- HEADER BANNER FOR LOGO AND NAV -->
	<header class="w-screen h-auto flex flex-col shadow-md">
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
				<a href="#"
					class="h-full border-b-2 border-blue-400 hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Tableau
					de
					bord</a>
				<a href="/app/dossiers"
					class="h-full hover:border-b-2 border-transparent hover:border-blue-400 px-4 py-2 transition">Gestion
					des
					dossiers</a>
				<a href="/app/agents"
					class="h-full hover:border-b-2 border-transparent hover:border-blue-400 px-4 py-2 transition">Gestion
					des
					agents</a>
				<a href="/app/carte"
					class="h-full hover:border-b-2 border-transparent hover:border-blue-400 px-4 py-2 transition">Carte</a>
				<a href="/app/statistiques"
					class="h-full hover:border-b-2 border-transparent hover:border-blue-400 px-4 py-2 transition">Statistiques</a>
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
				<a href="#" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Tableau de bord</a>
				<a href="/app/dossiers" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Gestion des
					dossiers</a>
				<a href="/app/agents" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Gestion des
					agents</a>
				<a href="/app/carte" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Carte</a>
				<a href="/app/statistiques" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Statistiques</a>
			</div>
		</nav>
	</header>

	<!-- MAIN CONTENT OR APP -->
	<main class="w-full h-full relative flex flex-col space-y-4">

		<!-- LOADING SCREEN -->
		<div id="loadingScreen" class="absolute inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-30">
			<div class="flex items-center justify-center">
				<!-- ANIMATED CIRCLE -->
				<div class="w-16 h-16 border-4 border-t-4 border-gray-200 border-t-gray-600 rounded-full animate-spin">
				</div>
			</div>
		</div>

		<!-- APPS -->
		<div class="w-full h-[50vh] md:h-[30vh] px-8 flex flex-col md:flex-row items-stretch gap-6 z-10">
			<a href="/app/dossiers"
				class="flex-1 px-8 py-5 flex items-center justify-center bg-blue-500 hover:bg-blue-600 border border-gray-300 rounded-xl font-semibold transition text-xl h-full space-x-4">
				<svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-gray-700 flex-shrink-0" fill="none"
					viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
						d="M3 7v10c0 1.1.9 2 2 2h14a2 2 0 002-2V7M7 7V5a2 2 0 012-2h6a2 2 0 012 2v2m-9 4h4m-4 4h4" />
				</svg>
				<span>Gestion des dossiers</span>
			</a>

			<a href="/app/agents"
				class="flex-1 px-8 py-5 flex flex-col items-center justify-center bg-blue-200 hover:bg-blue-300 border border-gray-300 rounded-xl font-semibold transition text-xl h-full">
				<div class="flex space-x-4">
					<svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-gray-700 flex-shrink-0" fill="none"
						viewBox="0 0 24 24" stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
							d="M5.121 17.804A4 4 0 018 16h8a4 4 0 012.879 1.804M12 14a4 4 0 100-8 4 4 0 000 8z" />
					</svg>
					<span>Gestion des agents</span>
				</div>
				<span class="text-base text-gray-600">(Réservé aux administrateurs)</span>
			</a>
			<a href="/app/carte"
				class="flex-1 px-8 py-5 flex items-center justify-center bg-green-300 hover:bg-green-400 border border-gray-300 rounded-xl font-semibold transition text-xl h-full space-x-4">
				<svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-gray-700 flex-shrink-0" fill="none"
					viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
						d="M9 20l-5-2.5V5l5 2.5L15 5l5 2.5v10l-5-2.5L9 20z" />
					<circle cx="12" cy="10" r="2" stroke="currentColor" stroke-width="2" fill="none" />
				</svg>
				<span>Carte</span>
			</a>
			<a href="/app/statistiques"
				class="flex-1 px-8 py-5 flex items-center justify-center bg-orange-300 hover:bg-orange-400 border border-gray-300 rounded-xl font-semibold transition text-xl h-full space-x-4">
				<svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-gray-700 flex-shrink-0" fill="none"
					viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
						d="M3 3v18h18M7 16h4m-4-4h8m-8-4h4m-4-4h8" />
				</svg>
				<span>Statistiques</span>
			</a>
		</div>
	</main>

	<!-- FOOTER ONLY FOR CONTENT PAGES, NOT FULLSCREEN APPS -->
	<footer class="w-full text-gray-600 py-4 border-t border-gray-200">
		<div class="container mx-auto text-center">
			<p class="text-gray-600">&copy; 2025 DSFE (Direction des Solidarités de la Famille et de l'Égalité) - BSA
				(Bureau
				en charge des
				Sans-Abris) . Tous droits réservés.</p>
			<p class="text-gray-600">Site créé en 2025.</p>
			<p>
				<a href="/app/policies/legal-mentions" class="text-blue-400 hover:text-blue-600">Mentions
					légales</a> |
				<a href="/app/policies/general-conditions" class="text-blue-400 hover:text-blue-600">Conditions Générales
					d'utilisation</a> |
				<a href="/app/policies/privacy-policy" class="text-blue-400 hover:text-blue-600">Politique de
					Confidentialité</a>
			</p>
		</div>
	</footer>
</body>

</html>