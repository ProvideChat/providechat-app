require 'fog/serverlove/version'
require 'fog/core'
require 'fog/json'

module Fog
  module Compute
    autoload :Serverlove, 'fog/compute/serverlove'
  end

  module Serverlove
    extend Fog::Provider

    service(:compute, 'Compute')
  end
end
