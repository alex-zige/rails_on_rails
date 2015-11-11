class Api::V1::SessionsController < Api::V1::BaseController

  skip_before_action :authenticate_user_from_token!, only: [:create]

  api :POST, "/v1/sign_in", "Sign in existing user with email and password"
  error :code => 401, :desc => "Unauthorized"
  error :code => 422, :desc => "Unprocessable Entity"
  error :code => 500, :desc => "Server Error"
  param :user, Hash, :desc => "User" do
    param :email, String, :desc => "user's email", :required => true
    param :password, String, :desc => "user's password", :required => true
  end
  formats ['json']
  example '{
    "id": 1,
    "authentication_token": "JmXq7Mg4ndMhDkSKRrhk",
    "email": "test@test.com",
    "first_name": "Augustus",
    "last_name": "Reilly",
    "profile_image_url" : "https://....",
    "company_name" : "Touchtech"
    ...
  }'
  def create
    @user = User.find_by_email(user_auth_params[:email])
    raise Exceptions::Unauthorized, I18n.t('api.errors.invalid_login') unless @user && @user.valid_password?(user_auth_params[:password])
    render json: @user, serializer: Api::V1::CurrentUserSerializer
  end

  api :DELETE, "/v1/sign_out", "Sign out the current user, invalidate the current Token"
  error :code => 401, :desc => "Unauthorized"
  error :code => 422, :desc => "unprocessable_entity"
  error :code => 500, :desc => "Server Error"
  def destroy
    if @current_user.reset_authentication_token
      render nothing: true
    else
      render json: {error: @current_user.errors}, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email)
  end

  def user_auth_params
    params.require(:user).permit(:email, :password)
  end

end
