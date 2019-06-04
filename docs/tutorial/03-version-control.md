## 3. Version control

Taito CLI provides some version control commands that make it easier for you to follow commonly defined version control conventions. An organization may also override the default version control conventions with a custom Taito CLI plugin.

### 3.1 Commit message conventions

All commit messages must be structured according to the [Angular git commit convention](https://github.com/angular/angular/blob/22b96b9/CONTRIBUTING.md#-commit-message-guidelines) (see also [Conventional Commits](http://conventionalcommits.org/)). This is because application version number and release notes are generated automatically for production release by the [semantic-release](https://github.com/semantic-release/semantic-release) library.

Some commit message examples:

```shell
feat(dashboard): news
```

```shell
docs: installation instructions

[skip ci]
```

```shell
fix(login): fix header alignment

Problem persists with IE9, but IE9 is no longer supported.

Closes #87, #76
```

```shell
feat(ux): new look and feel

BREAKING CHANGE: Not really breaking anything, but it's a good time to
increase the major version number.
```

Meanings:

- Closes #xx, #xx: Closes issues
- Issues #xx, #xx: References issues
- BREAKING CHANGE: Introduces a breaking change that causes major version number to be increased in the next production release.
- [skip ci]: Skips continuous integration build when the commit is pushed.

You can use any of the following types in your commit message. Use at least types `fix` and `feat`. Normally you shouldn't use the `wip` type with dev branch, but you can use it in this tutorial.

- `wip`: Work-in-progress (small commits that will be squashed later to one larger commit before merging them to one of the environment branches)
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Code formatting
- `refactor`: Refactoring
- `perf`: Performance tuning
- `test`: Implementing missing tests or correcting existing ones
- `revert`: Revert previous commit.
- `build`: Build system changes
- `ci`: Continuous integration changes (cloudbuild.yaml)
- `chore`: maintenance

### 3.2 Display commonly defined version control conventions

If you would rather manage your git branches with GUI tools or git commands instead of taito commands, you can display the version control conventions by running:

```shell
taito conventions
```

The aforementioned command should display the following version control conventions defined by Taito CLI, unless your organization has overridden some of them.

```shell
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
- You should run all tests before merging or creating a pull-request.
- You should delete a feature branch once it is no longer needed.

Hotfix branches:
- TODO
```

There is a lot to remember. However, if you use Taito CLI for managing your branches, you don't have to remember all these conventions.

### 3.3 Feature branches

Feature branches are handy especially in the following situations:

- **Making changes to existing production functionality**: Use feature branches and pull-requests for code reviews. This will decrease the likelyhood that the change will brake something in production. It is also easier to keep the release log clean by using separate feature branches.
- **A new project team member**: Use pull-requests for code reviews. This way you can help the new developer in getting familiar with the coding conventions and application logic of the project.
- **Teaching a new technology**: Pull-requests can be very useful in teaching best practices for an another developer.

Code reviews are very important at the beginning of a new software project, because this is the time when the basic foundation is built for the future development. At the beginning, however, it is usually more sensible to do occasional code reviews across the entire codebase instead of feature specific code reviews based on pull-requests.

Note that most feature branches should be short-lived and located only on your local git repository, unless you are going to make a pull-request.

#### Display commands

```shell
taito feat -h
```

#### Create a new feature branch

Create a public feature branch and make some changes to it:

```shell
taito feat: delete-post
** Commit and push some changes **
```

#### Create another feature branch and squash it back to dev as a single commit

Create a private feature branch, commit some changes to it as multiple commits, merge all changes to the dev branch as a single commit, and delete the feature branch:

```shell
taito feat: delete-image
** Commit some changes as multiple commits **
taito feat squash
```

> The `taito feat squash` is a handy command when you are working alone and want to keep version history clean by using feature branches. For team work it is recommended to use `taito feat merge` or `taito feat pr` instead.

#### Merge the existing delete-post feature branch to dev

Switch back to the `delete-post` feature branch, make some changes to it, rebase it with the dev branch and merge it using fast-forward:

```shell
taito feat: delete-post
** Commit and push some changes **
taito feat merge
```

#### Create a new feature branch and merge it with a pull-request

Create a public feature branch, make some changes to it, rebase it with dev branch, and create a pull-request:

```shell
taito feat: reporting
** Commit and push some changes **
taito feat pr
```

### 3.4 Environment branches

Display commands:

```shell
taito env -h
```

Change to dev branch:

```shell
taito env:dev
```

Merge changes from current environment branch (dev) to the next (test):

```shell
taito env merge
```

Merge changes from dev branch to canary, and to all environment branches in between them:

```shell
taito env merge:dev canary
```

### 3.5 Hotfix branches

TODO

### 3.6 Feature flags

TODO

### 3.7 Some common mistakes

TODO:

- Most common mistake so far: An accidental commit to an environment branch other than dev -> prevents fast-forward merge.
- Erased a commit from dev branch that was already merged to test branch -> prevents fast-forward merge.
- Premature feature branch merge to dev (merge commit on top vs. other commits on top of it)
- Premature env branch merge

---

**Next:** [4. Project management](/tutorial/04-project-management)
