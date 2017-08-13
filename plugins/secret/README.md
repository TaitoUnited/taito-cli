# Secrets plugin

Provides both randomly and manually generated secrets. Configuration:

    # NOTE: Secret naming is generation_method:type.target_of_type.namespace.purpose
    export taito_secrets="
      random:db.${postgres_database}.app
      random:db.${postgres_database}.build
      manual:ext.twilio.sms"

# TODO add support for reading file contents also?
