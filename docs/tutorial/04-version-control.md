## 4. Version control

Taito-cli provides some version control commands that make it easier for you to follow commonly defined version control conventions. An organization may also override the default version control conventions with a custom taito-cli plugin.

> All commit messages must be structured according to the [Angular git commit convention](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines) (see also [Conventional Commits](http://conventionalcommits.org/)). This is because application version number and release notes are generated automatically for production release by the [semantic-release](https://github.com/semantic-release/semantic-release) library.

### 4.1 Display commonly defined conventions

If you would rather use GUI tools or git commands for managing your branches, you can display the version control conventions by running:

```shell
taito vc conventions
```

The aforementioned command should display the following version control conventions defined by taito-cli, unless your organization has overridden some of them.

```
Environment branches:
- Branch naming: dev, test, stag, canary, master.
- Environment branches should be merged to one another in the following
  order: dev -> test -> stag -> canary -> master.
- Environment branches should be merged using fast-forward only.
- 'dev' is the only environment branch that you should commit changes to.

Feature branches:
- Branch naming with 'feature/' prefix, for example: feature/delete-user.
- Feature branches are created from 'dev' branch and merged back to it
  using `non-fast-forward` to keep a clear feature branch history.
- You should rebase your feature branch with the `dev` branch before
  merging or creating a pull-request. It is recommended to squash some of your
  commits during rebase to keep a clean version history.
- You should delete a feature branch once it is no longer needed.

Hotfix branches:
- TODO
```

There is a lot to remember. However, if you use taito-cli for managing your branches, you don't have to remember all these conventions.

### 4.2 Feature branches

Feature branches are handy especially in the following situations:

* **Making changes to existing production functionality**: Use feature branches and pull-requests for code reviews. This will decrease the likelyhood that the change will brake something in production. It is also easier to keep the release log clean by using separate feature branches.
* **A new project team member**: Use pull-requests for code reviews. This way you can help the new developer in getting familiar with the coding conventions and application logic of the project.
* **Teaching a new technology**: Pull-requests can be very useful in teaching best practices for an another developer.

Code reviews are very important at the beginning of a new software project, because this is the time when the basic foundation is built for the future development. At the beginning, however, it is usually more sensible to do occasional code reviews across the entire codebase instead of feature specific code reviews based on pull-requests.

Note that most feature branches should be short-lived and located only on your local git repository, unless you are going to make a pull-request.

#### Display commands

```
taito vc feat -h
```

#### Create a new feature branch

Create a public feature branch and make some changes to it:

```
taito vc feat: delete-post
** Commit and push some changes **
```

#### Create another feature branch and squash it back to dev as a single commit

Create a private feature branch, commit some changes to it as multiple commits, merge all changes to the dev branch as a single commit, and delete the feature branch:

```
taito vc feat: delete-image
** Commit some changes as multiple commits **
taito vc feat squash
```

> The `taito vc feat squash` is a handy command when you are working alone and want to keep version history clean by using feature branches. For team work it is recommended to use `taito vc feat merge` or `taito vc feat pr` instead.

#### Merge the existing delete-post feature branch to dev

Switch back to the `delete-post` feature branch, make some changes to it, rebase it with the dev branch and merge it using fast-forward:

```
taito vc feat: delete-post
** Commit and push some changes **
taito vc feat merge
```

#### Create a new feature branch and merge it with a pull-request

Create a public feature branch, make some changes to it, rebase it with dev branch, and create a pull-request:

```
taito vc feat: reporting
** Commit and push some changes **
taito vc feat pr
```

### 4.3 Environment branches

Display commands:

```
taito vc env -h
```

Change to dev branch:

```
taito vc env: dev
```

Merge changes from current environment branch (dev) to the next (test):

```
taito vc env merge
```

Merge changes from dev branch to canary, and to all environment branches in between them:

```
taito vc env merge: dev canary
```

### 4.4 Hotfix branches

TODO

### 4.5 Some common mistakes

TODO:
* Most common mistake so far: An accidental commit to an environment branch other than dev -> prevents fast-forward merge.
* Erased a commit from dev branch that was already merged to test branch -> prevents fast-forward merge.
* Premature feature branch merge to dev (merge commit on top vs. other commits on top of it)
* Premature env branch merge

### TODO Something about advanced deployment options?

> Some of the advanced operations might require admin credentials (e.g. staging/canary/production operations). If you don't have an admin account, ask devops personnel to execute the operation for you.

Advanced features (TODO not all implemented yet):

* **Quickly deploy settings**: If you are in a hurry, you can deploy Helm/Kubernetes changes directly to an environment with the `taito deployment deploy:ENV`.
* **Quickly deploy a container**: If you are in a hurry, you can build, push and deploy a single container directly to server with the `taito deployment build:TARGET:ENV` command e.g. `taito deployment build:client:dev`.
* **Copy production data to staging**: Often it's a good idea to copy production database to staging before merging changes to the stag branch: `taito db copy between:prod:stag`, `taito storage copy between:prod:stag`. If you are sure nobody is using the production database, you can alternatively use the quick copy (`taito db copyquick between:prod:stag`), but it disconnects all other users connected to the production database until copying is finished and also requires that both databases are located in the same database cluster.
* **Feature branch**: You can create an environment also for a feature branch: `taito env apply:f-NAME`. The feature should reside in a branch named `feature/NAME`.
* **Revert application**: Revert application to the previous revision by running `taito deployment revert:ENV`. If you need to revert to a specific revision, check current revision by running `taito deployment revision:ENV` first and then revert to a specific revision by running `taito deployment revert:ENV REVISION`. You can also deploy a specific version with `taito deployment deploy:ENV IMAGE_TAG|SEMANTIC_VERSION`.
* **Debugging CI builds**: You can build and start production containers locally with the `taito start --clean --prod` command. You can also run any CI build steps defined in cloudbuild.yaml locally with taito-cli.


---

**Next:** [5. Project management](05-project-management.md)
