## 5. Project management

### 5.1. Issues

Whether you are working alone or as a team, it's best to document, coordinate and prioritize the work somehow. Taito-cli provides you commands that you can use to quickly manage issues directly from command line.

Try the following commands. Note that the given issue title don't have to be an exact match. If no exact match is found, command finds the closest matching issue title and confirms that it is the correct issue.

```shell
# Open kanban board on browser
taito open kanban

# Authenticate to the issue management system
taito issue auth

# Add a new issue with labels 'feature' and 'posts'.
# You'll be asked to enter issue description once you run the command.
taito issue add: delete post - feature posts

# List all issues on todo lane
taito issue list: todo

# Change issue status to: in progress, assigned to me.
# You'll be asked for a comment, but you can leave it empty.
taito issue status: delete post - in progress - me

# Add comment on issue.
taito issue comment: delete post

# Change issue status to: testing, assigned to John Doe
taito issue status: delete post - testing - john doe

# Open issue on browser
taito issue open: delete post
```

TODO autocomplete at least for status, labels and personnel?

### 5.2. Hour reporting

You can also do work hour reporting with taito-cli directly from command line. This is especially handy if you need to enter the same hour entries to multiple hour reporting systems. With taito-cli you can input your work hours to multiple systems at once with a single command. You just need to enable multiple taito-cli hour reporting plugins in your project `taito-config.sh`.

Try the following commands:

```
taito hours auth                         # Authenticate
taito hours start                        # Start/continue the timer
taito hours pause                        # Pause the timer
taito hours stop                         # Stop the timer and create an hour entry
taito hours add: 6.5                     # Add an hour entry for today
taito hours add: 6.5 tue                 # Add an hour entry for last tuesday
taito hours list                         # Hour entries of this month
taito hours list: all                    # Hour entries of this month for all projects
taito hours summary                      # Hour summary for this month
taito hours summary: this-week           # Hour summary for this week
taito open hours                         # Open hour reporting on browser

TODO bulk adds (e.g. three weeks on vacation)
```

---

**Next:** [6. Remote environments](06-remote-environments.md)
