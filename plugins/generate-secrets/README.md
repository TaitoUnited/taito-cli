# Secrets plugin

Generates secrets when required. Secrets can be generated randomly, or read from user input or from files. Configuration:

    export taito_secrets="
      ${database_name}-db-app:random
      ${database_name}-db-mgr:random"

# TODO add support for reading file contents also?
