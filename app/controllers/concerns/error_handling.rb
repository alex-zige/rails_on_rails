module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid , with: :invalid_record
    rescue_from ArgumentError, with: :argument_error
    rescue_from Exceptions::DefaultError, with: :render_error
  end

  private
  def render_error(exception)
    status = :unprocessable_entity
    status = exception.class.http_status if exception.class.respond_to?(:http_status) #pre-defined errors
    render json: { error: exception.message  }  , status: status
  end

  def unauthorized(exception)
    render json: { error: exception.message } , status: :unauthorized
  end

  def invalid_record(exception)
    render json: { error: exception.record.errors } , status: :unprocessable_entity
  end

  def record_not_found(exception)
    render :json => { error: exception.message}, status: :not_found
  end

  def bad_request(exception)
    render :json => { error: exception.message}, status: :bad_request
  end

  def argument_error(exception)
    render :json => { error: exception.message}, status: :unprocessable_entity
  end

  def fb_graph_error(exception)
    render :json => { error: exception.message}, status: exception.code
  end

end
