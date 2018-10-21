## 3. Local development

### 3.1. Start your project

```shell
taito install     # Install linters and some libraries on host
taito start       # Start containers
taito init        # Initialize database with database tables and example data
taito open app    # Open application web user interface
taito info        # Show info required for signing in to the application
```

> Installation and starting up might take some time the first time, as libraries and Docker containers need to be downloaded first.

### 3.2. Make some changes

Make some changes to the implementation. The implementation should build automatically in the background and if build fails for some reason, you should see errors on your console. If you make changes to the GUI implementation, also the web interface should update automatically.

For now, you should commit all your changes to the dev branch as feature branches are introduced later. Remember to structure your git commit messages according to the [Conventional Commits](https://github.com/TaitoUnited/kubernetes-template#commit-messages) convention. Otherwise your commits will fail.

The following resources might be useful if you are not yet familiar with React or ES6/7:

* [ES6 for beginners](https://codeburst.io/es6-tutorial-for-beginners-5f3c4e7960be)
* [ES7: Async/Await](https://codeburst.io/javascript-es-2017-learn-async-await-by-example-48acc58bad65)
* [React: Getting Started](https://reactjs.org/docs/getting-started.html)
* [Egghead: React](https://egghead.io/browse/frameworks/react)
* [Redux](https://redux.js.org/)
* [redux-saga](https://redux-saga.js.org/docs/introduction/BeginnerTutorial.html)

### 3.3. Create a unit test

In the kubernetes-template unit tests are differentiated from integration and end-to-end tests by using `unit` as filename suffix instead of `test`. A unit test must work within boundaries of a single Docker container. That is, no database or external services involved. You can achieve this by [mocking](TODO-link).

```shell
TODO
taito unit:server mytest
```

> HINT: You should not test implementation. Instead, you should test behaviour of a public API that is designed not to change very often: public API of a class, module, library or service for example. This way you can make changes to the underlying implementation, and the existing unit tests protect you from breaking anything.

> HINT: Although browser tests cannot be considered as unit tests, you can execute also them with the *unit test* mechanism, if you like. You just have to mock the required APIs so that the whole test can be run within one container.

### 3.4. Create an integration test

```shell
TODO
taito test:server mytest
```

### 3.5. Create an end-to-end test

```shell
TODO
taito test:client mytest
```

### 3.6. Connect to the local database

```shell
taito db connect        # Connect to the local database
\dt                     # Show all database tables (postgres)
select * from posts;    # Show all posts
\?                      # Show help for backslash commands (postgres)
\q                      # Quit (postgres)
```

### 3.7. Add a new database table

Add a new database migration with the following commands. You can find example deploy, revert and verify scripts in the `database` directory.

```shell
taito db add -h                                         # Show help
taito db add: articles -n 'Add articles database table' # Add migration
EDIT database/deploy/articles.sql                       # Edit deploy script
EDIT database/revert/articles.sql                       # Edit revert script
EDIT database/verify/articles.sql                       # Edit verify script
taito init                                              # Deploy to local db
```

> See [Sqitch tutorial for PostgreSQL](https://metacpan.org/pod/sqitchtutorial) if you need further instructions.

### 3.8. Add a new database column without using migrations

Since we have not made a production release yet, it is ok to edit the existing sql scripts. However, after editing an existing sql script we need to reinitialize the database manually for each environment with the `taito init --clean` command.

```shell
EDIT database/deploy/posts.sql  # Add a new column to posts.sql
taito init --clean              # Reinitialize local db
** Use the new column in server and client implementation **
taito init:dev --clean          # Reinitialize dev before pushing changes to dev
taito init:ENV --clean          # Reinitialize ENV before merging changes to each ENV
```

> Note that the `init --clean` command erases all data from database and deploys init data located in `database/data`. If this is not ok, you should either add the change as a new database migration (see the next exercise), or restore the old data manually using the `taito db export` and `taito db import` commands.

### 3.9. Add a new database column as a database migration

After we have made our first production release, the existing deploy sql scripts must not be modified. Therefore you need to add the new column as a new database migration.

```shell
taito db add -h
taito db add: posts-my_column -r posts -n 'Add my_column to posts table'
EDIT database/deploy posts-my_column
EDIT database/revert posts-my_column
EDIT database/verify posts-my_column
```

> It is ok to make multiple changes in one migration script. Just name your migration accordingly. (TODO recommended migration naming).

> See [Sqitch tutorial for PostgreSQL](https://metacpan.org/pod/sqitchtutorial) if you need further instructions.

### 3.10. Modify init data

```shell
EDIT database/data/dev.sql     # Modify data used for local and dev environments
taito init --clean             # Populate init data to local database
taito init:dev --clean         # Populate init data to dev database
```

> If you don't want to erase all existing data, you can import only the data changes with `taito db import: data.sql` and `taito db import:dev data.sql` commands.

### 3.11. Try some additional commands

```shell
taito open kanban              # Open project kanban board on browser
taito open docs                # Open project documentation on browser
taito open ux                  # Open UX guides and layouts on browser

taito check size:client        # Analyze size of the client
taito check deps:server        # Check dependencies of the server

taito --trouble                # Display troubleshooting
taito workspace kill           # Kill all running processes (e.g. containers)
taito workspace clean          # Remove all unused build artifacts (e.g. images)
```

### 3.12. TODO some software design links

TODO General software design
TODO API design
TODO Database design

---

**Next:** [4. Version control](04-version-control.md)
