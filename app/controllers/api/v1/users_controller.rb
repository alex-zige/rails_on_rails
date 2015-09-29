class Api::V1::UsersController < Api::V1::BaseController

  skip_before_action :authenticate_user_from_token!, only: [:create]


  def show
  end

  def update
    @current_user.profile_image = StringIO.new(Base64.decode64(user_params[:profile_image_data])) if user_params[:profile_image_data].present?
    if @current_user.update(user_params.slice!(:profile_image_data))
      render json: @current_user, serializer: Api::V1::CurrentUserSerializer
    else
      render json: {errors: @current_user.errors}, status: :unprocessable_entity
    end
  end

  def me
    render json: @current_user, serializer: Api::V1::CurrentUserSerializer
  end

  private
  def user_params
    params.require(:user).permit(:email)
  end

end
