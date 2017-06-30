class AuthController < ApplicationController

  skip_before_action :authenticate_request

  def login
    authentication = AuthenticateUser.call(params[:email], params[:password])
    if authentication.success?
      response = {
        auth_token: authentication.result,
        status: :ok
      }
    else
      response = {
        error: authentication.errors,
        status: :unauthorized
      }
    end
    render json: response, status: response[:status]
  end

  def signup
    user = User.new(user_params)
    if user.save

      response = {
        message: 'User was successfully created in the database! Now you can login!',
        status: :ok
      }
    else
      response = {
        error: user.errors.to_a.join(','),
        status: :unprocesable_entity
      }
    end
    render json: response, status: response[:status]
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

end
