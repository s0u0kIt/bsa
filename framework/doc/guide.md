# Guide d'Utilisation du Framework

## ⚙️ Prérequis
Avant de commencer, assurez-vous que votre environnement est configuré comme suit :

- **PHP** : Version **8.3** ou supérieure  
- **Extensions PHP requises** :  
  - `mbstring`  
  - `json`  
  - `pdo`  
- **Serveur Web** :  
  - Apache ou Nginx avec prise en charge des fichiers `.htaccess` (si applicable)  
- **Base de Données** :  
  - MySQL/MariaDB, PostgreSQL ou toute autre compatible avec votre projet  

---

## 📥 Installation

### Étapes à suivre :
1. **Télécharger le framework**  
   Placez tous les fichiers du framework dans le dossier racine de votre projet.  

2. **Créer un fichier d'entrée `index.php`**  
   Ajoutez cette ligne dans votre fichier `index.php` à la racine :  
   ```php
   <?php
   require 'framework/start.php';
   ```
   Ce fichier servira de point d'entrée pour votre application.

3. **Configurer les fichiers nécessaires**  
   Créez les fichiers suivants dans le dossier racine :  
   - `config.json`  
   - `routes.json`  
   - `namespaces.json`  
   Vous les remplirez plus tard avec les informations spécifiques à votre projet.

4. **Configurer Apache (si applicable)**  
   Créez un fichier `.htaccess` à la racine pour gérer la réécriture des URLs. Voir la section **Configuration** pour plus de détails.

---

## 🛠️ Configuration

### ✅ Redirection et Réécriture d'URL
Si vous utilisez Apache, vérifiez que le module `mod_rewrite` est activé.  
Vous pouvez l’activer en exécutant cette commande dans le terminal de votre serveur :

```bash
sudo a2enmod rewrite
sudo systemctl restart apache2
```

#### Exemple de Fichier `.htaccess`
Ajoutez ce contenu dans le fichier `.htaccess` situé à la racine de votre projet :  

```apache
# Activation du module rewrite
<IfModule mod_rewrite.c>
    RewriteEngine On

    # Ignorer les fichiers statiques (CSS, JS, images, polices, etc.)
    RewriteCond %{REQUEST_URI} !\.(css|gif|ico|jpg|js|png|swf|txt|svg|woff|ttf|eot)$

    # Rediriger tout vers index.php
    RewriteRule . index.php [L]
</IfModule>
```

---

### ⚡ Résumé
- Placez tous les fichiers du framework à la racine de votre projet.
- Configurez `index.php` pour inclure le fichier principal `start.php`.
- Ajoutez et remplissez les fichiers `config.json`, `routes.json`, et `namespaces.json`.
- Si vous utilisez Apache, assurez-vous que le fichier `.htaccess` est configuré correctement pour rediriger les requêtes vers `index.php`.

LES NAMESPACES Controllers et Middlewares doivent être mappés dans le PSR-4. De plus les contrôleurs et les middlewares doivent utiliser ces namespaces.
TOUS LES MIDDLEWARES DOIVENT IMPLEMENTER UNE METHODE handle() QUI SERA LE POINT D'ENTREE DE CELUI-CI.

L'EXTENSION PDO_MYSQL DOIT ETRE ACTIVEE SUR LE PHP DE VOTRE SERVEUR WEB POUR POUVOIR SE CONNECTER AUX BASES MYSQL.