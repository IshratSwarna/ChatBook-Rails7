# frozen_string_literal: true

class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   ActionCable.server.remote_connections.where(current_user: current_user).disconnect
  #   current_user.update(status: User.statuses[:offilne])
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private 

  def respond_with(resource, _opts = {})
    render json: {
      status: { code: 200, message: "User signed in successfully",
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
    }, status: :ok
  end

  def respond_to_on_destroy
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
    current_user = User.find(jwt_payload['sub'])
    if current_user 
      render json: {
        status: 200,
        message: "Logged out successfully"
      }, status: :ok
    else
      render json: { 
        status: 401,
        message: "User has no active session."
      }, status: :unauthorized
    end
  end
end
