class AuthController < ApplicationController

  skip_before_action :authenticate_request

  def login
    authentication = AuthenticateUser.call(params[:email], params[:password])
    if authentication.success?
      render json: { auth_token: authentication.result }
    else
      render json: { error: authentication.errors }, status: :unauthorized
    end
  end

  def signup

  end

end
