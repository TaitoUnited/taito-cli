# Secrets plugin

Provides both randomly and manually generated secrets. Configuration:

    # NOTE: Secret naming is type.target_of_type.namespace.purpose:generation_method
    export taito_secrets="
      db.${database_name}.app:random
      db.${database_name}.build:random
      ext.twilio.sms:manual"

# TODO add support for reading file contents also?
