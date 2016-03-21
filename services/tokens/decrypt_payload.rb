require 'json'
require 'base64'
require 'rbnacl/libsodium'

NONCE_KEY = 'nonce'
TOKEN_KEY = 'encrypted_token'

# Service object to retrieve Canvas token from bearer tokens.
class DecryptPayload
  def initialize(bearer_token)
    @payload = bearer_token
    @ui_public_key = Base64.urlsafe_decode64 ENV['UI_PUBLIC_KEY']
    @api_private_key = Base64.urlsafe_decode64 ENV['API_PRIVATE_KEY']
  end

  def call
    box = RbNaCl::Box.new(@ui_public_key, @api_private_key)
    payload = Base64.urlsafe_decode64 @payload
    payload = JSON.parse payload
    nonce = Base64.urlsafe_decode64 payload[NONCE_KEY]
    token = Base64.urlsafe_decode64 payload[TOKEN_KEY]
    box.decrypt(nonce, token)
  rescue => e
    puts e
  end
end
