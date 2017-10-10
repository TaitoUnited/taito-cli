# Secrets plugin

Provides both randomly and manually generated secrets. Configuration:

    # NOTE: Secret naming is type.target_of_type.namespace.purpose:generation_method
    export taito_secrets="
      db.${postgres_database}.app:random
      db.${postgres_database}.build:random
      ext.twilio.sms:manual"

# TODO add support for reading file contents also?
