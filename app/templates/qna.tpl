<!DOCTYPE html>
<html lang="fr">

<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>BSA | Foire À Question</title>
	<link rel="stylesheet" href="/public/css/app.css" />
	<script src="/public/js/loading-screen.js"></script>
	<script src="/public/js/notification-popup.js"></script>
	<script src="/public/js/mobile-menu.js"></script>
	<!-- Load font awesome icons -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>

<body class="flex flex-col items-center relative">
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
			<a href="/deconnexion">Déconnexion</a>
				<li>Paramètres</li>
				<a href="/app/faq">FAQ</a>
			</ul>
		</div>

			<!-- NAV -->
			<nav class="w-full h-12 flex items-center justify-center space-x-4 bg-white shadow-md relative">
				<!-- LINKS ROW (PC) -->
				<div class="hidden h-full md:flex space-x-6">
					<a href="#section1"
						class="h-full hover:border-b-2 border-blue-400 hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">
						Section 1: Généralités</a>
					<a href="#section2"
						class="h-full hover:border-b-2 border-blue-400 hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">
						Section 2: Utilisation</a>
					<a href="#section3"
						class="h-full hover:border-b-2 border-blue-400 hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">
						Section 3: Maintenance</a>
				</div>

				<!-- BURGER BUTTON (MOBILE) -->
				<button id="menu-toggle" class="block md:hidden text-gray-700 focus:outline-none">
					<svg class="h-8 w-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
						stroke="currentColor">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
							d="M4 6h16M4 12h16M4 18h16" />
					</svg>
				</button>

				<!-- LINKS COL (HIDDEN BY DEFAULT) -->
				<div id="mobile-menu"
					class="hidden md:hidden absolute top-12 right-0 w-full bg-white shadow-lg p-4 space-y-2 z-20">
					<a href="#section1" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">
						Section 1: Généralités
					</a>
					<a href="#section2" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">
						Section 2: Utilisation
					</a>
					<a href="#section3" class="bloc k px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">
						Section 3: Maintenance
					</a>
				</div>
			</nav>
	</header>

	<main class="m-4">
		<h1 class="text-4xl font-bold mb-6">Foire à Questions (FAQ)</h1>

		<div class="faq-section mb-6" id="section1">
			<h2 class="text-2xl font-semibold mb-4">Section 1: Généralités</h2>
			<h3 class="text-xl font-medium mb-2">Question 1: Qu'est-ce qu'une FAQ?</h3>
			<p class="mb-4">Une FAQ, ou Foire à Questions, est une liste de questions et réponses fréquemment posées
				sur un sujet particulier.</p>

			<h3 class="text-xl font-medium mb-2">Question 2: Pourquoi utiliser une FAQ?</h3>
			<p class="mb-4">Une FAQ permet de fournir des réponses rapides et claires aux questions courantes, ce
				qui peut aider à réduire le nombre de demandes de support.</p>
		</div>

		<div class="faq-section mb-6" id="section2">
			<h2 class="text-2xl font-semibold mb-4">Section 2: Utilisation</h2>
			<h3 class="text-xl font-medium mb-2">Question 1: Comment créer une FAQ?</h3>
			<p class="mb-4">Pour créer une FAQ, identifiez les questions les plus fréquemment posées par vos
				utilisateurs et rédigez des réponses claires et concises pour chacune d'elles.</p>

			<h3 class="text-xl font-medium mb-2">Question 2: Où placer une FAQ sur un site web?</h3>
			<p class="mb-4">Il est recommandé de placer la FAQ dans une section facilement accessible de votre site
				web, comme dans le menu principal ou dans le pied de page.</p>
		</div>

		<div class="faq-section mb-6" id="section3">
			<h2 class="text-2xl font-semibold mb-4">Section 3: Maintenance</h2>
			<h3 class="text-xl font-medium mb-2">Question 1: Comment maintenir une FAQ à jour?</h3>
			<p class="mb-4">Pour maintenir une FAQ à jour, revoyez régulièrement les questions et réponses pour vous
				assurer qu'elles sont toujours pertinentes et correctes. Ajoutez de nouvelles questions au fur et à
				mesure qu'elles apparaissent.</p>

			<h3 class="text-xl font-medium mb-2">Question 2: Qui doit être responsable de la FAQ?</h3>
			<p class="mb-4">La responsabilité de la FAQ peut être confiée à une personne ou une équipe qui a une
				bonne connaissance du sujet et qui peut répondre aux questions des utilisateurs.
				Lorem ipsum, dolor sit amet consectetur adipisicing elit. Consectetur sint
				voluptatibus aperiam, odio dignissimos illum, hic aspernatur saepe enim beatae
				unde deserunt fugit vero quibusdam dolorum quasi! Fuga, quam repellendus! Fugit
				veniam aliquam eligendi animi doloremque! Ea aspernatur ex, fuga corporis
				tempora doloribus totam iusto recusandae animi non dignissimos, magni cumque
				excepturi, eaque assumenda eveniet quas earum at dolor! Sunt commodi, veritatis
				dolorem voluptas voluptates nobis. Repellendus laborum maxime vitae porro,
				quisquam fugiat dicta voluptatum enim ea aspernatur at cupiditate eveniet
				veritatis ipsa facilis consequuntur facere maiores hic nobis suscipit? Incidunt
				eligendi vel perferendis totam eum minima similique quisquam voluptatibus, eius
				alias vitae mollitia culpa maxime. Ad quo necessitatibus fugiat explicabo,
				magnam maxime obcaecati vero dolor atque nemo, recusandae ut natus voluptas
				ipsam nesciunt omnis cumque sit, non delectus quod eaque ex fuga fugit quisquam?
				Consequatur beatae temporibus rerum hic, corrupti similique, at minus, minima
				voluptas explicabo asperiores incidunt perferendis? Reprehenderit fuga molestias
				aliquid facilis! Non itaque ullam unde beatae quis! Accusamus obcaecati,
				doloremque, voluptates voluptatibus temporibus odit vero explicabo minima harum
				optio consectetur, dolor quisquam nulla facilis! Delectus dolorem fuga sequi
				quas nostrum modi unde necessitatibus aliquam porro non eveniet, nulla magni rem
				distinctio eaque, laborum quo voluptatibus ad explicabo animi asperiores dolorum
				mollitia! Accusantium inventore dolores doloremque incidunt dignissimos libero
				corporis vero quisquam laboriosam, fuga accusamus porro odit ullam aut enim
				tempore non molestias rerum corrupti, quasi assumenda excepturi. Neque animi
				quisquam aliquam officia maxime enim similique repellendus. Quod in deleniti
				numquam sed tenetur consequatur maxime incidunt odio labore? Numquam corporis
				placeat nihil consequuntur perferendis repellat, quaerat iste exercitationem
				libero, rerum quidem quas commodi ex eius ut accusamus odit harum reprehenderit
				earum laboriosam tempore necessitatibus voluptates! Modi enim quasi at hic
				aliquam dolore voluptatibus repellat rem recusandae molestiae asperiores debitis
				totam ipsa, nam id. Eveniet fuga iusto vero provident eaque eos perspiciatis
				sequi non nulla repellendus sint obcaecati, nisi similique nihil quas
				voluptatibus soluta beatae eius debitis corporis repudiandae, harum excepturi
				illo ullam. Labore, nemo provident! Sed atque dolores temporibus enim libero
				fugit, dolore ullam voluptatem deserunt aliquid minus facilis odit nam magnam
				vero, impedit, iure nulla voluptatibus maxime totam labore asperiores animi!
				Consequuntur deserunt itaque accusamus maiores. Quod earum eligendi quo, maxime
				dolore sequi aliquam sint eius nostrum amet voluptatem, est aspernatur quisquam
				quas fugiat fugit tempore modi alias nihil illum nulla. Quam animi officia
				aliquam consectetur ab rem illum nisi praesentium voluptates architecto autem,
				ratione quis dolor veniam maiores quidem natus nemo! Consectetur eveniet sint
				aspernatur illo porro cumque nisi officiis, amet, explicabo esse perferendis
				quam totam, ex et. Facilis laborum voluptatibus veritatis molestias ullam.
				Repellendus sunt beatae mollitia provident architecto. Natus atque repellendus
				corrupti odio, alias, ullam soluta voluptates, sunt itaque numquam facilis culpa
				molestiae ut aut sed cum quidem minus fugit reiciendis! Asperiores a ratione
				optio, culpa mollitia aspernatur exercitationem similique, totam quas et amet
				aut doloribus rem? Itaque quidem nam eligendi quas, maxime assumenda! Sapiente,
				quibusdam. Minima exercitationem aperiam iste distinctio. Recusandae, doloribus
				fuga esse in dolorum aliquam distinctio animi dicta. Quibusdam, praesentium!
			</p>
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
					légales</a> |
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