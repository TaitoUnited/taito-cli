## 2. Local development

### 2.1. Start the application

Start the application with the following commands:

```shell
taito install     # Install linters and some libraries on host
taito start       # Start the local development environment
taito init        # Initialize database with database tables and example data
taito open app    # Open application web user interface
taito info        # Show info required for signing in to the application
```

Installation and starting up takes some time the first time you run the commands, as Docker containers and npm libraries need to be downloaded first.

### 2.2. Implement a new page with React

Make up some simple idea that you would like to implement, and add a new empty page for it. If you don't come up with any idea yourself, just reimplement the posts page that lets you add new posts, but replace posts with articles. Don't worry about API or database for now. Just implement a dummy user interface that works, but doesn't actually store data permanently anywhere.

If you are not yet familiar with [React](https://reactjs.org/), you should implement the UI state management using only functionality that React provides out-of-the-box. [Appendix A](a-technology-tutorials.md) provides some React tutorials and other resources that might be useful while learning React, HTML and CSS. If you already know React, you may choose to use additional libraries like [Redux](https://redux.js.org/) and [redux-saga](https://redux-saga.js.org/) for managing state and side effects.

The application is built automatically in the background when you make changes. If build fails for some reason, you should see errors on your command line console. Note that you should also install eslint and prettier plugins to your code editor. This way you see linting errors directly in your editor, and code will be formatted automatically according to predefined rules.

You can debug the implementation with your web browser. [Chrome DevTools](https://developers.google.com/web/tools/chrome-devtools/) is a set of web developer tools built directly into the Google Chrome browser. Other web browsers include similar tools also. These tools let you examine generated HTML, change CSS styles directly in browser, and debug implementation by setting breakpoints and executing code line by line in browser. Note that you can find source code of your UI implementation under the webpack folder: **Chrome DevTools** -> **Sources tab** -> **webpack://** -> **.** -> **src**. See [appendix A](a-technology-tutorials.md#react) for some additional browser extensions that might also be useful.

### 2.3. Commit and push changes to git

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

For now, you should commit all your changes to the dev branch that is checked out by default. You should also write commit messages in the following format: `wip(articles): short lowercase message`. Branches and commit message conventions are explained later in chapter [3. Version control](03-version-control.md).

> TIP: `git pull -r` will refuse to run if your worktree is dirty. In such case, you can run `git pull -r --autostash` if you don't want to commit or stash your changes before pull.

> TIP: You can configure git to always rebase by default on pull with `git config --global pull.rebase true`.

### 2.4. Add a database table

Your implementation needs to store some data permanently. For this, you create 1-N database tables to PostgreSQL database. You add a new database table by adding a new database migration. You can do this with the following commands:

```shell
taito db add: articles -n 'add articles table'  # Add migration
EDIT database/deploy/articles.sql               # Edit deploy script
EDIT database/revert/articles.sql               # Edit revert script
EDIT database/verify/articles.sql               # Edit verify script
taito init                                      # Deploy to local db
```

The deploy script creates a database table, the verify script verifies that the database table exists, and the revert script reverts the changes by dropping the database table. You can find example deploy, revert and verify scripts in the `database/` directory. These migration scripts will be run automatically by [CI/CD pipeline](https://en.wikipedia.org/wiki/CI/CD) when the application is deployed to different environments (e.g. local, development, testing, staging, canary, production).

Migrations are executed with Sqitch. See [Sqitch tutorial for PostgreSQL](https://metacpan.org/pod/sqitchtutorial) if you need further instructions on editing the migration scripts. See [Appendix A](a-technology-tutorials.md) for some SQL and relational database tutorials.

### 2.5. Add some example data to database

Often it's a good idea to add some example data to database, as it makes development and testing easier. Folder `database/data/` contains example data for each environment. Try to add some example data to the newly created database table with the following commands:

```shell
EDIT database/data/dev.sql     # Modify data used for local and dev environments
taito init --clean             # Populate migrations and init data to local database
```

Note that `taito init --clean` erases all existing data from your local database. If you don't want that, you can alternatively run `taito init` and ignore all the **already exists** error messages.

> TODO: note about `taito init:dev --clean`

### 2.6. Connect to the local database

Connect to your local database and check that the example data exists there. You can do this with the following commands:

```shell
taito db connect        # Connect to the local database
\dt                     # Show all database tables (postgres)
select * from articles; # Show all articles (SQL command)
\?                      # Show help for all backslash commands (postgres)
\q                      # Quit (postgres)
```

If you are not yet familiar with SQL, you should try to execute also some additional SQL commands just for the fun of it. See [Appendix A](a-technology-tutorials.md) for some SQL tutorials.

> TIP: If you have installed some database GUI tool, you can run `taito db proxy` to display database connection details and you can use those details to connect to the local database.

### 2.7. Modify an existing database table

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

The deploy script creates the column, the verify script verifies that the column exists, and the revert script reverts the changes by dropping the column. You can find example deploy, revert and verify scripts in the `database/` directory. Note that you can also add multiple columns in a single migration script, if necessary. See [Sqitch tutorial for PostgreSQL](https://metacpan.org/pod/sqitchtutorial) if you need further instructions.

The upside of this approach is that the new column is deployed to all environments automatically. Other developers need to run `taito init` manually, but `taito init --clean` is not required, and therefore all data is preserved.

TODO example: posts-images

#### b) Without migrations

Add a new column to your newly created database table by modifying the existing deploy script directly:

```
EDIT database/deploy/articles.sql  # Edit deploy script
taito init --clean                 # Deploy to local db
```

The downside of this approach is that the `taito init:ENV --clean` command deletes all existing data from database, and the command must be run manually to all environments that already contain the database table that was modified.

### 2.8. Implement API

Your UI implementation needs to access the data located in database. However, accessing database directly from UI is a bad approach for many reasons. Therefore you need to implement an API that exists between the UI and the database:

```
UI (on browser)  ->  API (on server)  ->  database
```

The API should be stateless. That is, services that implement the API should not keep any state in memory or on local disk between requests. This is explained in more detail in [Appendix B](b-software-design.md#stateless-api).

TODO: Some tips for debugging.

#### a) RESTful API

Implement a RESTful API endpoint for your UI and modify you UI implementation to use the API endpoint. See `server/src/content/posts.*` as an example. In RESTful service a HTTP URL (e.g */posts*) defines a resource, and HTTP methods (GET, POST, PUT, PATCH, DELETE) operate on that resource. For example:

* `GET /articles`: Fetch all articles from the articles collection
* `POST /articles`: Create a new article to the articles collection
* `GET /articles/432`: Read article 432
* `PUT /articles/432`: Update article 432 (all fields)
* `PATCH /articles/432`: Update article 432 (only given fields)
* `DELETE /articles/432`: Delete article 432

See [Appendix A](a-technology-tutorials.md#restful-api) for some RESTful API tutorials.

#### b) GraphQL API

TODO

See [Appendix A](a-technology-tutorials.md#graphql-api) for some GraphQL API tutorials.

### 2.9. Use environment variables for configuration

TODO

### 2.10. Use 3rd party services and define secrets

You should not worry about 3rd party services and secrets for now. These are explained in part II of the tutorial.

### 2.11. Store files to object storage

TODO: As noted previously, no local disk

### 2.12. Use transactions to preserve data integrity

Data changes made by a service should be atomic to preserve data integrity. That is, if `PUT /articles/432` modifies data located in multiple database tables, either all data updates should be completed or none of them should.

#### a) Transactions with a relational database

With relational databases you can use transactions to achieve atomicity. The kubernetes-template starts a transaction automatically for all POST, PUT, PATCH and DELETE requests (see `server/src/infra/transaction.middleware.js`). This is a good default for most cases. See chapter [10. Kubernetes-template specific details](10-kubernetes-template-specific.md) if you'd like to know how to customize your transactions.

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

3) Try adding some posts on the UI. You should notice that new posts won't appear in database even though the error is thrown only after each post is created.

#### b) Transactions and multiple systems

Using a database transaction does not always suffice if an operation makes data changes to multiple systems. However, if only two systems are involved (e.g. database + object storage), you can often mitigate this issue just by executing the updates in a correct order. You should make all database updates first and only then write data to object storage. This way database updates will be rolled back automatically if the object storage write fails. In a more complex scenario, you might need to catch some errors yourself and revert data changes manually.

Try this yourself by modifying the implementation that you made in exercise 2.10. Try both a and b, and see how they behave when an error occurs during either database update or object storage write:

* a) write to database, write to object storage
* b) write to object storage, write to database

> Some systems support distributed transactions. That is, you can make changes to multiple systems at once, and all of them engage to the same transaction. Distributed transactions come with extra complexity and are rarely needed.

### 2.13. Automatic testing

Automatic scripts are run automatically by [CI/CD pipeline](https://en.wikipedia.org/wiki/CI/CD) when the application is deployed to different environments (e.g. local, development, testing, staging, canary, production). You can also run these tests manually with the following commands:

```
taito unit                  # Run all unit tests
taito test                  # Run all UI and API tests against locally running application
```

You can also run a certain subset of tests:

```
taito unit:client           # Run unit tests of client
taito unit:server           # Run unit tests of server
taito test:server           # Run all API tests of server against locally running application
taito test:client cypress   # Run all cypress UI tests of client against locally running application
```

You can run UI and API tests also against remote environments, but this is explained in chapter [6. Remote environments](#06-remote-environments.md).

You should not test implementation in your test scripts. Instead, you should always find some kind 'public API' that is designed not to change very often, and test behaviour of that API. Here public API can be provided by class, module, library, service or UI for example. This way you can make changes to the underlying implementation, and the existing tests protect you from breaking anything.

#### a) Create user interface test

Kubernetes-template uses [Cypress](https://www.cypress.io/) for automatic user interface tests.

1) Open the Cypress UI with `taito cypress:client` and run all existing Cypress tests by pressing the `Run all specs` -button.
2) Create tests for you UI. See the `client/test/integration/posts.spec.js` as an example. The following resources provide some useful instructions for writing Cypress tests:
    ```
    [writing-your-first-test](https://docs.cypress.io/guides/getting-started/writing-your-first-test.html)
    [best-practices](https://docs.cypress.io/guides/references/best-practices.html)
    ```

> TIP: By default, Cypress tests are end-to-end tests. That is, they test functionality all the way from the UI to the database. This is not always a good thing. Your tests may become fragile if they are dependent on 3rd party services or data that you cannot easily control, your test may perform poorly, and you easily test the same functionality twice if you already have API tests in place. See [Network Requests
](https://docs.cypress.io/guides/guides/network-requests.html) for more information.

#### b) Create API test

Kubernetes-template uses TODO for automatic API tests.

1) Run all existing API tests with `taito test:server`.
2) Create tests for your API endpoint. See the `server/src/content/posts.test.js` as an example. The following resources provide some useful instructions for writing tests:
    ```
    TODO
    ```

#### c) Create unit test

The kubernetes-template differentiates unit tests from all other tests by using `unit` as filename suffix instead of `test`. A unit test does not require a running environment. That is, no database or external services are involved as unit test typically test only a bunch of code. You can achieve this by [mocking](TODO-link). TODO mock link.

Kubernetes-template uses TODO for automatic API tests.

1) Run all existing unit tests with `taito unit`.
2) Create unit tests for your TODO. See the `TODO` as an example. The following resources provide some useful instructions for writing tests:
    ```
    TODO
    ```

### 2.14. Try some additional taito commands

```shell
taito open git                 # Open git repository on browser
taito open kanban              # Open project kanban board on browser
taito open docs                # Open project documentation on browser
taito open ux                  # Open UX guides and layouts on browser

taito check size:client        # Analyze size of the client
taito check deps:server        # Check dependencies of the server

taito --trouble                # Display troubleshooting
taito workspace kill           # Kill all running processes (e.g. containers)
taito workspace clean          # Remove all unused build artifacts (e.g. images)
```

### 2.15. Read some software design basics

See [appendix B: Software design](b-software-design.md) for some tips on how to design your application.

Requirements analysis and UX design are out of scope for this technology oriented tutorial. However, they are certainly concepts that you should familiarize yourself with, if you want to make good software that fulfills the needs of users.

### 2.16. Validate design decisions

TODO

---

**Next:** [3. Version control](03-version-control.md)