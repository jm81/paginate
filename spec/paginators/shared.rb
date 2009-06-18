# Specs shared by Paginator classes. These test that the Paginator returns the
# right results based on +page+ and +limit+ options.
#
# No instance variables are expected by the shared specs, only a +paginated+
# and a +destroy_all+ method. See simple_spec.rb for examples.
#
# +paginated+ is called by shared specs to get a paginated result for the
# collection. If all results were returned, it should return an Array of
# ["Person 1", "Person 2", ..., "Person 50"] (50 records total). It should just 
# return an Array of Strings, so #collect may be needed in more complex
# classes. For example:
#
# @klass.paginate(options).collect {|r| r.name}
#
# +destroy_all+ is called to make the full collection an empty set. This may 
# mean that all records need to be deleted in, for example, an ORM Paginator.

shared_examples_for "all Paginators" do
  describe ':page option' do
    it 'should return correct results per page (correct offset, limit)' do
      paginated(:page => 1, :limit => 5).should ==
        ["Person 1", "Person 2", "Person 3", "Person 4", "Person 5"]      
            
      paginated(:page => 2, :limit => 5).should ==
        ["Person 6", "Person 7", "Person 8", "Person 9", "Person 10"]
    end
    
    it 'should return page 1 if options[:page] == 0' do
      paginated(:page => 0, :limit => 3).should ==
        ["Person 1", "Person 2", "Person 3"]
    end
    
    it 'should return page 1 if options[:page] not set' do
      paginated(:limit => 3, :page => -50).should ==
        ["Person 1", "Person 2", "Person 3"]
    end
    
    it 'should return last page if options[:page] > total pages' do
      paginated(:limit => 5, :page => 11).should ==
        ["Person 46", "Person 47", "Person 48", "Person 49", "Person 50"]
  
      paginated(:limit => 5, :page => 20).should ==
        ["Person 46", "Person 47", "Person 48", "Person 49", "Person 50"]
    end
    
    it 'should return last page for page == -1' do
      paginated(:limit => 5, :page => -1).should ==
        ["Person 46", "Person 47", "Person 48", "Person 49", "Person 50"]
        
      paginated(:limit => 3, :page => -1).should ==
        ["Person 49", "Person 50"]
    end
    
    it 'should return page from last for negative options[:page]' do
      paginated(:limit => 3, :page => -2).should ==
        ["Person 46", "Person 47", "Person 48"]
      
      paginated(:limit => 3, :page => -3).should ==
        ["Person 43", "Person 44", "Person 45"]
    end
    
    it 'should return first page for very negative options[:page] values' do
      paginated(:limit => 3, :page => -50).should ==
        ["Person 1", "Person 2", "Person 3"]
    end
    
    it 'should have at least one result on the last page' do
      paginated(:limit => 5, :page => 10).should_not be_empty
      
      collection = paginated(:limit => 5, :page => 11)
      collection.should_not be_empty
      collection.current_page.should == 10
    end
    
    it 'should default limit to DEFAULT_LIMIT' do
      # Could fail if DEFAULT_LIMIT increased above @full_collection size
      paginated().length.should == Paginate::DEFAULT_LIMIT
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
