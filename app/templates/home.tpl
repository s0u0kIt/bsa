<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>BSA | Accueil</title>
	<link rel="stylesheet" href="/public/css/app.css" />
	<link rel="stylesheet" href="/public/css/home.css" />
	<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
		integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />
	<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
		integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
	<script src="/public/js/home.js"></script>
</head>

<body class="flex flex-col items-center min-h-screen bg-white">
	<!-- HERO BANNER -->
	<section class="w-full flex flex-col items-center justify-center bg-cover bg-center relative"
		style="background-image: url('/public/img/DALL·E-2025-02-20-09.48.jpg');">
		<!-- Calque sombre -->

		<!-- HEADER -->
		<header class="w-full h-auto flex flex-col relative z-10">
			<div class="w-full flex justify-start">
				<div class="pl-5 w-full flex items-start justify-start">
					<a href="/">
						<img class="h-24 transform transition-transform duration-300 hover:scale-105"
							src="/public/img/dsfe-min-logo.png" alt="Logo de la DSFE" />
					</a>
				</div>
				<ul class="w-full flex items-center justify-center space-x-4 first:ml-4 last:mr-4">
					<a href="/app"
						class="text-black font-bold transition-transform duration-300 hover:scale-105 bg-white rounded-full p-2">Mon
						espace</a>
				</ul>
			</div>
		</header>
		<div class="w-full h-[70vh] flex flex-col items-center justify-center relative space-y-6 z-10">
			<h2 class="text-[120px] md:text-5xl lg:text-8xl font-bold text-white mb-20 text-center animate-fade-in">
				BIENVENUE
			</h2>
			<h1 class="text-4xl md:text-5xl lg:text-7xl font-bold text-white mb-4 text-center animate-fade-in">
				Bureau en charge<br>
				des personnes<br>
				Sans Abri
			</h1>
			<p class="text-[25px] md:text-5xl lg:text-4xl font-bold text-white text-center animate-fade-in">
				"Se réunir est un début, Rester ensemble est un progrès,<br>
				Travailler ensemble c'est la réussite"<br>
				Henry FORD
			</p>
		</div>
		<!-- SVG pour le demi-cercle inversé -->
		<svg class="home-header-wallpaper-curved-separator-path css-1fb2fgk" data-name="Calque 1"
			xmlns="http://www.w3.org/2000/svg" viewBox="0 0 482.41 18.16">
			<path fill="#FFF"
				d="M241.4 15.5C139.24 15.5 49.74 9.3 0 0v18.16h482.41V.07C432.59 9.33 343.29 15.5 241.4 15.5Z">
			</path>
		</svg>
	</section>

	<!-- MAIN CONTENT -->
	<main class="w-full flex flex-col items-center justify-center bg-white py-12">
		<!-- Section Missions -->
		<div class="max-w-6xl w-full px-4">
			<section class="mb-16">
				<h2 class="text-3xl md:text-4xl font-bold text-center text-gray-900 mb-8">
					Nos Missions
				</h2>
				<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
					<div
						class="bg-blue-50 p-6 rounded-lg shadow-md transform transition-transform duration-300 hover:scale-105">
						<h3 class="text-xl font-bold text-blue-800 mb-4">Pilotage</h3>
						<p class="text-gray-700">Participer à l’accompagnement des personnes sans-abri.</p>
					</div>
					<div
						class="bg-purple-50 p-6 rounded-lg shadow-md transform transition-transform duration-300 hover:scale-105">
						<h3 class="text-xl font-bold text-purple-800 mb-4">Observatoire</h3>
						<p class="text-gray-700">Observer, analyser, évaluer et documenter.</p>
					</div>
					<div
						class="bg-green-50 p-6 rounded-lg shadow-md transform transition-transform duration-300 hover:scale-105">
						<h3 class="text-xl font-bold text-green-800 mb-4">Innovation</h3>
						<p class="text-gray-700">Développer de nouvelles solutions.</p>
					</div>
					<div
						class="bg-yellow-50 p-6 rounded-lg shadow-md transform transition-transform duration-300 hover:scale-105">
						<h3 class="text-xl font-bold text-yellow-800 mb-4">Formation</h3>
						<p class="text-gray-700">Sensibiliser, former et communiquer.</p>
					</div>
					<div
						class="bg-pink-50 p-6 rounded-lg shadow-md transform transition-transform duration-300 hover:scale-105">
						<h3 class="text-xl font-bold text-pink-800 mb-4">Institutionnelle</h3>
						<p class="text-gray-700">Orienter et consolider les actions à un niveau institutionnel.</p>
					</div>
					<div
						class="bg-indigo-50 p-6 rounded-lg shadow-md transform transition-transform duration-300 hover:scale-105">
						<h3 class="text-xl font-bold text-indigo-800 mb-4">Gestion</h3>
						<p class="text-gray-700">Gérer le BSA de manière efficace et transparente.</p>
					</div>
				</div>
			</section>

			<!-- Section Finalités -->
			<section class="mb-16">
				<h2 class="text-3xl md:text-4xl font-bold text-center text-gray-900 mb-8">
					Nos Finalités
				</h2>
				<div class="grid grid-cols-1 md:grid-cols-2 gap-8">
					<div class="bg-red-50 p-6 rounded-lg shadow-md transform transition-transform duration-300 hover:scale-105">
						<h3 class="text-xl font-bold text-red-800 mb-4">Réduire la précarité</h3>
						<p class="text-gray-700">Réduire l'augmentation du nombre de personnes sans-abri dans la rue.
						</p>
					</div>
					<div class="bg-cyan-50 p-6 rounded-lg shadow-md transform transition-transform duration-300 hover:scale-105">
						<h3 class="text-xl font-bold text-cyan-800 mb-4">Mobiliser les acteurs</h3>
						<p class="text-gray-700">Fédérer et mobiliser l'ensemble des acteurs pour une action collective.
						</p>
					</div>
				</div>
			</section>

			<!-- Section Contact -->
			<section class="mb-16">
				<h2 class="text-3xl md:text-4xl font-bold text-center text-gray-900 mb-8">
					Contactez-nous
				</h2>
				<div class="grid grid-cols-1 md:grid-cols-2 gap-8">
					<div class="bg-purple-50 p-6 rounded-lg shadow-md transform transition-transform duration-300 hover:scale-105">
						<h3 class="text-xl font-bold text-purple-800 mb-4">Coordinatrice de projet</h3>
						<p class="text-gray-700">Moerani AMARU</p>
						<p class="text-gray-700">Téléphone : 40 549 252 / 89 450 574</p>
						<p class="text-gray-700">E-mail : moerani.amaru@administration.gov.pf</p>
					</div>
					<div class="bg-orange-50 p-6 rounded-lg shadow-md transform transition-transform duration-300 hover:scale-105">
						<h3 class="text-xl font-bold text-orange-800 mb-4">Secrétaire</h3>
						<p class="text-gray-700">Gilda CHAVEZ</p>
						<p class="text-gray-700">Téléphone : 40 549 250 / 89 450 275</p>
						<p class="text-gray-700">E-mail : bsa.dsfe@administration.gov.pf</p>
					</div>
				</div>
				<div class="mt-8">
					<h3 class="text-xl font-bold text-center text-gray-900 mb-4">Notre localisation</h3>
					<p class="text-gray-700 text-center">Rue des remparts, Missions, Papeete (proche de l'OPH de
						Papeete)</p>
					<div id="map" class="w-full h-96 rounded-lg border border-gray-300 mt-8"></div>
				</div>
			</section>
		</div>
	</main>

	<!-- FOOTER -->
	<footer class="w-full text-gray-600 py-4 border-t border-gray-200 bg-white">
		<div class="container mx-auto text-center">
			<p class="text-gray-600">&copy; 2025 DSFE (Direction des Solidarités de la Famille et de l'Égalité) - BSA
				(Bureau en charge des Sans Abris). Tous droits réservés.</p>
			<p class="text-gray-600">Site créé en 2025.</p>
			<p>
				<a href="/app/policies/legal-mentions"
					class="text-blue-400 hover:text-blue-600 transition-colors duration-300">Mentions légales</a> |
				<a href="/app/policies/general-conditions"
					class="text-blue-400 hover:text-blue-600 transition-colors duration-300">Conditions
					Générales d'utilisation</a> |
				<a href="/app/policies/privacy-policy"
					class="text-blue-400 hover:text-blue-600 transition-colors duration-300">Politique de
					Confidentialité</a>
			</p>
		</div>
	</footer>

</body>

</html>