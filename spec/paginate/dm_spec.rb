require 'dm-core'
require 'dm-aggregates'
require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/dm'

describe Paginate::DM do
  Model = Paginate::Fixtures::DmModel
  before(:all) do
    Model.auto_migrate!
  end
  
  before(:each) do
    Model.all.destroy!
    1.upto(50) do |i|
      Model.create(:name => "Person #{i}")
    end
    @limit = 10
  end
  
  describe '#paginate' do
    it "should set limit and offset options" do
      Model.should_receive(:all).with(:offset => 0, :limit => @limit)
      Model.paginate(:page => 1, :limit => @limit)
      
      Model.should_receive(:all).with(:offset => 0, :limit => @limit + 1)
      Model.paginate(:page => 1, :limit => @limit + 1)
      
      Model.should_receive(:all).with(:offset => 0, :limit => @limit + 2)
      Model.paginate(:limit => @limit + 2)
      
      Model.should_receive(:all).with(:offset => @limit, :limit => @limit)
      Model.paginate(:page => 2, :limit => @limit)

      Model.should_receive(:all).with(:offset => 40, :limit => @limit)
      Model.paginate(:page => -1, :limit => @limit)
    end
    
    it 'should return correct results per page (correct offset, limit)' do
      Model.paginate(:page => 1, :limit => 5).collect {|r| r.name}.should ==
        ["Person 1", "Person 2", "Person 3", "Person 4", "Person 5"]      
            
      Model.paginate(:page => 2, :limit => 5).collect {|r| r.name}.should ==
        ["Person 6", "Person 7", "Person 8", "Person 9", "Person 10"]
    end
    
    it 'should return page 1 if options[:page] == 0' do
      Model.paginate(:page => 0, :limit => 3).collect {|r| r.name}.should ==
        ["Person 1", "Person 2", "Person 3"]
    end
    
    it 'should return page 1 if options[:page] not set' do
      Model.paginate(:limit => 3, :page => -50).collect {|r| r.name}.should ==
        ["Person 1", "Person 2", "Person 3"]
    end
    
    it 'should return last page if options[:page] > total pages' do
      Model.paginate(:limit => 5, :page => 11).collect {|r| r.name}.should ==
        ["Person 46", "Person 47", "Person 48", "Person 49", "Person 50"]

      Model.paginate(:limit => 5, :page => 20).collect {|r| r.name}.should ==
        ["Person 46", "Person 47", "Person 48", "Person 49", "Person 50"]
    end
    
    it 'should return last page for page == -1' do
      Model.paginate(:limit => 5, :page => -1).collect {|r| r.name}.should ==
        ["Person 46", "Person 47", "Person 48", "Person 49", "Person 50"]
        
      Model.paginate(:limit => 3, :page => -1).collect {|r| r.name}.should ==
        ["Person 49", "Person 50"]
    end
    
    it 'should return page from last for negative options[:page]' do
      Model.paginate(:limit => 3, :page => -2).collect {|r| r.name}.should ==
        ["Person 46", "Person 47", "Person 48"]
      
      Model.paginate(:limit => 3, :page => -3).collect {|r| r.name}.should ==
        ["Person 43", "Person 44", "Person 45"]
    end
    
    it 'should return first page for very negative options[:page] values' do
      Model.paginate(:limit => 3, :page => -50).collect {|r| r.name}.should ==
        ["Person 1", "Person 2", "Person 3"]
    end
    
    it 'should order per options passed' do
      Model.paginate(:limit => 3, :page => 1, :order => [:id.desc]).collect {|r| r.name}.should ==
        ["Person 50", "Person 49", "Person 48"]
    end
    
    it 'should accept conditions (representative of options to .all)' do
      collection = Model.paginate(:limit => 3, :page => 1, :name.like => 'Person 3%')
      collection.collect {|r| r.name}.should ==
        ["Person 3", "Person 30", "Person 31"]
      collection.pages.should == 4
    end
    
    it 'should default limit to DEFAULT_LIMIT' do
      Model.should_receive(:all).with(:offset => 0, :limit => Paginate::DM::DEFAULT_LIMIT)
      Model.paginate
    end
    
    it 'should have at least one result on the last page' do
      Model.paginate(:limit => 5, :page => 10).should_not be_empty
      
      collection = Model.paginate(:limit => 5, :page => 11)
      collection.should_not be_empty
      collection.current_page.should == 10
    end
  end
  
  describe '#current_page' do
    it 'should be added to collection' do
      collection = Model.paginate(:limit => 10)
      # collection.methods.should include("current_page")
      # Not sure why the above won't work. #singleton_methods doesn't either.
      collection.current_page.should be_kind_of(Integer)
    end
    
    it 'should be the number of the current page' do
      collection = Model.paginate(:limit => 10, :page => 2)
      collection.current_page.should == 2

      collection = Model.paginate(:limit => 10, :page => 5)
      collection.current_page.should == 5
    end
    
    it 'should be 1 if there are no results' do
      Model.all.destroy!
      collection = Model.paginate(:limit => 10)
      collection.current_page.should == 1
    end
    
    it 'should be >= 1 and <= #pages (ie actual page, not given page)' do
      collection = Model.paginate(:limit => 10, :page => -100)
      collection.current_page.should == 1
      collection = Model.paginate(:limit => 10, :page => 100)
      collection.current_page.should == 5
      collection = Model.paginate(:limit => 10, :page => -1)
      collection.current_page.should == 5
      collection = Model.paginate(:limit => 10, :page => 0)
      collection.current_page.should == 1
    end
  end
  
  describe '#pages' do
    it 'should be added to collection' do
      collection = Model.paginate(:limit => 10)
      # collection.methods.should include("pages")
      # Not sure why the above won't work. #singleton_methods doesn't either.
      collection.pages.should be_kind_of(Integer)
    end
    
    it 'should be the total number of pages for the collection' do
      collection = Model.paginate(:limit => 10)
      collection.pages.should == 5
      collection = Model.paginate(:limit => 49)
      collection.pages.should == 2
      collection = Model.paginate(:limit => 50)
      collection.pages.should == 1
    end
    
    it 'should be 1 if there are no results' do
      Model.all.destroy!
      collection = Model.paginate(:limit => 10)
      collection.pages.should == 1
    end
  end
end
