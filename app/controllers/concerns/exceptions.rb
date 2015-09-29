module Exceptions

  class Error < StandardError; end

  class DefaultError < Error

    def initialize(options={})
      @http_status = options[:http_status]
    end

    def self.http_status(value = nil)
      @http_status ||= (value.presence && value)
    end

  end

  # Register new serivices
  def self.register!(name, options = {})
    klass_name = name.to_s.classify.to_sym
    status = options[:http_status]
    klass = Class.new(Exceptions::DefaultError)
    klass.http_status(status)
    Exceptions.const_set klass_name, klass
  end

  # Dynamic register default set of exceptions
  register! :bad_request, :http_status => :bad_request #Exceptions::BadRequest 400
  register! :unauthorized, :http_status => :unauthorized #Exceptions::Unauthorized 401
  register! :forbidden,       :http_status => :forbidden  #Exceptions::Forbidden  403
  register! :not_found,       :http_status => :not_found #Exceptions::NotFound 404
  register! :unprocessable_entity, :http_status => :unprocessable_entity #Exceptions::UnprocessableEntity 422
  register! :internal_server_error, :http_status => :internal_server_error #Exceptions::InternalServerError 500
  register! :service_unavailable, :http_status => :service_unavailable #Exceptions::ServiceUnavailable 503

end