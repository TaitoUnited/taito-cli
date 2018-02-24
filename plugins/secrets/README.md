# Secrets plugin

Generates secrets when required. Secrets can be generated randomly, or read from user input or from files. Configuration:

    # NOTE: Secret naming convention: type.target_of_type.purpose[/namespace]:generation_method
    export taito_secrets="
      db.${database_name}.app:random
      db.${database_name}.build:random
      ext.twilio.sms:manual
      ext.xxxxxx.xxx:file"

# TODO add support for reading file contents also?
