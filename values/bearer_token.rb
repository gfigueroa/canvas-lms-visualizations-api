require 'virtus'
require 'active_model'

SPACE_IN_AUTH_HEADER = ' '
TOKEN_POSITION = 1

# Object to check if bearer token is valid and return value
class BearerToken
  include Virtus.model
  include ActiveModel::Validations

  attr_accessor :bearer_token
  validates :bearer_token, presence: true

  def initialize(bearer_token)
    @bearer_token = bearer_token.split(SPACE_IN_AUTH_HEADER)[TOKEN_POSITION]
  rescue => e
    puts "Bad Bearer Token: #{e}"
  end
end
