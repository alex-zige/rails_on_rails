class Api::V1::PasswordsController < Api::V1::BaseController

  skip_before_action :authenticate_user_from_token!, only: [:create]

  api :POST, "/v1/passwords/reset", "Send user the reset password email"
  error :code => 422, :desc => "Unprocessable Entity"
  error :code => 500, :desc => "Server Error"
  param :email, String, :desc => "user's email", :required => true
  formats ['json']

  def create
    @user = User.send_reset_password_instructions(user_params)
    if successfully_sent?(@user)
      render nothing: true
    else
      render json: {error: @user.errors}, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email)
  end

  def successfully_sent?(resource)
    notice = if Devise.paranoid
      resource.errors.clear
      :send_paranoid_instructions
    elsif resource.errors.empty?
      :send_instructions
    end
  end

end
