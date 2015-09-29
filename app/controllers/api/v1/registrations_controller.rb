class Api::V1::RegistrationsController < Api::V1::BaseController

  skip_before_action :authenticate_user_from_token!, only: [:create]

  #POST /sign_up
  #Params:
  #email: string
  #password: string
  def create
      @user = User.new(user_params)
      if @user.save
        render json: @user, serializer: Api::V1::CurrentUserSerializer
      else
        render json: {errors: @user.errors}, status: :unprocessable_entity
      end
  end

  # def authenticate
  #   raise Exceptions::BadRequest unless authentication_params[:token] && authentication_params[:provider]
  #   user = FbGraph::User.me(authentication_params[:token])
  #   #Throw FbGraph::InvalidToken unless token is valid
  #   user = user.fetch
  #   facebook_uid = user.identifier
  #   authentication = Authentication.find_by_provider_and_uid(authentication_params[:provider], facebook_uid)
  #   raise Exceptions::Unauthorized unless authentication.present?
  #   render json: authentication.user, serializer: Api::V1::CurrentUserSerializer, status: 201
  # end

  #DELELTE /sign_out
  def destroy
  end

  private
  def user_params
    params.require(:user).permit(:email)
  end

end
