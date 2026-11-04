# AGENTS.md

Conventions pour les agents IA travaillant sur ce dépôt.

## Langue et tournures

Rédige tout en français : commentaires du code, messages de commit, documentation (README, `.md`) et tes réponses à l'utilisateur.
Les identifiants techniques existants (noms de variables, méthodes, fichiers) restent en anglais.

Sois concis dans tes réponses. Ne m'encourage pas. Ne me dis pas que j'ai des bonnes idées. Je n'ai pas besoin d’être rassuré·e

## Linting

Avant d'écrire du Ruby ou du Slim, lis la config du linter concerné (`.rubocop.yml` pour les conventions Ruby ; les règles slim-lint) afin que tes changements respectent les conventions existantes.

- **Ruby (RuboCop) :** `bundle exec rubocop` — ou `bin/rubocop` (via Spring, préfixe automatiquement `.rubocop.yml`). Utilise les plugins `rubocop-rspec` et `rubocop-rails` ; la version Ruby cible est définie par `TargetRubyVersion` dans `.rubocop.yml`. Sur des chemins précis : `bundle exec rubocop <chemins>`.
- **Templates Slim :** `bundle exec slim-lint <fichiers>`. Uniquement sur les templates modifiés, ex. `bundle exec slim-lint app/views/path/to/_partial.html.slim`.
- **Scan de sécurité :** `bundle exec brakeman` (ou `bin/brakeman`).

### Style Slim

Dans les templates Slim, le contenu textuel d'une balise va sur une ligne à part, bien identifiable, pas sur la même ligne que la balise :

```slim
h1.card-title
  | Changer d’adresse email
```

plutôt que `h1.card-title Changer d’adresse email`. Une phrase par ligne.

Attention : deux lignes `|` consécutives dans le même paragraphe ne sont **pas** séparées par un espace au rendu (`|` ne rajoute aucun espace). Utilise `|>` sur toutes les lignes sauf la dernière du paragraphe pour obtenir l'espace attendu entre les phrases :

```slim
p
  |> Renseignez votre nouvelle adresse email.
  | Un code de confirmation à 6 chiffres vous sera envoyé à cette adresse.
```

### DSFR uniquement, jamais Bootstrap

