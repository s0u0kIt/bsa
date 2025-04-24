<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Page de connexion</title>
  <link rel="stylesheet" href="/public/css/app.css">
</head>

<body class="bg-gray-900 text-white min-h-screen flex items-center justify-center">
  <div class="w-full max-w-md bg-gray-800 p-8 rounded-lg shadow-md">
    <h1 class="text-2xl font-bold text-center mb-6">Se connecter</h1>
    <form action="/home" method="GET" class="space-y-4">
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
      <div class="flex items-center justify-between">
        <label class="flex items-center text-sm">
          <input type="checkbox"
            class="h-4 w-4 text-indigo-600 bg-gray-700 rounded border-gray-600 focus:ring-indigo-500">
          <span class="ml-2">Se souvenir de moi</span>
        </label>
        <a href="/home" class="text-indigo-400 text-sm hover:underline">Mot de passe oublié ?</a>
      </div>
      <button type="submit"
        class="w-full mt-4 py-2 bg-indigo-600 hover:bg-indigo-700 rounded-lg font-semibold text-white transition duration-200">
        Se connecter
      </button>
    </form>
  </div>
</body>

</html>