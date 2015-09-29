class Api::V1::PasswordsController < Api::V1::BaseController

  #POST /passwords
  def create
  end

  private
  def user_params
    params.require(:user).permit(:email)
  end

end
