<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>BSA | Zones</title>
	<link rel="stylesheet" href="/public/css/app.css" />
	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
		integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />
	<script src="/public/js/zone.js"></script>
	<script src="/public/js/loading-screen.js"></script>
	<script src="/public/js/mobile-menu.js"></script>
	<script src="/public/js/notification-popup.js"></script>
</head>

<body class="relative flex flex-col items-center bg-gray-100 text-gray-900 font-sans">
	<!-- NOTIFICATION POPUP -->
	<div id="notificationPopup" class="fixed hidden mt-2 p-2 w-96 h-fit text-sm border border-gray-200 rounded-lg">
		<p id="notificationMessage">Something to say</p>
	</div>

	<!-- HEADER BANNER FOR LOGO AND NAV -->
	<header class="bg-white w-full h-auto flex flex-col shadow-md">
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
				<a href="/app/carte" class="h-full hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Carte</a>
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
				<a href="/app/carte" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Carte</a>
				<a href="/app/statistiques" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Statistiques</a>
			</div>
		</nav>
	</header>

	<!-- MAIN CONTENT OR APP -->
	<main class="w-full h-full flex flex-col space-y-4">

		<!-- LOADING SCREEN -->
		<div id="loadingScreen"
			class="absolute inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-[2000]">
			<div class="flex items-center justify-center">
				<div class="w-16 h-16 border-4 border-t-4 border-gray-200 border-t-gray-600 rounded-full animate-spin">
				</div>
			</div>
		</div>

		<!-- SEARCH BAR -->
		<form class="w-full flex place-content-around mx-auto mb-4">
			<div class="w-full mx-8 flex border border-gray-300 rounded-lg bg-gray-50">
				<div class="mx-3 w-5 flex items-center justify-center pointer-events-none">
					<svg class="w-full text-gray-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none"
						viewBox="0 0 20 20">
						<path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
							d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z" />
					</svg>
				</div>
				<input type="text" id="searchInput" oninput="zoneClass.filterData(event)"
					class="w-full m-1 p-2 text-sm text-gray-900 bg-gray-50 focus:outline-none focus:bg-gray-100"
					placeholder="Rechercher une zone" required />
			</div>
		</form>

		{* ZONES LIST *}
		<ul id="zoneList" class="px-2 space-y-4">
			{foreach from=$zones item=archipel}
				<li class="dropdown flex flex-col border-l-4 border-blue-500 pl-4 py-2 bg-gray-50 rounded-lg shadow-sm"
					onclick="zoneClass.toggleSection(event)">
					<h2 class="flex flex-row items-center font-bold text-2xl text-blue-700 cursor-pointer">
						{$archipel.lib|escape:'html'}
						<svg class="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
						</svg>
						<form class="ml-auto">
							<fieldset class="flex space-x-2 mr-2">
								<label class="flex items-center space-x-1 cursor-pointer">
									<input onchange="zoneClass.saveData(event)" type="radio" name="{$archipel.idZone|escape:'html'}"
										value="1" class="hidden peer" {if
									$archipel.active}checked{/if}>
								<span
									class="w-5 h-5 inline-block border-2 border-blue-500 rounded-full peer-checked:bg-blue-500"></span>
							</label>
							<label class="flex items-center space-x-1 cursor-pointer">
								<input onchange="zoneClass.saveData(event)" type="radio" name="{$archipel.idZone|escape:'html'}"
									value="0" class="hidden peer" {if
									!$archipel.active}checked{/if}>
								<span class="w-5 h-5 inline-block border-2 border-red-400 rounded-full peer-checked:bg-red-400"></span>
							</label>
						</fieldset>
					</form>
				</h2>
				{if !empty($archipel.children)}
					<ul class="dropdown-content hidden space-y-2 pl-4">
						{foreach from=$archipel.children item=ile}
							<li class="dropdown flex flex-col border-l-4 border-green-500 pl-4 py-2 bg-gray-100 rounded-lg">
								<h3 class="flex flex-row items-center font-bold text-xl text-green-700 cursor-pointer">
									{$ile.lib|escape:'html'}
									<svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
										<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
									</svg>
									<form class="ml-auto">
										<fieldset class="flex space-x-2 mr-2">
											<label class="flex items-center space-x-1 cursor-pointer">
												<input onchange="zoneClass.saveData(event)" type="radio" name="{$ile.idZone|escape:'html'}"
													value="1" class="hidden peer" {if $ile.active}checked{/if}>
												<span
													class="w-5 h-5 inline-block border-2 border-blue-500 rounded-full peer-checked:bg-blue-500"></span>
											</label>
											<label class="flex items-center space-x-1 cursor-pointer">
												<input onchange="zoneClass.saveData(event)" type="radio" name="{$ile.idZone|escape:'html'}"
													value="0" class="hidden peer" {if
																	!$ile.active}checked{/if}>
											<span
												class="w-5 h-5 inline-block border-2 border-red-400 rounded-full peer-checked:bg-red-400"></span>
										</label>
									</fieldset>
								</form>
							</h3>
							{if !empty($ile.children)}
								<ul class="dropdown-content hidden space-y-2 pl-4">
									{foreach from=$ile.children item=commune}
										<li class="dropdown flex flex-col border-l-4 border-orange-500 pl-4 py-2 bg-gray-200 rounded-lg">
											<h4 class="flex flex-row items-center font-bold text-lg text-orange-700 cursor-pointer">
												{$commune.lib|escape:'html'}
												<svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
													<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
												</svg>
												<form class="ml-auto">
													<fieldset class="flex space-x-2 mr-2">
														<label class="flex items-center space-x-1 cursor-pointer">
															<input onchange="zoneClass.saveData(event)" type="radio" name="{$commune.idZone|escape:'html'}"
																value="1" class="hidden peer" {if $commune.active}checked{/if}>
															<span
																class="w-5 h-5 inline-block border-2 border-blue-500 rounded-full peer-checked:bg-blue-500"></span>
														</label>
														<label class="flex items-center space-x-1 cursor-pointer">
															<input onchange="zoneClass.saveData(event)" type="radio" name="{$commune.idZone|escape:'html'}"
																value="0" class="hidden peer" {if !$commune.active}checked{/if}>
															<span
																class="w-5 h-5 inline-block border-2 border-red-400 rounded-full peer-checked:bg-red-400"></span>
														</label>
													</fieldset>
												</form>
											</h4>
											{if !empty($commune.children)}
												<ul class="dropdown-content hidden space-y-1 pl-4">
													{foreach from=$commune.children item=zone}
														<li class="py-1">
															<h5 class="flex flex-row items-center text-md text-gray-800 font-semibold">
																{$zone.lib|escape:'html'}
																<form class="ml-auto">
																	<fieldset class="flex space-x-2 mr-2">
																		<label class="flex items-center space-x-1 cursor-pointer">
																			<input onchange="zoneClass.saveData(event)" type="radio" name="{$zone.idZone|escape:'html'}"
																				value="1" class="hidden peer" {if $zone.active}checked{/if}>
																			<span
																				class="w-5 h-5 inline-block border-2 border-blue-500 rounded-full peer-checked:bg-blue-500"></span>
																		</label>
																		<label class="flex items-center space-x-1 cursor-pointer">
																			<input onchange="zoneClass.saveData(event)" type="radio" name="{$zone.idZone|escape:'html'}"
																				value="0" class="hidden peer" {if !$zone.active}checked{/if}>
																			<span
																				class="w-5 h-5 inline-block border-2 border-red-400 rounded-full peer-checked:bg-red-400"></span>
																		</label>
																	</fieldset>
																</form>
															</h5>
														</li>
													{/foreach}
												</ul>
											{/if}
										</li>
									{/foreach}
								</ul>
							{/if}
						</li>
					{/foreach}
				</ul>
				{/if}
			</li>
			{/foreach}
		</ul>
	</main>

	<!-- FOOTER ONLY FOR CONTENT PAGES, NOT FULLSCREEN APPS -->
	<footer></footer>
</body>

</html>