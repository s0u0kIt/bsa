<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>BSA | Carte</title>
	<link rel="stylesheet" href="/public/css/app.css" />
	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
		integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />
	<script src="/public/js/loading-screen.js"></script>
	<script src="/public/js/notification-popup.js"></script>
	<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
		integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
	<script src="/public/js/map.js"></script>
	<script src="/public/js/mobile-menu.js"></script>
</head>

<body class="flex flex-col items-center h-screen relative">
	<!-- NOTIFICATION POPUP -->
	<div id="notificationPopup"
		class="hidden mt-2 p-2 absolute w-96 h-fit text-sm border border-gray-200 rounded-lg justify-center">
		<p id="notificationMessage">Something to say</p>
	</div>

	<!-- HEADER BANNER FOR LOGO AND NAV -->
	<header class="w-full h-auto flex flex-col shadow-md">
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
				<a href="/app/agents" class="h-full hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Gestion
					des
					agents</a>
				<a href="#"
					class="h-full border-b-2 border-blue-400 hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Carte</a>
				<a href="/app/statistiques"
					class="h-full hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Statistiques</a>
			</div>

			<!-- BURGER BUTTON (MOBILE) -->
			<button id="menu-toggle" class="block md:hidden text-gray-700 focus:outline-none">
				<svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
				</svg>
			</button>

			<!-- LINKS COL (HIDDEN BY DEFAULT) -->
			<div id="mobile-menu"
				class="hidden md:hidden absolute top-12 right-0 w-full bg-white shadow-lg p-4 space-y-2 z-[2000]">
				<a href="/app" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Tableau de bord</a>
				<a href="/app/dossiers" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Gestion des
					dossiers</a>
				<a href="/app/agents" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Gestion des
					agents</a>
				<a href="#" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Carte</a>
				<a href="/app/statistiques" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Statistiques</a>
			</div>
		</nav>
	</header>

	<!-- MAIN CONTENT OR APP -->
	<main class="w-full h-full relative flex flex-col space-y-4">

		<!-- LOADING SCREEN -->
		<div id="loadingScreen"
			class="absolute inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-[2000]">
			<div class="flex items-center justify-center">
				<!-- Cercle animé -->
				<div class="w-16 h-16 border-4 border-t-4 border-gray-200 border-t-gray-600 rounded-full animate-spin">
				</div>
			</div>
		</div>

		<!-- TOOLBAR BUTTONS -->
		<div class="w-full px-8 flex items-center space-x-4">
			<button id="addZoneButton"
				class="px-4 py-3 bg-gray-50 hover:bg-gray-100 border border-gray-300 rounded-lg font-semibold transition w-fit"
				onclick="mapClass.enableZoneDrawing()">
				Ajouter
			</button>
			<a href="/app/zones"
				class="px-4 py-3 bg-gray-50 hover:bg-gray-100 border border-gray-300 rounded-lg font-semibold transition w-fit">
				Gestion des zones
			</a>
			<div class="flex items-center justify-center space-x-2">
				<p>|</p>
				<hr>
				<p>Légende :</p>
				<div class="w-6 h-6 bg-green-300"></div>
				<p>0 personnes</p>
				<div class="w-6 h-6 bg-yellow-500"></div>
				<p>1 à 2 personnes</p>
				<div class="w-6 h-6 bg-orange-500"></div>
				<p>2 à 4 personnes</p>
				<div class="w-6 h-6 bg-red-500"></div>
				<p>4 à 8 personnes</p>
				<div class="w-6 h-6 bg-red-950"></div>
				<p>8+ personnes</p>
			</div>
			<div id="colorContainer" class="flex space-x-2">
				<!-- Les carrés de couleur seront insérés ici par le script JavaScript -->
			</div>
		</div>

		<!-- Confirm zone creation modal -->
		<dialog id="confirmModal"
			class="relative p-6 bg-white rounded-lg shadow-lg overflow-hidden w-fit border border-gray-300 self-center">
			<!-- Close Button -->
			<button type="button" onclick="confirmModal.close()"
				class="fixed top-4 right-4 text-red-600 hover:text-red-800 p-2 rounded-full bg-white shadow-md border border-gray-300">
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="w-6 h-6">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
				</svg>
			</button>

			<!-- Modal Content -->
			<div class="modal-content">
				<h2 class="text-2xl font-semibold text-gray-900 mb-4">Confirmer la création</h2>
				<p class="text-sm text-gray-600 mb-6">Êtes-vous sûr de vouloir ajouter cette zone ?</p>
				<div class="flex justify-end space-x-3">
					<button
						class="cancel px-4 py-2 text-sm font-medium bg-gray-200 rounded-lg hover:bg-gray-300 border border-gray-300">
						Annuler
					</button>
					<button
						class="confirm px-4 py-2 text-sm font-medium bg-blue-200 rounded-lg hover:bg-blue-300 border border-gray-300">
						Confirmer
					</button>
				</div>
			</div>
		</dialog>

		<!-- Zone name and parent modal -->
		<dialog id="nameModal"
			class="relative p-6 bg-white rounded-lg shadow-lg overflow-hidden w-fit border border-gray-300 self-center">
			<!-- Close Button -->
			<button type="button" onclick="nameModal.close()"
				class="fixed top-4 right-4 text-red-600 hover:text-red-800 p-2 rounded-full bg-white shadow-md border border-gray-300">
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="w-6 h-6">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
				</svg>
			</button>

			<!-- Modal Content -->
			<div class="modal-content">
				<h2 class="text-2xl font-semibold text-gray-900 mb-4">Nom de la zone</h2>
				<p class="text-sm text-gray-600 mb-6">Donnez un nom à cette zone :</p>
				<div class="space-y-4">
					<div>
						<label for="zoneName" class="block text-sm font-medium text-gray-900 mb-1">Nom :</label>
						<input type="text" id="zoneName" placeholder="Nom de la zone"
							class="block w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required />
					</div>
					<div class="w-full">
						<label for="zoneTown" class="block text-sm font-medium text-gray-900 mb-1">Commune :</label>
						<select id="zoneTown" name="zoneTown"
							class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required>
							{if isset($towns)}
								{foreach from=$towns item=$town}
									<option value="{$town.idZone|escape}">{$town.lib|escape}</option>
								{/foreach}
							{/if}
						</select>
					</div>
					<div class="flex justify-end space-x-3">
						<button type="button"
							class="cancel px-4 py-2 text-sm font-medium bg-gray-200 rounded-lg hover:bg-gray-300 border border-gray-300">
							Annuler
						</button>
						<button type="button"
							class="confirm px-4 py-2 text-sm font-medium bg-blue-200 rounded-lg hover:bg-blue-300 border border-gray-300">
							Valider
						</button>
					</div>
				</div>
			</div>
		</dialog>

		<!-- MAP -->
		<div class="w-full h-full px-8 pb-4">
			<div id="map" class="w-full h-full rounded-lg border border-gray-300"></div>
		</div>
	</main>

	<!-- FOOTER ONLY FOR CONTENT PAGES, NOT FULLSCREEN APPS -->
	<footer></footer>
</body>

</html>