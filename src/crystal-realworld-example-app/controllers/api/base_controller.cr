module Api
  class BaseController < BaseController
    protected def not_found(error_message = "Not found.")
      response.status_code = 404
      response.content_type = "text/html; charset=utf-8"
      response.print(error_message)
    end

    protected def api_error(status_code = 500, error_message = "An internal server error has occurred.")
      response.status_code = status_code
      response.content_type = "text/html; charset=utf-8"
      response.print(error_message)
    end
  end
end
