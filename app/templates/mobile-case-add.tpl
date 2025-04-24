<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>BSA | Ajouter un dossier</title>
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

	<main class="flex flex-col relative h-full w-full">
		<!-- HEADER BANNER FOR LOGO AND NAV -->
		<header class="w-full flex justify-center items-center border-b p-2 border-gray-300 shadow-md">
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

		<!-- LOADING SCREEN -->
		<div id="loadingScreen" class="absolute inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-30">
			<div class="flex items-center justify-center">
				<!-- ANIMATED CIRCLE -->
				<div class="w-16 h-16 border-4 border-t-4 border-gray-200 border-t-gray-600 rounded-full animate-spin">
				</div>
			</div>
		</div>

		<div class="w-full">
			<a href="/mobile/dossiers" class="w-fit p-4 flex items-center space-x-2 cursor-pointer">
				<div class="w-4 h-4 border-l-2 border-t-2 border-gray-700 transform -rotate-45"></div>
				<span class="text-sm font-medium">Retour</span>
			</a>
		</div>

		<!-- DATA FORM MODAL (HIDDEN BY DEFAULT)-->
		<div id="dataModal" class="bg-white p-4 w-full h-full overflow-y-scroll">
			<h2 id="dataModalTitle" class="text-2xl font-semibold text-gray-900 mb-4">
				Créer un nouveau dossier
			</h2>
			<p id="dataModalDescription" class="text-sm text-gray-600 mb-6">
				Remplissez les informations ci-dessous pour créer un dossier.
			</p>
			<form id="dataForm" class="space-y-4" onsubmit="caseClass.addData(event)">
				<div class="w-full ">
					<label for="dataResidence" class="block text-sm font-medium text-gray-900 mb-1">Lieu de résidence<span
							class="text-red-500">*</span>
						:</label>
					<select required id="dataResidence" name="residence"
						class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50">
						<option value="" selected="selected" disabled>Sélectionnez un lieu de résidence</option>
						<option class="text-red-600" value="A la rue">À la rue</option>
						<option class="text-green-700" value="Famille d'accueil - Unité de vie">Famille d'accueil - Unité de vie
						</option>
						<option class="text-blue-700" value="Hébergement associatif">Hébergement associatif</option>
						<option value="Autre">Autre</option>
					</select>
				</div>
				<div class="w-full ">
					<label for="dataLastName" class="block text-sm font-medium text-gray-900 mb-1">Nom<span
							class="text-red-500">*</span> :</label>
					<input type="text" id="dataLastName" name="lastname"
						class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required />
				</div>
				<div class="w-full ">
					<label for="dataFirstName" class="block text-sm font-medium text-gray-900 mb-1">Prénom<span
							class="text-red-500">*</span> :</label>
					<input type="text" id="dataFirstName" name="firstname"
						class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required />
				</div>
				<div class="w-full ">
					<label for="dataBorn" class="block text-sm font-medium text-gray-900 mb-1">Date de Naissance :</label>
					<input type="date" id="dataBorn" name="born"
						class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" />
				</div>
				<div class="w-full ">
					<label for="dataDn" class="block text-sm font-medium text-gray-900 mb-1">DN :</label>
					<input type="number" id="dataDn" name="dn"
						class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" />
				</div>
				<div class="w-full ">
					<label for="dataGenre" class="block text-sm font-medium text-gray-900 mb-1">Genre :</label>
					<select id="dataGenre" name="genre"
						class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50">
						<option value="" selected="selected" disabled>Sélectionnez un genre</option>
						<option value="Homme">Homme</option>
						<option value="Femme">Femme</option>
						<option value="Autre">Autre</option>
					</select>
				</div>
				<div class="w-full ">
					<label for="dataAct" class="block text-sm font-medium text-gray-900 mb-1">Activité :</label>
					<select id="dataAct" name="activity"
						class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50">
						<option value="" selected="selected" disabled>Sélectionnez un type d'activité</option>
						<option value="Mesure d'aide SEFI">Mesure d'aide SEFI</option>
						<option value="CDD">CDD</option>
						<option value="Intérim">Intérim</option>
						<option value="Formation">Formation</option>
						<option value="CDI">CDI</option>
						<option value="SITH">SITH</option>
						<option value="Extra">Extra</option>
						<option value="Saisonnier">Saisonnier</option>
						<option value="Non-déclaré">Non-déclaré</option>
					</select>
				</div>
				<div class="w-full ">
					<label for="dataEmail" class="block text-sm font-medium text-gray-900 mb-1">Mail :</label>
					<input type="email" id="dataEmail" name="mail"
						class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" />
				</div>
				<div class="w-full ">
					<label for="dataPhone" class="block text-sm font-medium text-gray-900 mb-1">N° de Téléphone :</label>
					<input type="text" id="dataPhone" name="phone"
						class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" />
				</div>
				<div class="w-full ">
					<label for="dataChild" class="block text-sm font-medium text-gray-900 mb-1">Nombre d'enfant(s) à charge
						:</label>
					<input type="number" id="dataChild" name="child"
						class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" />
				</div>
				<div class="w-full ">
					<label for="dataTypo" class="block text-sm font-medium text-gray-900 mb-1">Typologie :</label>
					<select id="dataTypo" name="typology"
						class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50">
						<option value="" selected="selected" disabled>Sélectionnez une typologie</option>
						<option value="Originaire des îles pour parcours de soins">Originaire des îles pour parcours de soins
						</option>
						<option value="Originaire des îles pour recherche ou prise d'emploi">Originaire des îles pour recherche ou
							prise d'emploi</option>
						<option value="Originaire des îles pour poursuite d'études">Originaire des îles pour poursuite d'études
						</option>
						<option value="Fa'amu">Fa'amu</option>
						<option value="Recomposition familiale contraignante">Recomposition familiale contraignante</option>
						<option value="Troubles psychiques">Troubles psychiques</option>
						<option value="Personne âgée">Personne âgée</option>
						<option value="Violences intra-familiales">Violences intra-familiales</option>
						<option value="Famille nombreuse, pressions et promiscuité">Famille nombreuse, pressions et promiscuité
						</option>
						<option value="Sortant de prison">Sortant de prison</option>
						<option value="Eu(e) recourt à une mesure d'assistance éducative">Eu(e) recourt à une mesure
							d'assistance
								éducative</option>
							<option value="Mineur(euse) sortant d'établissement socio-éducatif">Mineur(euse) sortant d'établissement
								socio-éducatif</option>
							<option value="Autre">Autre</option>
						</select>
					</div>
					<div class="w-full ">
						<label for="dataIdTuteur" class="block text-sm font-medium text-gray-900 mb-1">Service utilisateur
							:</label>
						<select id="dataIdTuteur" name="idTuteur"
							class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50">
							<option value="" selected="selected" disabled>Sélectionnez un utilisateur</option>
							{if isset($tutors)}
									{foreach from=$tutors item=$tutor}
									<option value="{$tutor.idTuteur}">{$tutor.nom} {$tutor.prenom}</option>
									{/foreach}
								{/if}
						</select>
					</div>
					<div class="w-full ">
						<label for="dataIdIle" class="block text-sm font-medium text-gray-900 mb-1">Île<span
								class="text-red-500">*</span> :</label>
						<select id="dataIdIle" name="idIle"
							class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required>
							<option value="" selected="selected" disabled>Sélectionnez une île</option>
								{if isset($archipelagos)}
									{foreach from=$archipelagos item=$archipelago}
									<optgroup label="{$archipelago.lib}">
										{if isset($isles)}
											{foreach from=$isles item=$isle}
												{if ($isle.idParent == $archipelago.idZone)}
													<option value="{$isle.idZone|escape}">{$isle.lib|escape}</option>
												{/if}
											{/foreach}
										</optgroup>
										{/if}
									{/foreach}
								{/if}
						</select>
					</div>
					<div class="flex justify-end space-x-3">
						<a href="/mobile/dossiers"
							class="px-4 py-2 text-sm font-medium bg-gray-200 rounded-lg hover:bg-gray-300 border border-gray-300">
							Annuler
						</a>
						<button id="clearCaseModalButton" type="button"
							class="px-4 py-2 text-sm font-medium bg-red-200 rounded-lg hover:bg-red-300 border border-gray-300"
							onclick="caseClass.clearForm()">
							Réinitialiser
						</button>
						<button id="submitDataButton" type="submit"
							class="px-4 py-2 text-sm font-medium bg-blue-200 rounded-lg hover:bg-blue-300 border border-gray-300">
							Ajouter
						</button>
					</div>
				</form>
			</div>
		</main>
	</body>

	</html>