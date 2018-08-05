# Secret Login User
En suivant ce README, vous allez pouvoir recreer une application qui geres les sessions utilisateurs par des logins et passwords. Rendez votre application et fonctionnalités disponibles que pour certains utilisateurs. Organiser votre base de donnée et à vous la gloire !


Commence par créer votre application rails grâce à la commande suivante : 
```sh
$ cd le_dossier_dans_lequel_tu_veux_creer_ton_app
$ rails new le_nom_trop_cool_de_ton_app
```
Puis ouvre ton app dans ton IDE préféré : 
```sh
$ atom le_nom_trop_cool_de_ton_app
$ cd le_nom_trop_cool_de_ton_app
```
Modifie le Gemfile, change cette ligne : 
```sh
8  # Use sqlite3 as the database for Active Record
9  gem 'sqlite3'
```
Par :  
```sh 
group :development, :test do
 gem 'sqlite3'
end

group :production do
  gem 'pg', '>= 0.18', '< 2.0'
end
```
Ensuite nous allons installer la gem bcrypt, elle te permettra de crypter les mots de passe de tes utilisateurs. 
Rend toi dans ton Gemfile et ajoute-y au début :
```sh
gem 'bcrypt'
```
Enfin, lance le bundle avec cette commande :
```sh
$ bundle install --without production
```
Nous allons ensuite créer une application Heroku : 

```sh
heroku create nom-de-ton-app-trop-cool
```
Dans ton terminal, tu devrais avoir quelque chose comme ça : 
```sh
Creating ⬢ solo-secret... done
https://solo-secret.herokuapp.com/ | https://git.heroku.com/solo-secret.git
```
Ton application est désormais en ligne.

À présent nous allons créer ton premier controlleur pour les pages statiques de ton site ainsi que les views correspondantes :
```sh
rails g controller static_pages home secret
```

Dans un autre terminal, lance ton serveur grâce à la commande : 
```sh 
Rails s
```
Et rends toi sur ton [Localhost:3000](http://localhost:3000) pour admirer le travail bien fait 

Grâce à cette commande tu va créer le systeme de CRUD ainsi que le model User associé avec des mots de passe sécurisés 
```sh
rails g scaffold User first_name:string last_name:string email:string
```
Afin d'avoir les validations nécéssaires pour tes utilisateurs, modifie ensuite ton model User comme ceci : 
```sh
require 'bcrypt'

class User < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, :on => :create
  validates :password_confirmation, presence: true, :on => :create
end
```

Ajoute ensuite le champs password_digest à ton model User
```sh
rails generate migration add_password_digest_to_users password_digest:string
```

Inscrit cette ligne dans ta migration : 
```sh
class AddPasswordDigestToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :password_digest, :string
  end
end
```
Puis créer une migration pour ajouter un champs de vérification de l'email dans ton model User : 
```sh
rails g migration AddRememberDigestToUsers
``` 
et voici comment doit être ta migration 
```sh
class AddRememberDigestToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :remember_digest, :string
  end
end
``` 

Enfin fait ta migration avec cette commande : 
```sh
rails db:migrate 
```
