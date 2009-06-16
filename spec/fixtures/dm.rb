DataMapper.setup(:default, 'sqlite3::memory:')

module Paginate
  module Fixtures
    class DmModel
      include DataMapper::Resource
      extend Paginate::DM
      
      property :id,      Serial
      property :name,    String
    end
  end
end
