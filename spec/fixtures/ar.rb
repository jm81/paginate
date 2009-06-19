module Paginate
  module Fixtures   
    class ArModel < ActiveRecord::Base
      extend Paginate::AR
    end
  end
end
