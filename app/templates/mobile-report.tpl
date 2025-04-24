<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>BSA | Relèves</title>
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
	<button class="absolute bottom-4 right-4 border border-gray-300 p-2 rounded-md bg-gray-50">
		<a href="/mobile/dossier/formulaire" class="flex items-center justify-center">
			<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor" stroke-width="2"
				viewBox="0 0 24 24" class="text-gray-700">
				<path stroke-linecap="round" stroke-linejoin="round" d="M12 5v14m7-7H5" />
			</svg>
		</a>
	</button>

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

	<main class="h-full w-full flex flex-col items-center">
		<!-- LOADING SCREEN -->
		<div id="loadingScreen" class="absolute inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-30">
			<div class="flex items-center justify-center">
				<!-- ANIMATED CIRCLE -->
				<div class="w-16 h-16 border-4 border-t-4 border-gray-200 border-t-gray-600 rounded-full animate-spin"></div>
			</div>
		</div>

		<!-- GO BACK BUTTON -->
		<div class="w-full">
			<a href="/mobile/" class="w-fit p-4 flex items-center space-x-2 cursor-pointer">
				<div class="w-4 h-4 border-l-2 border-t-2 border-gray-700 transform -rotate-45"></div>
				<span class="text-sm font-medium">Retour</span>
			</a>
		</div>

		<!-- TITLE -->
		<h2 class="text-center text-xl font-normal py-4">Liste de vos relèves d'aujourd'hui</h2>

		<!-- DATA TABLE -->
		<div class="w-full h-full overflow-y-scroll px-4 py-1">
			<table id="dataTable" class="w-full text-sm text-left rtl:text-right text-gray-500 border border-gray-300">
				<thead class="font-normal text-gray-600 uppercase bg-gray-50">
					<tr>
						<th scope="col" class="px-2 py-3">Personne</th>
						<th scope="col" class="px-2 py-3">Commentaire</th>
						<th scope="col" class="px-2 py-3">Date de relève</th>
					</tr>
				</thead>
				<tbody>
					{foreach from=$reports item=$report}
						<tr onclick="reportClass.displayData(event)" class="odd:bg-white even:bg-gray-50 border-b cursor-pointer">
							<th scope="row" class="px-2 py-4 font-medium text-gray-900 whitespace-nowrap thId">
								{$report.personne|escape}
							</th>
							<td class="px-2 py-4 tdLastName">{$report.commentaire|escape}</td>
							<td class="px-2 py-4 tdBorn"><input type="date" value="{$report.date|escape}" class="bg-transparent" disabled />
							</td>
						</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
	</main>
</body>

</html>