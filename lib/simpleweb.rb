module SimpleWeb
  class Base
    def initialize(app = nil)
      @app = app
    end

    attr_accessor :request, :response

    def call(env)
      @env = env
      @request = Rack::Request.new(@env)
      @response = Rack::Response.new
    end
  end

  require 'erb'
  class Erb < Base
    def call(env)
      super(env)
      if env['ivars']
        template = ERB.new(File.read("views/#{env['model_name']}/#{env['action']}.html.erb"))
        data = env['ivars']
        response.write(template.result(binding))
        response.finish
      else
        @app.call(env)
      end
    end
  end

  class Rest < Base
    def call(env)
      super(env)
      _, model_name, id = request.path.split('/')

      begin
        env['model_name'] = model_name
        env['action'] = :index
        env['model'] = Object.const_get(model_name.capitalize)
        env['ivars'] = {
          :posts => env['model'].all
        }
      rescue NameError
      end
      @app.call(env)
    end
  end

  class App < Base
    def call(env)
      super(env)
      response.status = 404
      response.write("Not found")
      response.finish
    end
  end

  def self.app
    App.new
  end
end
