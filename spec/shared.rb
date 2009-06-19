# Specs shared by Paginator classes and Paginate modules. These test that the 
# Paginator (directly or via a module) returns the right results based on 
# +page+ and +limit+ options.
#
# +paginated+, +paginated_collected+ and +destroy_all+ methods are expected
# by specs. A +@model+ instance variable is expected for "ORM paginate methods".
# See simple_spec.rb for examples.
#
# +paginated+ is called by shared specs to get a paginated result for the
# collection. 
#
# +paginated_collected+ calls paginate, but returns an Array of Strings. If all 
# results were returned, it should return an Array of
# ["Person 1", "Person 2", ..., "Person 50"] (50 records total). #collect may be
# needed in more complex classes. For example:
#
#   @klass.paginate(@full_collection, options).collect {|r| r.name}
#   Model.paginate(options).collect {|r| r.name}
#
# +destroy_all+ is called to make the full collection an empty set. This may 
# mean that all records need to be deleted in, for example, an ORM Paginator.

shared_examples_for "all paginate methods" do
  describe ':page option' do
    it 'should return correct results per page (correct offset, limit)' do
      paginated_collected(:page => 1, :limit => 5).should ==
        ["Person 1", "Person 2", "Person 3", "Person 4", "Person 5"]      
            
      paginated_collected(:page => 2, :limit => 5).should ==
        ["Person 6", "Person 7", "Person 8", "Person 9", "Person 10"]
    end
    
    it 'should return page 1 if options[:page] == 0' do
      paginated_collected(:page => 0, :limit => 3).should ==
        ["Person 1", "Person 2", "Person 3"]
    end
    
    it 'should return page 1 if options[:page] not set' do
      paginated_collected(:limit => 3, :page => -50).should ==
        ["Person 1", "Person 2", "Person 3"]
    end
    
    it 'should return last page if options[:page] > total pages' do
      paginated_collected(:limit => 5, :page => 11).should ==
        ["Person 46", "Person 47", "Person 48", "Person 49", "Person 50"]
  
      paginated_collected(:limit => 5, :page => 20).should ==
        ["Person 46", "Person 47", "Person 48", "Person 49", "Person 50"]
    end
    
    it 'should return last page for page == -1' do
      paginated_collected(:limit => 5, :page => -1).should ==
        ["Person 46", "Person 47", "Person 48", "Person 49", "Person 50"]
        
      paginated_collected(:limit => 3, :page => -1).should ==
        ["Person 49", "Person 50"]
    end
    
    it 'should return page from last for negative options[:page]' do
      paginated_collected(:limit => 3, :page => -2).should ==
        ["Person 46", "Person 47", "Person 48"]
      
      paginated_collected(:limit => 3, :page => -3).should ==
        ["Person 43", "Person 44", "Person 45"]
    end
    
    it 'should return first page for very negative options[:page] values' do
      paginated_collected(:limit => 3, :page => -50).should ==
        ["Person 1", "Person 2", "Person 3"]
    end
    
    it 'should have at least one result on the last page' do
      paginated(:limit => 5, :page => 10).should_not be_empty
      
      collection = paginated(:limit => 5, :page => 11)
      collection.should_not be_empty
      collection.current_page.should == 10
    end
    
    it 'should default limit to config[:default_limit]' do
      paginated().length.should == Paginate.config[:default_limit]
    end
  end

  describe '#current_page' do
    it 'should be added to collection' do
      collection = paginated(:limit => 10)
      # collection.methods.should include("current_page")
      # Not sure why the above won't work. #singleton_methods doesn't either.
      collection.current_page.should be_kind_of(Integer)
    end
    
    it 'should be the number of the current page' do
      paginated(:limit => 10, :page => 2).current_page.should == 2
      paginated(:limit => 10, :page => 5).current_page.should == 5
    end
    
    it 'should be 1 if there are no results' do
      destroy_all
      paginated(:limit => 10).current_page.should == 1
    end
    
    it 'should be >= 1 and <= #pages (ie actual page, not given page)' do
      paginated(:limit => 10, :page => -100).current_page.should == 1
      paginated(:limit => 10, :page => 100).current_page.should == 5
      paginated(:limit => 10, :page => -1).current_page.should == 5
      paginated(:limit => 10, :page => 0).current_page.should == 1
    end
  end
  
  describe '#pages' do
    it 'should be added to collection' do
      collection = paginated(:limit => 10)
      # collection.methods.should include("pages")
      # Not sure why the above won't work. #singleton_methods doesn't either.
      collection.pages.should be_kind_of(Integer)
    end
    
    it 'should be the total number of pages for the collection' do
      paginated(:limit => 10).pages.should == 5
      paginated(:limit => 49).pages.should == 2
      paginated(:limit => 50).pages.should == 1
    end
    
    it 'should be 1 if there are no results' do
      destroy_all
      paginated(:limit => 10).pages.should == 1
    end
  end
end

# These specs are specific to ORM classes/modules, testing that +all+ receives
# the correct options.
#
# A +@model+ instance variable is expected.
shared_examples_for "ORM paginate methods" do
  it "should set limit and offset options" do
    limit = 10
    
    @model.should_receive(:all).with(:offset => 0, :limit => limit)
    paginated(:page => 1, :limit => limit)
    
    @model.should_receive(:all).with(:offset => 0, :limit => limit + 1)
    paginated(:page => 1, :limit => limit + 1)
    
    @model.should_receive(:all).with(:offset => 0, :limit => limit + 2)
    paginated(:limit => limit + 2)
    
    @model.should_receive(:all).with(:offset => limit, :limit => limit)
    paginated(:page => 2, :limit => limit)

    @model.should_receive(:all).with(:offset => 40, :limit => limit)
    paginated(:page => -1, :limit => limit)
  end
end
