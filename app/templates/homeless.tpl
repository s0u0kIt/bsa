<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>BSA | Gestion des personnes</title>
	<link rel="stylesheet" href="/public/css/app.css">
</head>

<body class="bg-gray-900 text-white flex h-screen">
	<!-- Menu latéral -->
	<aside class="w-64 bg-gray-800 h-full flex flex-col">
		<div class="p-4 text-xl font-bold border-b border-gray-700">
			Menu
		</div>
		<nav class="flex-1 p-4 space-y-2">
			<a href="/home" class="block px-4 py-2 rounded-lg bg-gray-700 hover:bg-gray-600 transition">Tableau de bord</a>
			<a href="" class="block px-4 py-2 rounded-lg bg-gray-700 hover:bg-gray-600 transition">Paramètres</a>
			<a href="" class="block px-4 py-2 rounded-lg bg-gray-700 hover:bg-gray-600 transition">Profil</a>
		</nav>
		<footer class="p-4 text-sm text-gray-400 border-t border-gray-700">
			© 2024 BSA
		</footer>
	</aside>

	<!-- Contenu principal -->
	<div class="flex-1 flex flex-col h-screen">
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
		<main class="flex-1 p-3 flex flex-col h-full overflow-x-auto">

			<!-- INFORMATIONS DES SANS ABRIS -->

			<form class="w-full mx-auto mb-4">
				<label for="default-search" class="mb-2 text-sm font-medium text-gray-900 sr-only dark:text-white">Rechercher
				</label>
				<div class="relative">
					<div class="absolute inset-y-0 start-0 flex items-center ps-3 pointer-events-none">
						<svg class="w-4 h-4 text-gray-500 dark:text-gray-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
							fill="none" viewBox="0 0 20 20">
							<path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
								d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z" />
						</svg>
					</div>
					<input type="search" id="default-search"
						class="block w-full p-4 ps-10 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 focus:ring-blue-500 focus:border-blue-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
						placeholder="Rechercher des personnes" required />
					<button type="submit"
						class="text-white absolute end-2.5 bottom-2.5 bg-indigo-600 hover:bg-indigo-700 font-medium rounded-lg text-sm px-4 py-2 dark:bg-indigo-600 dark:hover:bg-indigo-700">Rechercher</button>
				</div>
			</form>

			<div class="relative w-full overflow-x-auto shadow-md sm:rounded-lg">
				<table class="w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400">
					<thead class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400">
						<tr>
							<th scope="col" class="px-2 py-3">
								Nom
							</th>
							<th scope="col" class="px-2 py-3">
								Prénom
							</th>
							<th scope="col" class="px-2 py-3">
								Age
							</th>
							<th scope="col" class="px-2 py-3">
								Genre
							</th>
							<th scope="col" class="px-2 py-3">
								Selection
							</th>
						</tr>
					</thead>
					<tbody>
						<tr
							class="odd:bg-white odd:dark:bg-gray-900 even:bg-gray-50 even:dark:bg-gray-800 border-b dark:border-gray-700">
							<th scope="row" class="px-2 py-4 font-medium text-gray-900 whitespace-nowrap dark:text-white">
								Hoani
							</th>
							<td class="px-2 py-4">
								Taata
							</td>
							<td class="px-2 py-4">
								45
							</td>
							<td class="px-2 py-4">
								H/F
							</td>
							<td class="px-2 py-4 flex flex-col">
								<input type="checkbox" value=""
									class="w-4 h-4 text-blue-600 bg-gray-100 border-gray-300 rounded focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-800 focus:ring-2 dark:bg-gray-700 dark:border-gray-600">
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
		</main>
	</div>
</body>

</html>