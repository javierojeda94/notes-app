class AuthenticateUser
  prepend SimpleCommand

  def initialize(email, password)
    @email = email
    @password = password
    @user = nil
  end

  def call
    user = try_credentials
    if user
      JWTAuthentication.encode({ user_id: user.id })
    end
  end

  private

  def try_credentials
    user = User.find_by_email(@email)
    return user if user.try(:authenticate, @password)
    errors.add :user_authentication, 'invalid credentials'
  end

end
