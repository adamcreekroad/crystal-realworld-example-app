class BaseController
  add_handler CORS.new
  # add_handler Router.new

  CONTENT_TYPES = {
    css:  "text/css",
    csv:  "text/csv",
    html: "text/html",
    text: "text/plain",
    js:   "application/javascript",
    json: "application/json",
    xml:  "application/xml"
  }

  property context : HTTP::Server::Context

  def initialize(@context)
  end

  protected def request
    context.request
  end

  protected def response
    context.response
  end

  protected def params
    context.params
  end

  protected def render_as(content_type = :html, &block)
    response.content_type = CONTENT_TYPES[content_type]

    yield
  end
end
