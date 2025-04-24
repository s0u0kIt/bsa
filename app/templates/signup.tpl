<!DOCTYPE html>
<html lang="en">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Page d'inscription</title>
	<link rel="stylesheet" href="/public/css/app.css" />
</head>

<body class="bg-gray-900 text-white min-h-screen flex items-center justify-center">
	<div class="w-full max-w-md bg-gray-800 p-8 rounded-lg shadow-md">
		<h1 class="text-2xl font-bold text-center mb-6">S'inscrire</h1>
		<form action="" method="POST" class="space-y-4">
			<div>
				<label for="username" class="block text-sm font-medium">Nom d'utilisateur</label>
				<input type="text" id="username" name="username"
					class="w-full mt-1 px-4 py-2 bg-gray-700 text-white rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none"
					required>
			</div>
			<div>
				<label for="email" class="block text-sm font-medium">Email</label>
				<input type="email" id="email" name="email"
					class="w-full mt-1 px-4 py-2 bg-gray-700 text-white rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none"
					required>
			</div>
			<div>
				<label for="password" class="block text-sm font-medium">Mot de passe</label>
				<input type="password" id="password" name="password"
					class="w-full mt-1 px-4 py-2 bg-gray-700 text-white rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none"
					required>
			</div>
			<div>
				<label for="confirm-password" class="block text-sm font-medium">Confirmation du mot de passe</label>
				<input type="password" id="confirm-password" name="confirm_password"
					class="w-full mt-1 px-4 py-2 bg-gray-700 text-white rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none"
					required>
			</div>
			<button type="submit"
				class="w-full mt-4 py-2 bg-indigo-600 hover:bg-indigo-700 rounded-lg font-semibold text-white transition duration-200">
				S'inscrire
			</button>
		</form>
		<p class="text-sm text-center mt-4">
			Vous avez déjà un compte?
			<a href="/app/connexion" class="text-indigo-400 hover:underline">Se connecter</a>
		</p>
	</div>
</body>

</html>