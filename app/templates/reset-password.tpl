<!DOCTYPE html>
<html lang="fr">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BSA | Réinitialisation</title>
  <link rel="stylesheet" href="/public/css/app.css" />
  <script src="https://www.google.com/recaptcha/api.js" async defer></script>
</head>

<body class="flex flex-col items-center h-screen bg-white">

  <!-- HEADER BANNER FOR LOGO -->
  <header class="w-full h-fit flex justify-center border-b border-gray-300 shadow-md">
    <img class="h-20" src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmbtLpeNT9LKw5v1M9yODfmXnfot4eWKlwQA&s"
      alt="Logo" />
  </header>

  <!-- LOGIN FORM -->
  <div class="flex flex-col w-full max-w-md bg-gray-50 p-8 mt-8 rounded-lg border border-gray-300 shadow-md">
    <h1 class="text-2xl font-bold text-center mb-2 text-gray-800">Réinitialisation</h1>
    {if isset($reset)}
      <p class="text-sm text-center mb-4">Votre mot de passe a bien été réinitialisé</p>
      <a href="/connexion"
        class="mt-4 py-2 px-2 bg-green-200 rounded-lg font-semibold text-black transition duration-200 text-center">
        Connexion
      </a>
    {else}
      <p class="text-sm text-center mb-4">Entrez votre email et votre nouveau mot de passe</p>
      <form action="/reinitialisation" method="POST" class="space-y-4">
        <div>
          <label for="login" class="block text-sm font-medium text-gray-700">Email</label>
          <input type="email" id="login" name="login"
            class="w-full mt-1 px-4 py-2 bg-white text-gray-900 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-400 focus:outline-none"
            required>
        </div>

        <div>
          <label for="password" class="block text-sm font-medium text-gray-700">Nouveau mot de passe :</label>
          <input type="text" id="password" name="password"
            class="w-full mt-1 px-4 py-2 bg-white text-gray-900 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-400 focus:outline-none"
            required>
        </div>

        {if isset($token)}
          <input type="text" name="token" value="{$token}" id="password" hidden></input>
        {/if}

        <button type="submit" id="submitButton"
          class="w-full mt-4 py-2 bg-blue-200 hover:bg-blue-300 rounded-lg font-semibold text-black transition duration-200">
          Réinitialiser le mot de passe
        </button>
      {/if}
      {if isset($message)}
        <p class="text-sm text-center mb-6 text-red-600">{$message|escape}</p>
      {/if}
    </form>
  </div>
</body>

</html>