class Api::V1::RegistrationsController < Api::V1::BaseController

  skip_before_action :authenticate_user_from_token!, only: [:create]

  api :POST, "/v1/sign_up", "Sign up new user with email and password"
  error :code => 422, :desc => "unprocessable_entity"
  error :code => 500, :desc => "Server Error"
  param :user, Hash, :desc => "User" do
    param :email, String, :desc => "user's email", :required => true
    param :password, String, :desc => "user's password", :required => true
    param :first_name, String, :desc => "user's first_name", :required => true
    param :last_name, String, :desc => "user's last_name", :required => true
  end
  formats ['json']
  example '{
    "id": 1,
    "authentication_token": "JmXq7Mg4ndMhDkSKRrhk",
    "email": "test@test.com",
    "first_name": "Augustus",
    "last_name": "Reilly"
  }'
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, serializer: Api::V1::CurrentUserSerializer
    else
      render json: {error: @user.errors}, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name)
  end

end
