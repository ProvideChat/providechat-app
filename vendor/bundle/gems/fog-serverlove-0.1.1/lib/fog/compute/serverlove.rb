module Fog
  module Compute
    class Serverlove < Fog::Service
      autoload :Image, 'fog/compute/serverlove/models/image'
      autoload :Images, 'fog/compute/serverlove/models/images'
      autoload :Server, 'fog/compute/serverlove/models/server'
      autoload :Servers, 'fog/compute/serverlove/models/servers'
      autoload :PasswordGenerator, 'fog/compute/serverlove/password_generator'

      API_HOST = "api.z1-man.serverlove.com"

      requires :serverlove_uuid, :serverlove_api_key
      recognizes :serverlove_api_url

      model_path 'fog/compute/serverlove/models'
      model       :image
      collection  :images
      model       :server
      collection  :servers

      request_path 'fog/compute/serverlove/requests'
      # Image
      request :get_image
      request :get_images
      request :destroy_image
      request :create_image
      request :update_image
      request :load_standard_image
      # Server
      request :get_servers
      request :get_server
      request :destroy_server
      request :create_server
      request :update_server
      request :start_server
      request :stop_server
      request :shutdown_server
      request :reset_server

      class Mock
        def initialize(options)
          @serverlove_uuid = options[:serverlove_uuid]
          @serverlove_api_key = options[:serverlove_api_key]
        end

        def request(options)
          raise "Not implemented"
        end
      end

      class Real
        def initialize(options)
          @api_uuid = options[:serverlove_uuid] || Fog.credentials[:serverlove_uuid]
          @api_key = options[:serverlove_api_key] || Fog.credentials[:serverlove_api_key]
          @api_host = options[:serverlove_api_url] || Fog.credentials[:serverlove_api_url] || API_HOST

          @connection = Fog::Core::Connection.new("https://#{@api_uuid}:#{@api_key}@#{@api_host}")
        end

        def request(params)
          params = params.merge!(
            :headers => {
              "Accept" => "application/json"
            }
          )
          unless params[:options].nil?
            params[:body] = encode_pairs(params[:options])
            params.delete(:options)
          end
          response = @connection.request(params)

          raise_if_error!(response)

          response.body = Fog::JSON.decode(response.body) if response.body && response.body.length > 0

          response
        end

        def encode_pairs(params)
          params.keys.map do |key|
            "#{key} #{params[key]}"
          end.join("\n")
        end

        # TODO
        def raise_if_error!(response)
          case response.status
          when 400 then
            raise 'omg'
          end
        end
      end
    end
  end
end
