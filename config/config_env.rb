# Copy this file to [app]/config/config_env.rb
# Replace :[ENV_NAME] with environment name
# Replace [*] with key
# The API has the private key of the UI so it can create
# => and sign messages as if it were the UI.
# Run `rake keys_for_config` to generate these keys.

config_env :development do
  set 'MSG_KEY', 'Q2C-0B3ZuHfHJwvH-Zp7is8oSAenJnAWIyVJzY2SFIw='
  set 'UI_PUBLIC_KEY', 'vNpOFkt-h7aFJ-KwTJzZ4ayGwcY3siQe7OYAcE67Tyo='
  set 'API_PRIVATE_KEY', 'c74DPbtyapgJHZsPKZwJvQIcrSO_9doNs3TB1uClHjQ='
  set 'CANVAS_TOKEN', '7~uJqy95JD5QpFQHcAi2snCt1AjvnFKVxXWEryQuxUQtwOH8to6uJVWzdQvRB7dPXZ' # Only in test environment
end
