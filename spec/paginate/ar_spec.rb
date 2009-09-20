require 'active_record'

# Setup AR connection, schema
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database  => ":memory:"
)

ActiveRecord::Schema.define do
  create_table :ar_models do |table|
    table.column :name, :string
  end
end

require 'spec_helper'
require 'fixtures/ar'

describe 'Paginate::AR' do 
  before(:each) do
    @model = Paginate::Fixtures::ArModel
    @model.destroy_all
    1.upto(50) do |i|
      @model.create(:name => "Person #{i}")
    end
  end
  
  def paginated(options = {})
    @model.paginate(options)
  end

  def paginated_collected(options = {})
    @model.paginate(options).collect {|r| r.name}
  end
  
  def destroy_all
    @model.destroy_all
  end
  
  describe '#paginate' do
    it_should_behave_like "all paginate methods"
    it_should_behave_like "ORM paginate methods"
    
    it 'should order per options passed' do
      paginated_collected(:limit => 3, :page => 1, :order => 'id desc').should ==
        ["Person 50", "Person 49", "Person 48"]
    end
    
    it 'should accept conditions (representative of options to .all)' do
      collection = paginated(:limit => 3, :page => 1, :conditions => ['name like ?', 'Person 3%'])
      collection.collect {|r| r.name}.should ==
        ["Person 3", "Person 30", "Person 31"]
      collection.pages.should == 4
    end
  end
end
