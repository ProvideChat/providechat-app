module Fog
  module Storage
    class StormOnDemand < Fog::Service
      autoload :Cluster, 'fog/storage/storm_on_demand/models/cluster'
      autoload :Clusters, 'fog/storage/storm_on_demand/models/clusters'
      autoload :Volume, 'fog/storage/storm_on_demand/models/volume'
      autoload :Volumes, 'fog/storage/storm_on_demand/models/volumes'

      requires :storm_on_demand_username, :storm_on_demand_password
      recognizes :storm_on_demand_auth_url

      model_path 'fog/storage/storm_on_demand/models'
      model       :cluster
      collection  :clusters
      model       :volume
      collection  :volumes

      request_path 'fog/storage/storm_on_demand/requests'
      request :list_clusters
      request :attach_volume_to_server
      request :create_volume
      request :delete_volume
      request :detach_volume_from_server
      request :get_volume
      request :list_volumes
      request :resize_volume
      request :update_volume

      class Mock
        def self.data
          @data ||= Hash.new
        end

        def self.reset
          @data = nil
        end

        def self.reset_data(keys=data.keys)
          for key in [*keys]
            data.delete(key)
          end
        end

        def initialize(options = {})
          @storm_on_demand_username = options[:storm_on_demand_username]
        end

        def data
          self.class.data[@storm_on_demand_username]
        end

        def reset_data
          self.class.data.delete(@storm_on_demand_username)
        end
      end

      class Real
        include Fog::StormOnDemand::Shared
      end
    end
  end
end
