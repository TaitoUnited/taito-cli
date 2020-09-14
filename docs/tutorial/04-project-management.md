## 4. Project management

> TODO: These commands have not yet been implemented.

TODO scrum + kanban + safe references.

### 4.1. Issues

Whether you are working alone or as a team, it's best to document, coordinate and prioritize the work somehow. Taito CLI provides you commands that you can use to quickly manage issues directly from command line.

Try the following commands. Note that the given issue title don't have to be an exact match. If no exact match is found, command finds the closest matching issue title and confirms that it is the correct issue.

```shell
# Open project management on browser
taito open project

# Authenticate to the issue management system
taito issue auth

# Add a new issue with labels 'feature' and 'posts'.
# You'll be asked to enter issue description once you run the command.
taito issue add delete post - feature posts

# List all issues on todo lane
taito issue list todo

# Change issue state to: in progress, assigned to me.
# You'll be asked for a comment, but you can leave it empty.
taito issue state delete post - in progress - me

# Add comment on issue.
taito issue comment add delete post

# Change issue state to: testing, assigned to John Doe
taito issue state change delete post - testing - john doe

# Open issue on browser
taito issue open delete post
```

TODO autocomplete at least for status, labels and personnel?

### 4.2. Hour reporting

You can also do work hour reporting with Taito CLI directly from command line. This is especially handy if you need to enter the same hour entries to multiple hour reporting systems. With Taito CLI you can input your work hours to multiple systems at once with a single command. You just need to enable multiple Taito CLI hour reporting plugins in your project `taito-config.sh`.

Try the following commands:

```shell
taito hours auth                         # Authenticate
taito hours start                        # Start/continue the timer
taito hours pause                        # Pause the timer
taito hours stop                         # Stop the timer and create an hour entry
taito hours add 6.5                      # Add an hour entry for today
taito hours add 6.5 yesterday            # Add an hour entry for yesterday
taito hours add 6.5 tue Did some work    # Add an hour entry for last tuesday
taito hours list                         # Hour entries of this month
taito hours list all                     # Hour entries of this month for all projects
taito hours show                         # Hour summary for this month
taito hours show this-week               # Hour summary for this week
taito open hours                         # Open hour reporting on browser

TODO bulk adds (e.g. three weeks on vacation)
```

---

**Next:** [PART II: Environments](05-remote-environments.md)
