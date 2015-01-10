require 'fog/storm_on_demand/version'
require 'fog/core'
require 'fog/json'

module Fog
  module StormOnDemand
    autoload :Shared, 'fog/storm_on_demand/shared'

    extend Fog::Provider

    service(:compute, 'Compute')
    service(:network, 'Network')
    service(:storage, 'Storage')
    service(:dns, 'DNS')
    service(:billing, 'Billing')
    service(:monitoring, 'Monitoring')
    service(:support, 'Support')
    service(:models, 'Account')
    service(:vpn, 'VPN')
  end

  module Account
    autoload :StormOnDemand, 'fog/account/storm_on_demand'
  end

  module Billing
    autoload :StormOnDemand, 'fog/billing/storm_on_demand'
  end

  module Compute
    autoload :StormOnDemand, 'fog/compute/storm_on_demand'
  end

  module DNS
    autoload :StormOnDemand, 'fog/dns/storm_on_demand'
  end

  module Monitoring
    autoload :StormOnDemand, 'fog/monitoring/storm_on_demand'
  end

  module Network
    autoload :StormOnDemand, 'fog/network/storm_on_demand'
  end

  module Storage
    autoload :StormOnDemand, 'fog/storage/storm_on_demand'
  end

  module Support
    autoload :StormOnDemand, 'fog/support/storm_on_demand'
  end

  module VPN
    autoload :StormOnDemand, 'fog/vpn/storm_on_demand'
  end
end
