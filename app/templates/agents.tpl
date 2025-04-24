<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>BSA | Agents</title>
	<link rel="stylesheet" href="/public/css/app.css" />
	<script src="/public/js/agent.js"></script>
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
	<header class="w-full h-auto flex flex-col shadow-md">
		<div class="w-full flex justify-center border-b border-gray-300">
			<div class="w-full flex items-center justify-center">
				<a href="/">
					<img class="h-20"
						src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmbtLpeNT9LKw5v1M9yODfmXnfot4eWKlwQA&s"
						alt="" />
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
								class="font-semibold text-gray-500 block px-4 py-2 hover:bg-gray-100">Déconnexion</a>
						</li>
						<li><a href="/mot-de-passe-oublie"
								class="font-semibold text-gray-500 block px-4 py-2 hover:bg-gray-100">Changer de mot de
								passe</a>
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
				<a href="/app/dossiers"
					class="h-full hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Gestion des
					dossiers</a>
				<a href="#"
					class="h-full border-b-2 border-blue-400 hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Gestion
					des
					agents</a>
				<a href="/app/carte"
					class="h-full hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Carte</a>
				<a href="/app/statistiques"
					class="h-full hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Statistiques</a>
			</div>

			<!-- BURGER BUTTON (MOBILE) -->
			<button id="menu-toggle" class="block md:hidden text-gray-700 focus:outline-none">
				<svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
					stroke="currentColor">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
				</svg>
			</button>

			<!-- LINKS COL (HIDDEN BY DEFAULT) -->
			<div id="mobile-menu"
				class="hidden md:hidden absolute top-12 right-0 w-full bg-white shadow-lg p-4 space-y-2 z-20">
				<a href="/app" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Tableau de bord</a>
				<a href="/app/dossiers" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Gestion des
					dossiers</a>
				<a href="#" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Gestion des
					agents</a>
				<a href="/app/carte" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Carte</a>
				<a href="/app/statistiques"
					class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Statistiques</a>
			</div>
		</nav>
	</header>

	<!-- MAIN CONTENT OR APP -->
	<main class="w-full h-full overflow-y-hidden relative flex flex-col space-y-4">

		<!-- LOADING SCREEN -->
		<div id="loadingScreen"
			class="absolute inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-10">
			<div class="flex items-center justify-center">
				<!-- Cercle animé -->
				<div class="w-16 h-16 border-4 border-t-4 border-gray-200 border-t-gray-600 rounded-full animate-spin">
				</div>
			</div>
		</div>

		<!-- DATA FORM MODAL (HIDDEN BY DEFAULT)-->
		<dialog id="dataModal"
			class="relative p-6 bg-white rounded-lg shadow-lg overflow-hidden w-fit border border-gray-300 self-center">

			<!-- CLOSE BUTTON -->
			<button type="button" onclick="agentClass.toggleDataModal()"
				class="fixed top-4 right-4 text-red-600 hover:text-red-800 p-2 rounded-full bg-white shadow-md border border-gray-300">
				<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor"
					class="w-6 h-6">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
				</svg>
			</button>

			<h2 id="dataModalTitle" class="text-2xl font-semibold text-gray-900 mb-4">
				Ajouter un agent
			</h2>
			<p id="dataModalDescription" class="text-sm text-gray-600 mb-6">
				Remplissez les informations ci-dessous pour ajouter un nouvel agent.
			</p>
			<form id="dataForm" class="space-y-4" onsubmit="agentClass.addData(event)">
				<div>
					<label for="dataId" class="block text-sm font-medium text-gray-900 mb-1">N° Agent :</label>
					<input type="number" id="dataId" name="id" disabled
						class="block w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50"
						required />
				</div>
				<div>
					<label for="dataLastName" class="block text-sm font-medium text-gray-900 mb-1">Nom :</label>
					<input type="text" id="dataLastName" name="lastname"
						class="block w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50"
						required />
				</div>
				<div>
					<label for="dataFirstName" class="block text-sm font-medium text-gray-900 mb-1">Prénom :</label>
					<input type="text" id="dataFirstName" name="firstname"
						class="block w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50"
						required />
				</div>
				<div>
					<label for="dataPhone" class="block text-sm font-medium text-gray-900 mb-1">N° de Téléphone
						:</label>
					<input type="text" id="dataPhone" name="phone"
						class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50"
						required />
				</div>
				<div>
					<label for="dataLogin" class="block text-sm font-medium text-gray-900 mb-1">Identifiant :</label>
					<input type="email" id="dataLogin" name="login"
						class="block w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50"
						required />
				</div>
				<div>
					<label for="dataRole" class="block text-sm font-medium text-gray-900 mb-1">Rôle :</label>
					<select type="text" id="dataRole" name="role"
						class="block w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50">
						<option value="Admin">Administrateur</option>
						<option value="Utilisateur" selected="selected">Utilisateur</option>
						<option value="Inactif">Inactif</option>
					</select>
				</div>
				<div class="flex justify-end space-x-3">
					<button type="button"
						class="px-4 py-2 text-sm font-medium bg-gray-200 rounded-lg hover:bg-gray-300 border border-gray-300"
						onclick="agentClass.toggleDataModal()">
						Annuler
					</button>
					<button id="clearAgentModalButton" type="button"
						class="px-4 py-2 text-sm font-medium bg-red-200 rounded-lg hover:bg-red-300 border border-gray-300"
						onclick="agentClass.clearDataModal()">
						Réinitialiser
					</button>
					<button id="submitDataButton" type="submit"
						class="px-4 py-2 text-sm font-medium bg-blue-200 rounded-lg hover:bg-blue-300 border border-gray-300">
						Ajouter
					</button>
				</div>
			</form>
		</dialog>

		<!-- TOOLBAR BUTTONS -->
		<div class="w-full px-8 flex items-center space-x-4">
			<button
				class="px-4 py-3  bg-gray-50 hover:bg-gray-100 border border-gray-300 rounded-lg font-semibold transition w-fit"
				onclick="agentClass.toggleDataModal()">
				Ajouter
			</button>
		</div>

		<!-- SEARCH BAR -->
		<form class="w-full flex place-content-around mx-auto">
			<div class="w-full mx-8 flex border border-gray-300 rounded-lg bg-gray-50">
				<div class="mx-3 w-5 flex items-center justify-center pointer-events-none">
					<svg class="w-full text-gray-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none"
						viewBox="0 0 20 20">
						<path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
							d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z" />
					</svg>
				</div>
				<input type="text" id="searchData" oninput="agentClass.filterData(event)"
					class="w-full m-1 p-2 text-sm text-gray-900 bg-gray-50 focus:outline-none focus:bg-gray-100"
					placeholder="Rechercher des agents" required />
			</div>
		</form>

		<!-- DATA TABLE -->
		<div class="w-full h-full overflow-y-scroll px-8">
			<table id="dataTable" class="w-full text-sm text-left rtl:text-right text-gray-500 border border-gray-300">
				<thead class="font-normal text-gray-600 uppercase bg-gray-50">
					<tr>
						<th scope="col" class="px-2 py-3">N° Agent</th>
						<th scope="col" class="px-2 py-3">Nom</th>
						<th scope="col" class="px-2 py-3">Prénom</th>
						<th scope="col" class="px-2 py-3">N° de Téléphone</th>
						<th scope="col" class="px-2 py-3">Identifiant</th>
						<th scope="col" class="px-2 py-3">Role</th>
					</tr>
				</thead>
				<tbody>
					{foreach from=$agents item=$agent}
						<tr onclick="agentClass.displayData(event)"
							class="odd:bg-white even:bg-gray-50 border-b cursor-pointer">
							<th scope="row" class="px-2 py-4 font-medium text-gray-900 whitespace-nowrap thId">
								{$agent.idAgent|escape}
							</th>
							<td class="px-2 py-4 tdLastName">{$agent.nom|escape}</td>
							<td class="px-2 py-4 tdFirstName">{$agent.prenom|escape}</td>
							<td class="px-2 py-4 tdPhone">{$agent.tel|escape}</td>
							<td class="px-2 py-4 tdLogin">{$agent.login|escape}</td>
							<td class="px-2 py-4 tdRole">{$agent.role|escape}</td>
						</tr>
					{/foreach}
				</tbody>
			</table>
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
					légales</a>
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