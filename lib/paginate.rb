module Paginate
  DEFAULTS = {
    :default_limit => 10
  }
  
  class << self
    # Paginate::config method returns Hash that can be edited.
    def config
      @config ||= DEFAULTS.dup
    end
  end
end

if defined?(Merb::Plugins)
  # Make config accessible through Merb's Merb::Plugins.config hash
  Merb::Plugins.config[:paginate] = Paginate.config
end

# Require Paginators
%w{ simple orm }.each do |file|
  require File.dirname(__FILE__) + '/paginators/' + file
end

# Require Paginate Modules
%w{ simple dm ar }.each do |file|
  require File.dirname(__FILE__) + '/paginate/' + file
end

# Require Helper Modules
%w{ shared merb }.each do |file|
  require File.dirname(__FILE__) + '/helpers/' + file
end
