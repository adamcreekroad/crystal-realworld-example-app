class CORS < Kemal::Handler
  property allow_origin, allow_methods, allow_headers, max_age

  def initialize(@allow_origin = "*", @allow_methods = %w(GET POST PUT DELETE OPTIONS), @allow_headers = "Accept, Content-Type, Authorization", @max_age = 0)
  end

  def call(context)
    context.response.headers["Access-Control-Allow-Origin"] = allow_origin

    if context.request.method.strip == "OPTIONS"
      context.response.status_code = 200
      response = ""

      if requested_method = context.request.headers["Access-Control-Request-Method"]
        if allow_methods.includes? requested_method.strip
          context.response.headers["Access-Control-Allow-Methods"] = allow_methods
        else
          context.response.status_code = 403
          response = "Method #{requested_method} not allowed."
        end
      end

      if requested_headers = context.request.headers["Access-Control-Request-Headers"]
        requested_headers.split(",").each do |requested_header|
          if allow_headers.includes? requested_header.strip.split("-").map(&.capitalize).join("-")
            context.response.headers["Access-Control-Allow-Headers"] = allow_headers
          else
            context.response.status_code = 403
            response = "Headers #{requested_headers} not allowed."
          end
        end
      end

      context.response.content_type = "text/html; charset=utf-8"
      context.response.print(response)
    else
      call_next(context)
    end
  end
end
