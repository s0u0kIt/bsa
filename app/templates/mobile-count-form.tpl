<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>BSA | Comptage</title>
	<link rel="stylesheet" href="/public/css/app.css" />
	<link rel="manifest" href="/mobile/manifest.json" />
	<script src="/public/js/loading-screen.js"></script>
	<script src="/public/js/notification-popup.js"></script>
	<script src="/public/js/mobile-menu.js"></script>
	<script src="/public/js/counter.js"></script>
</head>

<body class="h-screen flex flex-col items-center">
	<!-- NOTIFICATION POPUP -->
	<div id="notificationPopup"
		class="hidden mt-2 p-2 absolute w-96 h-fit text-sm border border-gray-200 rounded-lg mx-auto z-50">
		<p id="notificationMessage">Something to say</p>
	</div>

	<!-- QUICK ADD BUTTON -->
	<button class="fixed bottom-4 right-4 border border-gray-300 p-2 rounded-md bg-gray-50">
		<a href="/mobile/dossier/formulaire" class="flex items-center justify-center">
			<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2"
				viewBox="0 0 24 24" class="text-gray-700">
				<path stroke-linecap="round" stroke-linejoin="round" d="M12 5v14m7-7H5" />
			</svg>
		</a>
	</button>

	<main class="h-full w-full flex flex-col">
		<!-- LOADING SCREEN -->
		<div id="loadingScreen" class="absolute inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-30">
			<div class="flex items-center justify-center">
				<!-- ANIMATED CIRCLE -->
				<div class="w-16 h-16 border-4 border-t-4 border-gray-200 border-t-gray-600 rounded-full animate-spin"></div>
			</div>
		</div>

		<!-- HEADER BANNER FOR LOGO AND NAV -->
		<header class="w-full h-fit flex justify-center border-b p-2 border-gray-300 shadow-md">
			<!-- NAV -->
			<nav class="w-full h-full flex items-center justify-center space-x-4 bg-white relative">
				<!-- BURGER BUTTON (MOBILE) -->
				<button id="menu-toggle" class="text-gray-700 focus:outline-none">
					<svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
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
		</header>

		<!-- GO BACK BUTTON -->
		<div class="w-full">
			<a href="/mobile/" class="w-fit p-4 flex items-center space-x-2 cursor-pointer">
				<div class="w-4 h-4 border-l-2 border-t-2 border-gray-700 transform -rotate-45"></div>
				<span class="text-sm font-medium">Retour</span>
			</a>
		</div>

		<!-- QUICK COUNTING -->
		<form onsubmit="counterClass.addData(event)" class="h-fit w-full px-4 flex flex-col items-center justify-center">
			<label for="dataIdZone" class="block text-sm font-medium text-gray-900 mb-1">Zone :</label>
			<select type="number" id="dataIdZone" name="dataIdZone"
				class="block w-full p-3 mb-10 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required>
				<option value="" selected>Sélectionner une zone :</option>
				{if isset($zones)}
					{foreach from=$zones item=$zone}
						<option value="{$zone.idZone|escape}">{$zone.lib|escape}</option>
					{{/foreach}}
				{/if}
			</select>

			<div class="flex flex-col space-y-4">
				<button type="button" id="quick-counter-increase"
					class="border border-gray-300 p-2 rounded-md bg-gray-50 w-20 h-20 flex justify-center items-center">
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"
						class="w-full h-full text-gray-700">
						<path stroke-linecap="round" stroke-linejoin="round" d="M12 5l7 7H5l7-7z" />
					</svg>
				</button>

				<input id="quick-counter" type="number" class="w-20 border border-gray-300 p-2 rounded-md bg-gray-50 h-auto" required>

				<button type="button" id="quick-counter-decrease"
					class="border border-gray-300 p-2 rounded-md bg-gray-50 w-20 h-20 flex justify-center items-center">
					<svg xmlns="http://www.w3.org/2000/svg" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"
						class="w-full h-full text-gray-700">
						<path stroke-linecap="round" stroke-linejoin="round" d="M12 19l-7-7h14l-7 7z" />
					</svg>
				</button>
			</div>

			<button id="submitDataButton" type="submit"
				class="px-4 py-3 mt-10 bg-gray-50 hover:bg-gray-100 border border-gray-300 rounded-lg font-semibold transition w-fit">
				Envoyer
			</button>
		</form>
	</main>
</body>

</html>