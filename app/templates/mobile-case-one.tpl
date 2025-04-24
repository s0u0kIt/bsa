<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>BSA | Afficher un dossier</title>
	<link rel="stylesheet" href="/public/css/app.css" />
	<link rel="manifest" href="/mobile/manifest.json" />
	<script src="/public/js/mobile-case.js"></script>
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

	<!-- HEADER BANNER FOR LOGO AND NAV -->
	<header class="w-full flex justify-center border-b p-2 border-gray-300 shadow-md">
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
		<div class="top-14 right-4 flex flex-row items-center space-x-2 z-20">
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

	<main class="relative w-full h-full">
		<!-- LOADING SCREEN -->
		<div id="loadingScreen" class="absolute inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-30">
			<div class="flex items-center justify-center">
				<!-- ANIMATED CIRCLE -->
				<div class="w-16 h-16 border-4 border-t-4 border-gray-200 border-t-gray-600 rounded-full animate-spin"></div>
			</div>
		</div>

		<!-- GO BACK BUTTON -->
		<div class="w-full">
			<a href="/mobile/dossiers" class="w-fit p-4 flex items-center space-x-2 cursor-pointer">
				<div class="w-4 h-4 border-l-2 border-t-2 border-gray-700 transform -rotate-45"></div>
				<span class="text-sm font-medium">Retour</span>
			</a>
		</div>

		<!-- DATA FORM -->
		<div id="dataModal" class="flex flex-col bg-white p-4 w-full">
			<h2 id="dataModalTitle" class="text-2xl font-semibold text-gray-900 mb-4">
				Fiche d'information
			</h2>
			<p id="dataModalDescription" class="text-sm text-gray-600 mb-6">
				Ajoutez un commentaire sur cette personne.
			</p>
			{if isset($case)}
				<form id="dataForm" class="space-y-4 h-full" onsubmit="caseClass.addReport(event)">
					<div>
						<input id="dataId" name="dataId" value="{$case.idPersonne|escape}" hidden required disabled />
					</div>
					<div>
						<label for="dataLastName" class="block text-sm font-medium text-gray-900 mb-1">Nom :</label>
						<input type="text" id="dataLastName" name="lastname" placeholder="Nom" value="{$case.nom|escape}"
							class="block w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required
							disabled />
					</div>
					<div>
						<label for="dataFirstName" class="block text-sm font-medium text-gray-900 mb-1">Prénom :</label>
						<input type="text" id="dataFirstName" name="firstname" placeholder="Prénom" value="{$case.prenom|escape}"
							class="block w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required
							disabled />
					</div>
					<div>
						<label for="dataBorn" class="block text-sm font-medium text-gray-900 mb-1">Date de Naissance :</label>
						<input type="date" id="dataBorn" name="born" placeholder="Date de Naissance" value="{$case.dateNaiss|escape}"
							class="block w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required
							disabled />
					</div>
					<div>
						<label for="dataReport" class="block text-sm font-medium text-gray-900 mb-1">Commentaire :</label>
						<textarea id="dataReport" name="comment" placeholder="Commentaire"
							class="block w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50"
							rows="6" required></textarea>
					</div>
					<div class="flex justify-end space-x-3">
						<a href="/mobile/dossiers"
							class="px-4 py-2 text-sm font-medium bg-gray-200 rounded-lg hover:bg-gray-300 border border-gray-300">
							Annuler
						</a>
						<button type="button"
							class="px-4 py-2 text-sm font-medium bg-red-200 rounded-lg hover:bg-red-300 border border-gray-300"
							onclick="caseClass.clearForm()">
							Réinitialiser
						</button>
						<button id="submitDataButton" type="submit"
							class="px-4 py-2 text-sm font-medium bg-blue-200 rounded-lg hover:bg-blue-300 border border-gray-300">
							Envoyer
						</button>
					</div>
				</form>
			{/if}
		</div>
	</main>
</body>

</html>