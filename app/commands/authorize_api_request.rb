class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  attr_reader :headers

  def user
    begin
      @user = User.find(decoded_token[:user_id]) if decoded_token
      @user || errors.add(:token, 'Invalid token')
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def decoded_token
    token = auth_header
    JWTAuthentication.decode(token) if token
  end

  def auth_header
    headers['Authorization'].split(' ').last if headers['Authorization'].present?
  end
end