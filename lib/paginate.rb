# TODO Any config such as this? Maybe for default limit?
# make sure we're running inside Merb
if defined?(Merb::Plugins)

  # Merb gives you a Merb::Plugins.config hash...feel free to put your stuff in your piece of it
  Merb::Plugins.config[:paginate] = {
    :chickens => false
  }
  
  Merb::BootLoader.before_app_loads do
    # require code that must be loaded before the application
  end
  
  Merb::BootLoader.after_app_loads do
    # code that can be required after the application loads
  end
end

module Paginate
  DEFAULT_LIMIT = 10
end

%w{ simple }.each do |file|
  require File.dirname(__FILE__) + '/paginators/' + file
end

%w{ simple dm }.each do |file|
  require File.dirname(__FILE__) + '/paginate/' + file
end
