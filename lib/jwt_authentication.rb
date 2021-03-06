class JWTAuthentication
  class << self
    def encode(content)
      content[:expiration] = 12.hours.to_i
      JWT.encode(content, Rails.application.secrets.secret_key_base)
    end

    def decode(api_token)
      begin
        body = JWT.decode(api_token, Rails.application.secrets.secret_key_base).first
        HashWithIndifferentAccess.new body
      rescue JWT::DecodeError
        return nil
      end
    end
  end
end
