<!DOCTYPE html>
<html lang="fr">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>BSA | Connexion</title>
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
    <h1 class="text-2xl font-bold text-center mb-6 text-gray-800">Connexion</h1>
    <form action="/authentification" method="POST" class="space-y-4">

      <div>
        <label for="login" class="block text-sm font-medium text-gray-700">Email</label>
        <input type="text" id="login" name="login"
          class="w-full mt-1 px-4 py-2 bg-white text-gray-900 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-400 focus:outline-none"
          required>
      </div>

      <div>
        <label for="password" class="block text-sm font-medium text-gray-700">Mot de passe</label>
        <input type="password" id="password" name="password"
          class="w-full mt-1 px-4 py-2 bg-white text-gray-900 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-400 focus:outline-none"
          required>
      </div>

      <a href="/mot-de-passe-oublie" class="text-sm text-blue-600 underline">Mot de passe oublié ?</a>

      <div class="flex items-center justify-between">
        <label class="flex items-center text-sm text-gray-700">
          <input type="checkbox" id="remember" name="remember"
            class="h-4 w-4 text-blue-600 bg-white border-gray-300 rounded focus:ring-blue-400">
          <span class="ml-2">Se souvenir de moi</span>
        </label>
      </div>

      <!-- reCAPTCHA -->
      <div class="g-recaptcha" data-sitekey="6LfvCs4qAAAAABjFDP2b5DcJuGmqn37qxMTQ2aW4"
        data-callback="enableSubmitButton">
      </div>
      <p id="recaptchaMessage" class="text-sm text-center text-gray-600 mt-2">
        ⚠️ Veuillez valider le reCAPTCHA pour pouvoir vous connecter.
      </p>

      <button disabled type="submit" id="submitButton"
        class="w-full mt-4 py-2 bg-gray-200 rounded-lg font-semibold text-black transition duration-200">
        Se connecter
      </button>
      {if isset($message)}
        <p class="text-sm text-center mb-6 text-red-600">{$message|escape}</p>
      {/if}
    </form>
  </div>

  <!-- SCRIPTS -->
  <script>
    function enableSubmitButton() {
      document.getElementById("submitButton").disabled = false;
      document.getElementById("submitButton").classList.remove("bg-gray-200");
      document.getElementById("submitButton").classList.add("bg-blue-200");
      document.getElementById("submitButton").classList.add("hover:bg-blue-300");
      document.getElementById("recaptchaMessage").style.display = "none";
    }
  </script>
</body>

</html>