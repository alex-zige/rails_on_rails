class Api::V1::UsersController < Api::V1::BaseController

  api :GET, "/v1/users/:id", "Show user's public profile"
  error :code => 401, :desc => "Unauthorized"
  error :code => 404, :desc => "Not Found"
  formats ['json']
  example '{
  "user":{
      "id": 1,
      "first_name": "Augustus",
      "last_name": "Reilly",
      "profile_image_url" : "https://....",
    }
  }'
  def show
    @user = User.find_by_id(params[:id])
    render json: @user, serializer: Api::V1::UserSerializer
  end


  api :PUT, "/v1/users/:id", "Return the current user info."
  error :code => 401, :desc => "Unauthorized"
  error :code => 403, :desc => "Forbidden"
  param :first_name, String, :desc => "user's first_name", :required => false
  param :last_name, String, :desc => "user's last_name", :required => false
  param :company_name, String, :desc => "user's company_name", :required => false
  param :profile_image_data, String, :desc => "user's company_name (Base64 encoded string)", :required => false
  formats ['json']
  example '{
    "id": 1,
    "authentication_token": "JmXq7Mg4ndMhDkSKRrhk",
    "first_name": "Augustus",
    "last_name": "Reilly",
    "profile_image_url" : "https://....",
    ...
  }'
  def update
    @current_user.profile_image = StringIO.new(Base64.decode64(user_params[:profile_image_data])) if user_params[:profile_image_data].present?
    if @current_user.update(user_params.slice!(:profile_image_data))
      render json: @current_user, serializer: Api::V1::CurrentUserSerializer
    else
      render json: {errors: @current_user.errors}, status: :unprocessable_entity
    end
  end

  api :GET, "/v1/users/me", "Return the current user info."
  error :code => 401, :desc => "Unauthorized"
  error :code => 403, :desc => "Not Found"
  formats ['json']
  example '{
    "id": 1,
    "authentication_token": "JmXq7Mg4ndMhDkSKRrhk",
    "email": "test@test.com",
    "first_name": "Augustus",
    "last_name": "Reilly",
    "profile_image_url" : "https://....",
    ...
  }'
  def me
    render json: @current_user, serializer: Api::V1::CurrentUserSerializer
  end


  private
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :company_name, :profile_image_data)
  end

end
