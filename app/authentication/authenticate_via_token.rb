class AuthenticateViaToken
  TokenNotFound = Class.new(StandardError)
  TokenInvalid = Class.new(StandardError) do
    def initialize(message, token = nil)
      @token = token
      super(message)
    end

    attr_reader :token
  end

  def call(token_key, now = DateTime.now)
    token = AccessToken.find_by(key: token_key)

    raise TokenNotFound.new('not found token with given key') unless token.present?
    raise TokenInvalid.new('token has expired', token) unless token.fresh?(now)

    token.user
  end
end