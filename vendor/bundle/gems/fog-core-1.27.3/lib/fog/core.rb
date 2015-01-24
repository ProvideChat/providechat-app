# external core dependencies
require "base64"
require "cgi"
require "uri"
require "excon"
require "fileutils"
require "formatador"
require "openssl"
require "time"
require "timeout"
require "ipaddr"

# internal core dependencies
require "fog/core/version"

require "fog/core/attributes"
require "fog/core/attributes/default"
require "fog/core/attributes/array"
require "fog/core/attributes/boolean"
require "fog/core/attributes/float"
require "fog/core/attributes/integer"
require "fog/core/attributes/string"
require "fog/core/attributes/time"
require "fog/core/attributes/timestamp"
require "fog/core/associations/default"
require "fog/core/associations/many_identities"
require "fog/core/associations/many_models"
require "fog/core/associations/one_model"
require "fog/core/associations/one_identity"
require "fog/core/collection"
require "fog/core/association"
require "fog/core/connection"
require "fog/core/credentials"
require "fog/core/current_machine"
require "fog/core/deprecation"
require "fog/core/errors"
require "fog/core/hmac"
require "fog/core/logger"
require "fog/core/model"
require "fog/core/mock"
require "fog/core/provider"
require "fog/core/service"
require "fog/core/ssh"
require "fog/core/scp"
require "fog/core/time"
require "fog/core/utils"
require "fog/core/wait_for"
require "fog/core/wait_for_defaults"
require "fog/core/uuid"
require "fog/core/stringify_keys"
require "fog/core/whitelist_keys"

# service wrappers
require "fog/account"
require "fog/billing"
require "fog/cdn"
require "fog/compute"
require "fog/dns"
require "fog/identity"
require "fog/image"
require "fog/metering"
require "fog/monitoring"
require "fog/network"
require "fog/orchestration"
require "fog/storage"
require "fog/support"
require "fog/volume"
require "fog/vpn"

# Utility
require 'fog/formatador'
