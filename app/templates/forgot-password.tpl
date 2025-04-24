<!DOCTYPE html>
<html lang="fr">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BSA | Changement de mot de passe</title>
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
  <div class="w-full max-w-md bg-gray-50 p-8 mt-8 rounded-lg border border-gray-300 shadow-md">
    <h1 class="text-2xl font-bold text-center mb-2 text-gray-800">Changement de mot de passe</h1>
    <p class="text-sm text-center mb-4">Si votre email est valide, vous recevrez les étapes à suivre pour réinitialiser
      votre mot de passe dans votre boîte mail</p>
    <form action="/mot-de-passe-oublie" method="POST" class="space-y-4">
      {if isset($sent)}
        <button disabled type="submit"
          class="w-full mt-4 py-2 bg-green-300 rounded-lg font-semibold text-black transition duration-200">
          Email envoyé
        </button>
      {else}
        <div>
          <label for="login" class="block text-sm font-medium text-gray-700">Email</label>
          <input type="email" id="login" name="login"
            class="w-full mt-1 px-4 py-2 bg-white text-gray-900 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-400 focus:outline-none"
            required>
        </div>

        <button type="submit" id="submitButton"
          class="w-full mt-4 py-2 bg-blue-200 hover:bg-blue-300 rounded-lg font-semibold text-black transition duration-200">
          Envoyer un email
        </button>
      {/if}
    </form>
  </div>
</body>

</html>