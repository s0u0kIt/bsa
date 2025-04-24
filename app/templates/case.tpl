<!DOCTYPE html>
<html lang="fr">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>BSA | Dossiers</title>
  <link rel="stylesheet" href="/public/css/app.css" />
  <link rel="stylesheet" href="/public/css/case.css" />
  <link rel="stylesheet" href="/public/css/case.css" />
  <link rel="stylesheet" href="/public/css/editor.css" />
  <link href="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.snow.css" rel="stylesheet" />
  <script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/docx@9.1.1/dist/index.iife.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.2/html2pdf.bundle.min.js"></script>
  <script src="/public/js/editor.js"></script>
  <script src="/public/js/report.js"></script>
  <script src="/public/js/case.js"></script>
  <script src="/public/js/loading-screen.js"></script>
  <script src="/public/js/notification-popup.js"></script>
  <script src="/public/js/mobile-menu.js"></script>
</head>

<body class="flex flex-col items-center h-screen relative">
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
            alt="Logo de la DSFE" />
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
        <a href="/app" class="h-full hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Tableau de bord</a>
        <a href="#"
          class="h-full border-b-2 border-blue-400 hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Gestion
          des dossiers</a>
        <a href="/app/agents" class="h-full hover:border-b-2 hover:border-blue-400 px-4 py-2 transition">Gestion des
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
        class="hidden md:hidden absolute top-12 right-0 w-full bg-white shadow-lg p-4 space-y-2 z-20">
        <a href="/app" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Tableau de bord</a>
        <a href="#" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Gestion des dossiers</a>
        <a href="/app/agents" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Gestion des agents</a>
        <a href="/app/carte" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Carte</a>
        <a href="/app/statistiques" class="block px-4 py-2 text-gray-700 hover:bg-gray-100 rounded">Statistiques</a>
      </div>
    </nav>
  </header>

  <!-- MAIN CONTENT OR APP -->
  <main class="w-full h-full overflow-y-hidden relative flex flex-col space-y-4">
    <!-- LOADING SCREEN -->
    <div id="loadingScreen" class="absolute inset-0 bg-gray-600 bg-opacity-50 flex items-center justify-center z-10">
      <div class="flex items-center justify-center">
        <!-- Cercle animé -->
        <div class="w-16 h-16 border-4 border-t-4 border-gray-200 border-t-gray-600 rounded-full animate-spin"></div>
      </div>
    </div>

    <!-- DATA FORM MODAL (HIDDEN BY DEFAULT)-->
    <dialog id="dataModal"
      class="relative overflow-y-scroll p-6 bg-white rounded-lg shadow-lg overflow-hidden w-fit border border-gray-300 self-center">

      <!-- CLOSE BUTTON -->
      <button type="button" onclick="caseClass.toggleDataModal()"
        class="fixed top-4 right-4 text-red-600 hover:text-red-800 p-2 rounded-full bg-white shadow-md border border-gray-300">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="w-6 h-6">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>

      <h2 id="dataModalTitle" class="text-2xl font-semibold text-gray-900 mb-4">
        Créer un nouveau dossier
      </h2>
      <p id="dataModalDescription" class="text-sm text-gray-600 mb-6">
        Remplissez les informations ci-dessous pour créer un dossier.
      </p>
      <form id="dataForm" class="flex flex-col" onsubmit="caseClass.saveData(event)">
        <div class="h-full w-full flex flex-col md:flex-row">
          <!-- LEFT SECTION -->
          <div class="w-full md:w-fit flex flex-wrap gap-y-4">
            <!-- Input fields (unchanged) -->
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataId" class="block text-sm font-medium text-gray-900 mb-1">N° Dossier :</label>
              <input type="number" id="dataId" name="id" disabled
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required />
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataResidence" class="block text-sm font-medium text-gray-900 mb-1">Lieu de résidence<span
                  class="text-red-500">*</span>
                :</label>
              <select required id="dataResidence" name="residence"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50">
                <option value="" selected="selected" disabled>Sélectionnez un lieu de résidence</option>
                <option class="text-red-600" value="A la rue">À la rue</option>
                <option class="text-green-700" value="Famille d'accueil - Unité de vie">Famille d'accueil - Unité de vie
                </option>
                <option class="text-blue-700" value="Hébergement associatif">Hébergement associatif</option>
                <option value="Autre">Autre</option>
              </select>
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataDateCreation" class="block text-sm font-medium text-gray-900 mb-1">Date de dossier
                :</label>
              <input type="date" id="dataDateCreation" name="dateCreation"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" disabled />
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataLastName" class="block text-sm font-medium text-gray-900 mb-1">Nom<span
                  class="text-red-500">*</span> :</label>
              <input type="text" id="dataLastName" name="lastname"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required />
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataFirstName" class="block text-sm font-medium text-gray-900 mb-1">Prénom<span
                  class="text-red-500">*</span> :</label>
              <input type="text" id="dataFirstName" name="firstname"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required />
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataBorn" class="block text-sm font-medium text-gray-900 mb-1">Date de Naissance :</label>
              <input type="date" id="dataBorn" name="born"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" />
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataDn" class="block text-sm font-medium text-gray-900 mb-1">DN :</label>
              <input type="number" id="dataDn" name="dn"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" />
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataGenre" class="block text-sm font-medium text-gray-900 mb-1">Genre :</label>
              <select id="dataGenre" name="genre"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50">
                <option value="" selected="selected" disabled>Sélectionnez un genre</option>
                <option value="Homme">Homme</option>
                <option value="Femme">Femme</option>
                <option value="Autre">Autre</option>
              </select>
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataAct" class="block text-sm font-medium text-gray-900 mb-1">Activité :</label>
              <select id="dataAct" name="activity"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50">
                <option value="" selected="selected" disabled>Sélectionnez un type d'activité</option>
                <option value="Mesure d'aide SEFI">Mesure d'aide SEFI</option>
                <option value="CDD">CDD</option>
                <option value="Intérim">Intérim</option>
                <option value="Formation">Formation</option>
                <option value="CDI">CDI</option>
                <option value="SITH">SITH</option>
                <option value="Extra">Extra</option>
                <option value="Saisonnier">Saisonnier</option>
                <option value="Non-déclaré">Non-déclaré</option>
              </select>
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataEmail" class="block text-sm font-medium text-gray-900 mb-1">Mail :</label>
              <input type="email" id="dataEmail" name="mail"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" />
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataPhone" class="block text-sm font-medium text-gray-900 mb-1">N° de Téléphone :</label>
              <input type="text" id="dataPhone" name="phone"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" />
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataChild" class="block text-sm font-medium text-gray-900 mb-1">Nombre d'enfant(s) à charge
                :</label>
              <input type="number" id="dataChild" name="child"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" />
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataTypo" class="block text-sm font-medium text-gray-900 mb-1">Typologie :</label>
              <select id="dataTypo" name="typology"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50">
                <option value="" selected="selected" disabled>Sélectionnez une typologie</option>
                <option value="Originaire des îles pour parcours de soins">Originaire des îles pour parcours de soins
                </option>
                <option value="Originaire des îles pour recherche ou prise d'emploi">Originaire des îles pour recherche ou prise d'emploi</option>
                <option value="Originaire des îles pour poursuite d'études">Originaire des îles pour poursuite d'études</option>
                <option value="Fa'amu">Fa'amu</option>
                <option value="Recomposition familiale contraignante">Recomposition familiale contraignante</option>
                <option value="Troubles psychiques">Troubles psychiques</option>
                <option value="Personne âgée">Personne âgée</option>
                <option value="Violences intra-familiales">Violences intra-familiales</option>
                <option value="Famille nombreuse, pressions et promiscuité">Famille nombreuse, pressions et promiscuité
                </option>
                <option value="Sortant de prison">Sortant de prison</option>
                <option value="Eu(e) recourt à une mesure d'assistance éducative">Eu(e) recourt à une mesure
                  d'assistance
                  éducative</option>
                <option value="Mineur(euse) sortant d'établissement socio-éducatif">Mineur(euse) sortant d'établissement
                  socio-éducatif</option>
                <option value="Autre">Autre</option>
              </select>
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataIdTuteur" class="block text-sm font-medium text-gray-900 mb-1">Service utilisateur
                :</label>
              <select disabled id="dataIdTuteur" name="idTuteur"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50">
                <option value="" selected="selected" disabled>Sélectionnez un utilisateur</option>
                {if isset($tutors)}
                  {foreach from=$tutors item=$tutor}
                    <option value="{$tutor.idTuteur}">{$tutor.nom} {$tutor.prenom}</option>
                  {/foreach}
                {/if}
              </select>
            </div>
            <div class="w-full md:w-1/2 md:px-2">
              <label for="dataIdIle" class="block text-sm font-medium text-gray-900 mb-1">Île<span
                  class="text-red-500">*</span> :</label>
              <select id="dataIdIle" name="idIle"
                class="w-full p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50" required>
                <option value="" selected="selected" disabled>Sélectionnez une île</option>
                {if isset($archipelagos)}
                  {foreach from=$archipelagos item=$archipelago}
                    <optgroup label="{$archipelago.lib}">
                      {if isset($isles)}
                        {foreach from=$isles item=$isle}
                          {if ($isle.idParent == $archipelago.idZone)}
                            <option value="{$isle.idZone|escape}">{$isle.lib|escape}</option>
                          {/if}
                        {/foreach}
                      </optgroup>
                    {/if}
                  {/foreach}
                {/if}
              </select>
            </div>
          </div>

          <!-- REPORTS SECTION -->
          <div id="reportSection" class="h-full w-full md:w-2/3 mt-4 md:mt-0 flex flex-col">
            <!-- NEW REPORT INPUT -->
            <div class="flex flex-col gap-y-2 w-full md:px-2">
              <div class="text-left text-sm text-gray-600 mt-1">
                <label for="dataIdIle" class="block text-sm font-medium text-gray-900 mb-1">Commentaire :</label>
                <span id="charCount">0</span> / 1000 caratères (12 lignes max.)
              </div>
              <textarea id="dataReport" name="report"
                class="w-full h-32 p-3 text-sm text-gray-800 border border-gray-300 rounded-lg bg-gray-50 resize-none"
                rows="6" maxlength="1000" oninput="caseClass.updateCharCount()"
                placeholder="Écrivez un nouveau rapport ici..."></textarea>
              <button id="submitReportButton" type="button" onclick="caseClass.addReport()"
                class="mb-4 w-fit h-fit px-4 py-2 text-sm font-medium bg-blue-50 rounded-lg hover:bg-blue-100 border border-gray-300">
                Envoyer
              </button>
              <div class="w-full flex flex-col items-start gap-y-1">
                <button id="downloadReportButton" type="button" class="text-sm rounded gap-x-1"
                  onclick="editorClass.toggleModal()">
                  <img src="https://www.svgrepo.com/download/304506/edit-pen.svg" alt="edit-pen" width="20" height="20">
                  <span>Voir plus</span>
                </button>

                <!-- REPORTS VIEWER -->
                <div id="reportsViewer"
                  class="relative hidden md:flex flex-col w-full h-80 p-3 text-sm text-gray-900 border border-gray-300 rounded-lg bg-gray-50 overflow-y-scroll">
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="w-full h-fit flex justify-end items-center gap-x-3 gap-y-3 mt-4 flex-wrap">
          <button type="button"
            class="h-fit px-4 py-2 text-sm font-medium bg-gray-200 rounded-lg hover:bg-gray-300 border border-gray-300"
            onclick="caseClass.toggleDataModal()">
            Annuler
          </button>
          <button id="clearCaseModalButton" type="button"
            class="h-fit px-4 py-2 text-sm font-medium bg-red-200 rounded-lg hover:bg-red-300 border border-gray-300"
            onclick="caseClass.clearDataModal()">
            Réinitialiser
          </button>
          <button id="deleteDataButton" type="button"
            class="h-fit px-4 py-2 text-sm font-medium bg-red-200 rounded-lg hover:bg-red-300 border border-gray-300"
            onclick="caseClass.deleteData()" hidden>
            Supprimer
          </button>
          <button id="submitDataButton" type="submit"
            class="h-fit px-4 py-2 text-sm font-medium bg-blue-200 rounded-lg hover:bg-blue-300 border border-gray-300">
            Ajouter
          </button>
        </div>
      </form>
    </dialog>

    <!-- QUILL EDITOR -->
    <dialog id="editorModal"
      class="relative h-fit w-full p-6 bg-white rounded-lg shadow-lg overflow-hidden border border-gray-300 self-center">
      <!-- CLOSE BUTTON -->
      <button type="button" onclick="editorClass.toggleModalVisibility()"
        class="fixed right-14 text-red-600 hover:text-red-800 p-2 rounded-full bg-white border border-gray-300">
        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" class="w-6 h-6">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
      <div id="reportsEditor" class="h-fit">
      </div>

      <span class="text-sm">Télécharger :</span>
      <button class="mt-2 px-2 py-1 text-sm font-medium bg-red-200 rounded-lg hover:bg-red-300 border border-gray-300"
        onclick="editorClass.downloadAsPDF()">
        PDF
      </button>
      <button class="mt-2 px-2 py-1 text-sm font-medium bg-blue-200 rounded-lg hover:bg-blue-300 border border-gray-300"
        onclick="editorClass.downloadAsWord()">
        DOCX
      </button>
      <button
        class="ml-6 mt-2 px-2 py-1 text-sm font-medium bg-gray-200 rounded-lg hover:bg-gray-300 border border-gray-300"
        onclick="editorClass.toggleModalVisibility()">
        Annuler
      </button>
    </dialog>

    <!-- TOOLBAR BUTTONS -->
    <div class="w-full px-8 flex items-center space-x-4">
      <button
        class="px-4 py-3 bg-gray-50 hover:bg-gray-100 border border-gray-300 rounded-lg font-semibold transition w-fit"
        onclick="caseClass.toggleDataModal()">
        Ajouter
      </button>
    </div>

    <!-- SEARCH BAR -->
    <form class="w-full flex place-content-around mx-auto">
      <div class="w-full mx-8 flex border border-gray-300 rounded-lg bg-gray-50">
        <div class="mx-3 w-5 flex items-center justify-center pointer-events-none">
          <svg class="w-full text-gray-500" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none"
            viewBox="0 0 20 20">
            <path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
              d="m19 19-4-4m0-7A7 7 0 1 1 1 8a7 7 0 0 1 14 0Z" />
          </svg>
        </div>
        <input type="text" id="searchData" oninput="caseClass.filterData(event)"
          class="w-full m-1 p-2 text-sm text-gray-900 bg-gray-50 focus:outline-none focus:bg-gray-100"
          placeholder="Rechercher un dossier" required />
      </div>
    </form>

    <!-- DATA TABLE -->
    <div class="w-full h-full overflow-x-auto overflow-y-scroll px-4 md:px-8">
      <table id="dataTable" class="w-full text-sm text-left text-gray-500 border border-gray-300">
        <thead class="font-normal text-gray-600 uppercase bg-gray-50">
          <tr>
            <th scope="col" class="px-2 py-3">N° Dossier</th>
            <th scope="col" class="px-2 py-3">Date de dossier</th>
            <th scope="col" class="px-2 py-3">Nom</th>
            <th scope="col" class="px-2 py-3">Prénom</th>
            <th scope="col" class="px-2 py-3 hidden sm:table-cell">Date de naissance</th>
            <th scope="col" class="px-2 py-3">DN</th>
            <th scope="col" class="px-2 py-3">N° de téléphone</th>
            <th scope="col" class="px-2 py-3 hidden md:table-cell">Email</th>
          </tr>
        </thead>
        <tbody>
          {foreach from=$cases item=$case}
            <tr onclick="caseClass.displayData(event)" class="odd:bg-white even:bg-gray-50 
                    {if ($case.residence == "A la rue")}border-2 border-red-300 
                    {else if ($case.residence == "Famille d'accueil - Unité de vie")}border-2 border-green-300 
                    {else if ($case.residence == "Hébergement associatif")}border-2 border-blue-300 
                    {else}border-b 
                    {/if}cursor-pointer">
            <th scope="row" class="px-2 py-3 font-medium text-gray-900 whitespace-nowrap thId">
              {$case.idPersonne}
            </th>
            <td class="px-2 py-3">
              <input type="date" value="{$case.dateCreation}" class="bg-transparent tdDateCreation" disabled />
            </td>
            <td class="px-2 py-3 tdLastName">{$case.nom|escape}</td>
            <td class="px-2 py-3 tdFirstName">{$case.prenom|escape}</td>
            <td class="px-2 py-3 hidden sm:table-cell">
              <input type="date" value="{$case.dateNaiss}" class="bg-transparent tdBorn" disabled />
            </td>
            <td class="px-2 py-3 tdResidence hidden">{$case.residence}</td>
            <td class="px-2 py-3 tdDn">{$case.dn}</td>
            <td class="px-2 py-3 tdGenre hidden">{$case.genre}</td>
            <td class="px-2 py-3 tdAct hidden">{$case.activite}</td>
            <td class="px-2 py-3 tdPhone">{$case.tel}</td>
            <td class="px-2 py-3 hidden md:table-cell tdEmail">{$case.email}</td>
            <td class="px-2 py-3 tdTypo hidden">{$case.typologie|escape}</td>
            <td class="px-2 py-3 tdChild hidden">{$case.nbEnfant}</td>
            <td class="px-2 py-3 tdIdTuteur hidden">{$case.idTuteur}</td>
            <td class="px-2 py-3 tdIdIle hidden">{$case.idIle}</td>
          </tr>
          {/foreach}
        </tbody>
      </table>
    </div>
  </main>

  <!-- FOOTER ONLY FOR CONTENT PAGES, NOT FULLSCREEN APPS -->
  <footer class="w-full text-gray-600 py-4 border-t border-gray-200">
    <div class="container mx-auto text-center">
      <p class="text-gray-600">&copy; 2025 DSFE (Direction des Solidarités de la Famille et de l'Égalité) - BSA
          (Bureau en charge des Sans-Abris) . Tous droits réservés.</p>
        <p class="text-gray-600">Site créé en 2025.</p>
        <p>
          <a href="/app/policies/legal-mentions" class="text-blue-400 hover:text-blue-600">Mentions
            légales</a> |
          <a href="/app/policies/general-conditions" class="text-blue-400 hover:text-blue-600">Conditions Générales
            d'utilisation</a> |
          <a href="/app/policies/privacy-policy" class="text-blue-400 hover:text-blue-600">Politique de
            Confidentialité</a>
        </p>
      </div>
    </footer>
  </body>

  </html>