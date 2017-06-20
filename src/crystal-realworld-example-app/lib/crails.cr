module Crails
  class Config
    property routes : Hash(String, Proc(HTTP::Server::Context, Nil))

    def initialize
      @routes = {
        "/" => ->(request : HTTP::Server::Context) { nil }
      }
    end
  end

  class Application
    def initialize!
      Kemal.run
    end

    def config
      @config ||= Config.new
    end

    def route(&block)
      with self yield
    end

    def routes
      config.routes
    end

    macro get(path, to = "")
      Kemal::RouteHandler::INSTANCE.add_route("GET", "{{ path.id }}") do |context|
        {{ to.split("#").first.split("/").map(&.camelcase).join("::").id }}Controller.new(context).{{ to.split("#").last.id }}
      end
    end

    macro post(path, to = "")
      Kemal::RouteHandler::INSTANCE.add_route("POST", "{{ path.id }}") do |context|
        {{ to.split("#").first.split("/").map(&.camelcase).join("::").id }}Controller.new(context).{{ to.split("#").last.id }}
      end
    end

    macro put(path, to = "")
      Kemal::RouteHandler::INSTANCE.add_route("PUT", "{{ path.id }}") do |context|
        {{ to.split("#").first.split("/").map(&.camelcase).join("::").id }}Controller.new(context).{{ to.split("#").last.id }}
      end
    end

    macro delete(path, to = "")
      Kemal::RouteHandler::INSTANCE.add_route("DELETE", "{{ path.id }}") do |context|
        {{ to.split("#").first.split("/").map(&.camelcase).join("::").id }}Controller.new(context).{{ to.split("#").last.id }}
      end
    end
  end
end
