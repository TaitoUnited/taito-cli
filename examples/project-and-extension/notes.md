


























-----------------------------------------------------------

- open source
- installed software
- taito_image="taitounited/taito-cli:latest"
- --upgrade
- -- command
- --shell

- reusable commands: db connect, status, shell, exec
- command syntax
- new: -p project
- history:
  docker run --link leiko-database:database -v $(pwd):/db -w /db --rm docteurklein/sqitch:pgsql deploy db:pg://leiko:secret@database

- responsibility: 1, 2, 3...

- example: project-and-extension
- new feature requests: github issues, toggl/jira

- zone-gcloud examples --> later

- template projects

- project create
  -> merge: dev prod
  -> merge: dev canary
  -> wait for dev

- project template features
