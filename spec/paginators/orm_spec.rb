require 'dm-core'
require 'dm-aggregates'
require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/dm'

describe Paginate::Paginators::ORM do 
  Model = Paginate::Fixtures::DmModel
  before(:all) do
    Model.auto_migrate!
  end
  
  before(:each) do
    Model.all.destroy!
    1.upto(50) do |i|
      Model.create(:name => "Person #{i}")
    end
    @model = Model
    @klass = Paginate::Paginators::ORM
  end
  
  def paginated(options = {})
    @klass.new(Model, options).paginate
  end

  def paginated_collected(options = {})
    paginated(options).collect {|r| r.name}
  end
  
  def destroy_all
    Model.all.destroy!
  end
  
  describe '#paginate' do
    it_should_behave_like "all paginate methods"
    it_should_behave_like "ORM paginate methods"
        
    it 'should order per options passed' do
      paginated_collected(:limit => 3, :page => 1, :order => [:id.desc]).should ==
        ["Person 50", "Person 49", "Person 48"]
    end
    
    it 'should accept conditions (representative of options to .all)' do
      collection = paginated(:limit => 3, :page => 1, :name.like => 'Person 3%')
      collection.collect {|r| r.name}.should ==
        ["Person 3", "Person 30", "Person 31"]
      collection.pages.should == 4
    end
  end
end
