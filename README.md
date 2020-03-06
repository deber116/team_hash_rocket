# Team Hash Rocket

A command line app for finding, catching, training and trading Pokemon.

![](https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/International_Pok%C3%A9mon_logo.svg/1200px-International_Pok%C3%A9mon_logo.svg.png)


### Install

---

Clone the repo.

```
$ git clone https://github.com/deber116/team_hash_rocket.git
```

Enter the project directory.

```
$ cd team_hash_rocket
```

Install the required gems.

```
$ bundle install
```

Make sure all database migrations are up.

```
$ rake db:migrate:status

database: db/development.db

 Status   Migration ID    Migration Name
--------------------------------------------------
   up     001             Create trainers
   up     002             Create pokemons
   up     003             Create trained pokemons
   up     004             Create types
   up     005             Add previous evolution id to pokemons
   up     006             Create moves
   up     007             Create pokemon moves
   up     008             Create trained pokemon moves
```


### Run

---

Start the CLI.

```
ruby bin/run.rb
```


### Troubleshooting

---

#### Database

The application is backed by a sqlite database: `db/development.db`. This should be pre-seeded with data upon cloning the repository. If it is not, you can create your own database (with seed data) by following these steps:

1. Create the database.
	
	```
	$ rake db:create
	Created database 'db/development.db'
	```

2. Migrate the database.

	```
	$ rake db:migrate
	== 1 CreateTrainers: migrating ================================================
-- create_table(:trainers)
   -> 0.0006s
== 1 CreateTrainers: migrated (0.0006s) =======================================
	...
	```
	
3. Confirm the migration was successful.

	```
	$ rake db:migrate:status
	
	database: db/development.db
	
	 Status   Migration ID    Migration Name
	--------------------------------------------------
	   up     001             Create trainers
	   up     002             Create pokemons
	   up     003             Create trained pokemons
	...
	```
	
4. Seed the database with data (this may take a number of minutes due to rate-limited API).

	```
	$ rake db:seed
	```
