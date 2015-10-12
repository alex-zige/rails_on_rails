class Api::V1::BaseController < ApplicationController

  include Concerns::ErrorHandling

  before_action :check_deliberate_error

  before_action :authenticate_user_from_token!

  skip_before_action :verify_authenticity_token

  def default_serializer_options
    { root: false }
  end

  private
  def check_deliberate_error
    if params[:raise_error].present?
      case params[:raise_error].to_i
      when 404
        raise Exceptions::NotFound
      when 403
        raise Exceptions::Forbidden
      when 401
        raise Exceptions::Unauthorized
      when 500
        raise Exceptions::InternalServerError
      when 503
        raise Exceptions::ServiceUnavailable
      end
    end
  end

  def authenticate_user_from_token!
    user_token = request.headers['authentication_token']
    user_token ||= params[:authentication_token].presence
    @current_user = user_token && User.find_by_authentication_token(user_token)
    raise Exceptions::Unauthorized unless @current_user
  end

end
