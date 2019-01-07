## 3. Local development

### 3.1. Start the application

Start the application with the following commands:

```shell
taito install     # Install linters and some libraries on host
taito start       # Start the local development environment
taito init        # Initialize database with database tables and example data
taito open app    # Open application web user interface
taito info        # Show info required for signing in to the application
```

Installation and starting up takes some time the first time you run the commands, as Docker containers and npm libraries need to be downloaded first.

### 3.2. Implement a new page with React

Make up some simple idea that you would like implement, and add a new page for it on the user interface. Or if you don't come up with anything, just reimplement the posts page that lets you add new posts, but replace posts with articles, for example. Don't worry about API or database for now. Just implement a dummy user interface that looks like it's fully working, but doesn't actually store data permanently anywhere.

The application is built automatically in the background when you make changes. If build fails for some reason, you should see errors on your console.

The following resources might be useful, if you are not yet familiar with React or JavaScript:

* TODO JavaScript basics: The Good Parts?
* [ES6 for beginners](https://codeburst.io/es6-tutorial-for-beginners-5f3c4e7960be)
* [ES2017: Async/Await](https://codeburst.io/javascript-es-2017-learn-async-await-by-example-48acc58bad65)
* [React: Main Concepts](https://reactjs.org/docs/hello-world.html)
* [Egghead: React](https://egghead.io/browse/frameworks/react)

You should also check the following resources, as they are used in examples:

* [Styled components](https://www.styled-components.com/)
* [Material-UI](https://material-ui.com/)

If you are not yet familiar with React, you should implement the UI state management using functionality that React provides out-of-the-box. However, if you already know React, and you are up for an extra challenge, you may choose to use [Redux](https://redux.js.org/) and [redux-saga](https://redux-saga.js.org/) for managing state and side effects. Redux and redux-saga initialization already exists in the `client/src/` directory as some examples already use them.

> TODO: Some tips for debugging.

> TODO: Use React hooks instead of Redux? Or use Redux with React hooks? Provide React hooks tutorials.

### 3.3. Commit and push changes to git

Once in a while commit and push your changes to git. You can do this either with a GUI tool of some sort (e.g. your code editor) or on command line with the following commands.

Committing changes to a local git repository:

```
git add -A                                     # Add all changed files to staging area
git commit -m 'wip(articles): user interface'  # Commit all staged changes to the local git repository
```

Pulling changes from and pushing changes to a remote git repository:

```
git pull -r           # Pull changes from remote git repository using rebase
git push              # Push changes to remote git repository
```

For now, you should commit all your changes to the dev branch that is checked out by default. You should also write commit messages in the following format: `wip(articles): short lowercase message`. Branches and commit message conventions are explained later in chapter [4. Version control](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/tutorial/04-version-control.md).

> TIP: `git pull -r` will refuse to run if your worktree is dirty. In such case, you can run `git pull -r --autostash` if you don't want to commit or stash your changes before pull.

> TIP: You can configure git to always rebase by default on git pull with `git config --global pull.rebase true`.

### 3.4. Add a database table

Your implementation needs to store data somewhere. For this, you create 1-N database tables to PostgreSQL database. You add a new database table by adding a database migration. You can do this with the following commands:

```shell
taito db add: articles -n 'add articles table'  # Add migration
EDIT database/deploy/articles.sql               # Edit deploy script
EDIT database/revert/articles.sql               # Edit revert script
EDIT database/verify/articles.sql               # Edit verify script
taito init                                      # Deploy to local db
```

The deploy script creates a database table, the verify script verifies that the database table exists, and the revert script reverts the changes by dropping the database table. You can find example deploy, revert and verify scripts in the `database/` directory. See [Sqitch tutorial for PostgreSQL](https://metacpan.org/pod/sqitchtutorial) if you need further instructions.

TODO: reference to sql tutorial (database tables)

### 3.5. Add some example data to database

Often it's a good idea to add some example data to database, as it makes development and testing easier. Try to add some example data to the newly created database table with the following commands:

```shell
EDIT database/data/dev.sql     # Modify data used for local and dev environments
taito init --clean             # Populate migrations and init data to local database
```

Note that `taito init --clean` erases all existing data from you local database. If you don't want that, you can alternatively run `taito init` and ignore all the **already exists** error messages.

> TODO: `taito init:dev --clean`

### 3.6. Connect to the local database

Now you should connect to your local database to check that the example data exists there. You can do this with the following commands:

```shell
taito db connect        # Connect to the local database
\dt                     # Show all database tables (postgres)
select * from articles; # Show all articles
\?                      # Show help for backslash commands (postgres)
\q                      # Quit (postgres)
```

TIP: If you have installed some database GUI tool, you can run `taito db proxy` to display database connection details and you can use those details to connect to the local database.

### 3.7. Modify an existing database table

Normally all database changes must be made using database migrations. However, if you are modifying a database table that does not exist in production environment yet, you can keep the scripts located in `database/deploy/` cleaner by modifying them direcly. Try the both approaches:

#### a) With migrations

Add a new column to your newly created database table as a new database migration. You do this just like you added the database table, but this time you use `ALTER TABLE` clause instead of `CREATE TABLE`:

```shell
taito db add: articles-foobar -n 'add foobar column to articles table'  # Add migration
EDIT database/deploy/articles-foobar.sql                                # Edit deploy script
EDIT database/revert/articles-foobar.sql                                # Edit revert script
EDIT database/verify/articles-foobar.sql                                # Edit verify script
taito init                                                              # Deploy to local db
```

The deploy script creates the column, the verify script verifies that the column exists, and the revert script reverts the changes by dropping the column. You can find example deploy, revert and verify scripts in the `database/` directory. See [Sqitch tutorial for PostgreSQL](https://metacpan.org/pod/sqitchtutorial) if you need further instructions.

The upside of this approach is that the new column is deployed to all environments automatically. Other developers need to run `taito init` however.

TODO example: posts-foobar

#### b) Without migrations

Add a new column to your newly created database table by modifying the existing deploy script directly:

```
EDIT database/deploy/articles.sql  # Edit deploy script
taito init --clean                 # Deploy to local db
```

The downside of this approach is that the `taito init:ENV --clean` command deletes all existing data from database, and the command must be run manually to all environments that already contain the database table that was modified.

### 3.8. Implement API

Your UI implementation needs to access the data located in database. However, accessing database directly from UI is a bad approach for many reasons. Therefore you need to implement an API that exist between the UI and the database:

```
UI (on browser)  ->  API (on server)  ->  database
```

The API should be stateless. That is, services that implement the API should not keep any state in memory or on local disk between requests. This is explained in more detail in [Appendix B](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/tutorial/b-software-design.md).

#### Exercise: RESTful API

Implement a RESTful API endpoint for your UI and modify you UI implementation to use the API endpoint. See `server/src/content/posts.*` as an example. In REST a HTTP URL (e.g */posts*) defines a resource, and HTTP methods (GET, POST, PUT, PATCH, DELETE) operate on that resource. For example:

* `GET /articles`: Fetch all articles from the articles collection
* `POST /articles`: Create a new article to the articles collection
* `GET /articles/432`: Read article 432
* `PUT /articles/432`: Update article 432 (all fields)
* `PATCH /articles/432`: Update article 432 (only given fields)
* `DELETE /articles/432`: Delete article 432

You can find more tips from the following articles:

* [10 Best Practices for Better RESTful API](https://blog.mwaysolutions.com/2014/06/05/10-best-practices-for-better-restful-api/)
* [Best Practices for Designing a Pragmatic RESTful API](https://www.vinaysahni.com/best-practices-for-a-pragmatic-restful-api)

> TODO: Some tips for debugging.

#### Exercise: GraphQL API

TODO

### 3.9. Use transactions to preserve data integrity

Data changes made by a service should be atomic to preserve data integrity. That is, if `PUT /articles/432` modifies data located in multiple database tables, either all data updates should be completed or none of them should.

With relational databases you can use transactions to achieve atomicity. The kubernetes-template starts a transaction automatically for all POST, PUT, PATCH and DELETE requests (see `server/src/infra/transaction.middleware.js`). This is a good default for most cases. See chapter [10. Kubernetes-template specific details](https://github.com/TaitoUnited/taito-cli/blob/dev/docs/tutorial/10-kubernetes-template-specific.md) if you'd like to know how to customize your transactions.

However, using database transactions is not enough in every case. For example, if service makes data changes to multiple systems at once (e.g. database + object storage), you usually have to try to preserve data integrity by executing data updates to those systems in a specific order and, if necessary, compensate by reverting some of the data changes in case of an error.

> Some systems also support distributed transactions. That is, you can make changes to multiple systems at once, and all of them engage to the same transaction.

#### Exercise

Try if transactions work like they should:

1) Add few posts using the UI. Also check that they appear in the database: `taito db connect`, `select * from posts order by created_at desc`
2) Edit `posts.service.js` and add a line that throws an error after post has been added to database:

    ```
    async create(state, post) {
      authorize(state).role('admin', 'user');
      const id = await this.postDB.create(state.getTx(), post);
      if (true) throw new Error('error');
      return this.postDB.read(state.getTx(), id);
    }
    ```

3) Try adding posts on the UI. You should notice that the posts won't be created in database even though the error was thrown only after the post was added to database.

### 3.10. Use environment variables for configuration

TODO

### 3.11. Store files to object storage

TODO: As noted previously, no local disk

### 3.12. Use 3rd party services

TODO 3rd party services and secrets

### 3.13. Automatic testing

TODO: CI runs automatically...

```
taito test
taito unit
```

```
taito test:client
taito test:client cypress
taito unit:server
```

> TIP: Also run against remote envs...

TODO You should not test implementation in your (unit) tests. Instead, you should test behaviour of a public API that is designed not to change very often, that is, public API of a class, module, library or a service for example. This way you can make changes to the underlying implementation, and the existing unit tests protect you from breaking anything.

### Create user interface test

Kubernetes-template uses [Cypress](https://www.cypress.io/) for automatic user interface tests.

1) Open the Cypress UI with `taito cypress:client` and run all existing Cypress tests by pressing the `Run all specs` -button.
2) Create tests for you UI. See the `client/test/integration/posts.spec.js` as an example. The following resources provide some useful instructions for writing Cypress tests:
    ```
    [writing-your-first-test](https://docs.cypress.io/guides/getting-started/writing-your-first-test.html)
    [best-practices](https://docs.cypress.io/guides/references/best-practices.html)
    ```

> TIP: By default, Cypress tests are end-to-end tests. That is, they test functionality all the way from the UI to the database. This is not always a good thing. Your tests may become fragile if they are dependent on 3rd party services or data that you cannot easily control, your test may perform poorly, and you easily test the same functionality twice if you already have API tests in place. See [Network Requests
](https://docs.cypress.io/guides/guides/network-requests.html) for more information.

### Create API test

Kubernetes-template uses TODO for automatic API tests.

1) Run all existing API tests with `taito test:server`.
2) Create tests for your API endpoint. See the `server/src/content/posts.test.js` as an example. The following resources provide some useful instructions for writing tests:
    ```
    TODO
    ```

### Create unit test

The kubernetes-template differentiates unit tests from all other tests by using `unit` as filename suffix instead of `test`. A unit test does not require a running environment. That is, no database or external services are involved as unit test typically test only a bunch of code. You can achieve this by [mocking](TODO-link). TODO mock link.

Kubernetes-template uses TODO for automatic API tests.

1) Run all existing unit tests with `taito unit`.
2) Create unit tests for your TODO. See the `TODO` as an example. The following resources provide some useful instructions for writing tests:
    ```
    TODO
    ```

### 3.14. Try some additional taito commands

```shell
taito open git
taito open kanban              # Open project kanban board on browser
taito open docs                # Open project documentation on browser
taito open ux                  # Open UX guides and layouts on browser

taito check size:client        # Analyze size of the client
taito check deps:server        # Check dependencies of the server

taito --trouble                # Display troubleshooting
taito workspace kill           # Kill all running processes (e.g. containers)
taito workspace clean          # Remove all unused build artifacts (e.g. images)
```

### 3.15. Read some software design basics

Just link to appendix B?

* TODO General software design
* TODO API design, GraphQL
* TODO Database design

---

**Next:** [4. Version control](04-version-control.md)