Dans les vues, n'utilise jamais de classes Bootstrap comme `.card`,  `.row`, `.col-*`, etc…
Utilise exclusivement le [DSFR](https://www.systeme-de-design.gouv.fr/) : classes `fr-*` (ex. `fr-container`, `fr-mt-1w`) et les form builders dédiés (`Dsfr::FormBuilder`).
Si une vue existante contient encore des classes Bootstrap, ne les reproduis pas dans du code nouveau — utilise l'équivalent DSFR.

## Specs

- **RSpec :** `bundle exec rspec <chemins>` — ou `bin/rspec` (via Spring). Cible des fichiers/dossiers précis : `bundle exec rspec spec/features/users/online_booking/`.
- Les specs de feature utilisent Capybara avec le driver Playwright pour les exemples `js: true` ; les factories viennent de `factory_bot`.
- Pour tester ce qu'une page affiche ou non (présence/absence d'un bloc, d'un lien), écris plutôt une feature spec sans JS (driver rack_test par défaut) qu'une request spec.
- Pour les flux online-booking/ANTS nécessitant l'API ANTS externe, stubbe-la avec `stub_ants_status_ok(...)` (voir les specs existantes).
- WebMock ne voit pas les requêtes faites par le navigateur (`fetch` JS).
  Dans une spec `js: true`, intercepte-les avec Playwright.
  Pour l'autocomplétion d'adresse (API Base Adresse Nationale), utilise le helper
  `stub_base_adresse_nationale_autocomplete_request` (voir `spec/support/base_adresse_nationale_stubs.rb`,
  options `results:` (`"16_quai_de_la_loire"` par défaut, ou `[]`), `sleep:` et `abort:` ; le comptage
  de requêtes reste inline, exemple dans `spec/features/agents/address_autocomplete_spec.rb`).
  N'ajoute pas de header `Access-Control-Allow-Origin` : Playwright l'ajoute déjà, et le doublon fait échouer le `fetch`.
- Playwright (`yarn run playwright install chromium`) est requis même pour les specs non-JS : un hook `before(:suite)` de `spec/support/capybara_config.rb` refuse de démarrer sinon.
- Les specs `js: true` servent `app/assets/builds` : relance `yarn build` après toute modification JS.
  Dans un worktree git, `node_modules` n'est pas partagé : lance `yarn install` puis `yarn build` dans le worktree.
- `database.yml` impose la locale `en_US.UTF-8` : elle doit être générée sur le système, sinon `db:create` échoue.
- Ne lance pas de grosses suites de specs en local, en particulier les specs e2e (`spec/features/**`, `js: true`), qui sont lentes.
  Lance seulement la nouvelle spec et 1 ou 2 fichiers de specs qui couvrent le code touché, avec `--fail-fast`.
  La CI fait tourner la suite complète.
- écris les context "", it "", les commentaires etc… en français, même si le fichier existant est en anglais
- limite autant que possible le niveau d'imbrication des context et describe, je pense que 2 niveaux c'est bien
- favorise la lisibilité des specs plutôt que la générisation. c'est ok de copier coller dans les specs. on veut pouvoir lire une spec indépendamment sans avoir à remonter trois niveaux de contexts.
- ne surcharge jamais un let défini un niveau plus haut. dans ce cas, déplace le let vers tous les contextes.

Lance toujours les linters et specs pertinents après un changement non trivial avant de considérer la tâche terminée.

## Seeds

- Les seeds ne sont pas transactionnels : un échec laisse la base partiellement remplie, réinitialise-la entre deux essais.
- Teste sur une base jetable : `RAILS_ENV=test DATABASE_URL="postgres:///lapin_seed_check?host=/tmp" DB_SEEDS_USERS_AND_AGENTS_PASSWORD="Motdepasse1234!" bundle exec rails runner 'load Rails.root.join("db/seeds/medico_social.rb")'` (le mot de passe doit contenir une majuscule).
- Faker est dans le groupe `:test` du Gemfile : indisponible au runtime des seeds.
  Les noms réalistes sont figés dans la liste `noms_usagers` (`db/seeds/medico_social.rb`), à compléter à la main (diversité des origines, noms composés avec tirets ou espaces).
- Emails de démo : `<initiale><nom>@<acronyme_du_service>.rdv.fr` — le domaine `.rdv.fr` n'existe pas, aucun envoi accidentel possible depuis une base de démo.
  Utilise `.parameterize.tr("-", "")` et vérifie l'unicité des adresses générées.
- Reste déterministe : `Random.new(42)` et `sample(random:)`, jamais de `sample` nu ; les RDVs sont posés sur des jours ouvrés.
- Ne renomme pas les variables existantes (ex. `user_org_paris_nord_patricia`) ; si un nom manque de réalisme, change seulement le nom de famille.

## Sécurité

Le plus important lorsque tu proposes des fonctionnalités est de réfléchir aux enjeux de sécurité.
Les changements de permissions ou l'exposition involontaire de données qui ne l'étaient pas jusqu'ici sont à éviter ou alors à indiquer clairement dans les descriptions de PR.

# Qualité

Propose des changements minimaux. Évite autant que possible les PR de plusieurs centaines de lignes.

Avant d'introduire une nouvelle table/modèle pour une fonctionnalité, vérifie si un mécanisme existant du dépôt ne peut pas être réutilisé tel quel (ex. un système de code de vérification par email déjà en place). La réutilisation directe, quand elle est possible sans migration, est presque toujours préférable à une table dédiée même plus « propre » sur le papier — compare concrètement les deux (diff, tests) plutôt que trancher sur la seule théorie.

Quand un parcours a plusieurs étapes qui ne correspondent pas à un vrai CRUD sur une seule ressource (ex. « demander un code » puis « saisir le code »), préfère plusieurs controllers avec des actions `new`/`create` par étape plutôt que de forcer `edit`/`update` sur une étape qui ne modifie rien. Regarde s'il existe déjà un patron similaire dans le dépôt (ex. `LoginCodesController` / `SessionsByCodeController`) et aligne-toi dessus.

Lorsque tu rédiges des PR sois succinct et utilise ce pattern : `# Contexte ... # Solution ... # Captures d'écran`

Indique bien clairement comment reproduire le problème manuellement si c'est un bug que tu corriges.

Pour les captures d'écran d'un changement d'état (avant/après une mise à jour), fais en sorte que l'état pertinent (ex. l'ancienne et la nouvelle valeur) soit visible directement dans l'écran capturé, pas seulement dans la légende de la capture.

### Messages de commit et de PR

Pas de mention du type `Co-Authored-By` dans les commit messages, pas de lien de session, aucune référence à un assistant IA

#### Découpage pour relecture

Applique ce mode seulement si je le demande.
En phase de plan, tu peux me le suggérer si la PR contient plusieurs ajouts distincts.

- d'abord les commits strictement nécessaires (préparation, changement minimal et sa spec principale) ;
- puis un commit par ajout au-delà (robustesse, fonctionnalité bonus, spec supplémentaire), même petit ;
- un commit intermédiaire peut ne pas passer les specs, le but est la relecture.

Avant de découper, relis le diff et retire ce qui n'est pas nécessaire : code mort, redondances, CSS cosmétique, événements que personne n'écoute.
Replie les correctifs dans le commit concerné avec `git commit --fixup` puis `GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash origin/production`.

## Relecture locale avec diffle

La relecture se fait avec [diffle](https://github.com/moritzwilksch/diffle), les commentaires vivent dans `.git/diffle/comments.json` (threads par commit, réponses dans `messages[]`).

- Pour revoir une branche : `diffle origin/production` (branche courante vs son point de bifurcation sur production).
- Si je te demande de surveiller et traiter les commentaires : relis le fichier juste avant d'écrire, ajoute un message `{id, body, createdAt, updatedAt}` dans `messages[]` du thread, ne touche ni aux messages existants ni à `resolved`.
- diffle tourne pendant que tu écris : une écriture externe peut être écrasée par sa sauvegarde suivante (et inversement). Relis et remerge plutôt que d'écraser, et signale-moi si une réponse disparaît.
- Un rebase change les shas : les threads ancrés sur les anciens shas deviennent stale, préviens-le.
- Le watcher échoue (UNKNOWN) sur les fichiers non réguliers non git-ignorés, ex sockets : git-ignore-les (`.overmind.sock` l'est).

## Code style

- utilise la syntaxe ruby method(some_kwarg:) où tu ne répètes pas some_kwarg si c'est le même nom de variable
- n'ajoute des commentaires que si c'est vraiment pertinent et difficile à comprendre sans : le code simple et lisible n'a pas besoin d'être expliqué
- ne crée pas de méthode partagée (dans un modèle ou ailleurs) pour mutualiser de la logique temporaire, ex. entre un script et une migration : dupliquer le code est plus lisible et plus simple à supprimer. Ne sois pas DRY à tout prix

## Markdown

Reviens à la ligne à chaque phrase. Ça aide à la relecture en cas de diff.

### Environnement de travail

## Plans

Stocke les plans au format markdown dans ./plans (listé dans .git/info/exclude)
Ne supprime jamais un plan que tu n'as pas écrit dans la session courante

## VM devbox Lima

tu es très probablement dans une VM lima qui tourne sur la machine du développeur. Le repo est monté en RW. Tu peux faire ce que tu veux dans cette VM, c'est bien isolé en termes de sécurité.

### Lancer les specs dans la VM

Postgres et Redis sont installés via `mise` mais rien ne les démarre.
Les shims `mise` de postgres échouent hors d'un dossier qui l'épingle (« No version is set for shim ») : appelle les binaires par chemin absolu, sans glob (plusieurs versions coexistent).

```sh
PG=~/.local/share/mise/installs/postgres/18.6/bin
# /tmp/pgdata disparaît au redémarrage : le recréer si besoin
$PG/initdb -D /tmp/pgdata -U $(whoami)
$PG/pg_ctl -D /tmp/pgdata -o "-k /tmp" -l /tmp/pg.log start -w
# --save "" --appendonly no : sinon Redis écrit un dump.rdb dans le dossier courant
~/.local/share/mise/installs/redis/8.10.1/bin/redis-server --daemonize yes --save "" --appendonly no
RAILS_ENV=test bin/rails db:create db:schema:load
```

Si `db:create` échoue avec `invalid locale name "en_US.UTF-8"` : décommente `en_US.UTF-8 UTF-8` dans `/etc/locale.gen`, lance `sudo locale-gen`, puis redémarre Postgres (`$PG/pg_ctl -D /tmp/pgdata restart -w`).
Un `dump.rdb` déjà présent à la racine du dépôt est sans valeur, supprime-le.
La base `lapin_test` est partagée entre worktrees.

Premier lancement :

```sh
mise trust && bundle install
corepack enable && mise reshim
COREPACK_ENABLE_DOWNLOAD_PROMPT=0 corepack yarn install --immutable
corepack yarn run playwright install chromium --with-deps
```

Dans un conteneur Debian nu sans Postgres ni Redis via `mise`, installe-les avec `sudo apt-get install -y postgresql redis-server locales`, démarre-les avec `sudo service postgresql start` et `sudo service redis-server start` (pas de systemd), puis crée ton rôle avec `sudo -u postgres createuser --superuser $(whoami)`.

### Captures d’écran en local

Avant toute capture d’écran destinée au dépôt (page vitrine, documentation, README), masque les trois éléments propres à l’environnement local : le bandeau rouge du nom d’instance, le compteur de temps de chargement de rack-mini-profiler, et la bannière bleue « Besoin d’aide pour bien démarrer ».

Avec Playwright, injecte ce script d’initialisation dans le contexte du navigateur (il survit aux navigations) :

```js
await context.addInitScript(() => {
  const style = document.createElement("style");
  style.textContent = ".rdv-solidarites-instance-name-wrapper, .profiler-results, .fr-notice--info { display: none !important; }";
  document.addEventListener("DOMContentLoaded", () => document.head.appendChild(style));
});
```

Les captures de la page fonctionnalités sont en 16:9 (viewport 1440×810, `deviceScaleFactor: 2`), converties en webp avec `cwebp -q 85`.

La génération des captures de la page fonctionnalités est automatisée par `scripts/devtools/capture_page_fonctionnalites.cjs` (à lancer avec `node`), qui crée d'abord les données de démo manquantes via `scripts/devtools/setup_capture_fonctionnalites.rb` (RDV collectif, invitation) et incruste les captures mobiles sur un fond neutre 16:9 pour éviter tout étirement.
