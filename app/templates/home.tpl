<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>BSA | Accueil</title>
	<link rel="stylesheet" href="/public/css/app.css">
</head>

<body class="bg-gray-900 text-white h-screen flex">
	<!-- Menu latéral -->
	<aside class="w-64 bg-gray-800 h-full flex flex-col">
		<div class="p-4 text-xl font-bold border-b border-gray-700">
			Menu
		</div>
		<nav class="flex-1 p-4 space-y-2">
			<a href="" class="block px-4 py-2 rounded-lg bg-gray-700 hover:bg-gray-600 transition">Tableau de bord</a>
			<a href="" class="block px-4 py-2 rounded-lg bg-gray-700 hover:bg-gray-600 transition">Paramètres</a>
			<a href="" class="block px-4 py-2 rounded-lg bg-gray-700 hover:bg-gray-600 transition">Profil</a>
		</nav>
		<footer class="p-4 text-sm text-gray-400 border-t border-gray-700">
			© 2024 BSA
		</footer>
	</aside>

	<!-- Contenu principal -->
	<div class="flex-1 flex flex-col">
		<!-- Barre supérieure -->
		<header class="bg-gray-800 p-4 flex items-center justify-between border-b border-gray-700">
			<h1 class="text-xl font-bold">BSA</h1>
			<div class="space-x-4">
				<a href="/signin"
					class="px-4 py-3 bg-indigo-600 hover:bg-indigo-700 rounded-lg font-semibold text-white transition">Se
					connecter</a>
				{* <a href="/signup" class="px-4 py-3 bg-gray-700 hover:bg-gray-600 rounded-lg font-semibold text-white transition">S'inscrire</a> *}
			</div>
		</header>

		<!-- Contenu principal -->
		<main class="flex-1 p-8 flex flex-col items-center justify-center space-y-6">
			<a class="text-center w-64 py-4 bg-indigo-600 hover:bg-indigo-700 rounded-lg font-bold text-white transition" href="/homeless">Gestion des personnes</a>
			<a class="text-center w-64 py-4 bg-gray-700 hover:bg-gray-600 rounded-lg font-bold text-white transition">Gestion des
				agents</a>
			<a
				class="text-center w-64 py-4 bg-green-600 hover:bg-green-700 rounded-lg font-bold text-white transition">Statistiques</a>
		</main>
	</div>
</body>

</html>