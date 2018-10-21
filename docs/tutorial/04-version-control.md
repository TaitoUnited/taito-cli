## 4. Version control

Taito-cli provides some version control commands that make it easier for you to follow commonly defined version control conventions. An organization may also override the default version control conventions with a custom taito-cli plugin.

* TODO conventional commits
* TODO something about code reviews (already written on server-template).
* TODO something about referencing issues in commits.

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

---

**Next:** [5. Project management](05-project-management.md)
