
shared_examples_for "all Paginate modules" do
  describe ':page option' do
    it 'should return correct results per page (correct offset, limit)' do
      @model.paginate(:page => 1, :limit => 5).collect {|r| r.name}.should ==
        ["Person 1", "Person 2", "Person 3", "Person 4", "Person 5"]      
            
      @model.paginate(:page => 2, :limit => 5).collect {|r| r.name}.should ==
        ["Person 6", "Person 7", "Person 8", "Person 9", "Person 10"]
    end
    
    it 'should return page 1 if options[:page] == 0' do
      @model.paginate(:page => 0, :limit => 3).collect {|r| r.name}.should ==
        ["Person 1", "Person 2", "Person 3"]
    end
    
    it 'should return page 1 if options[:page] not set' do
      @model.paginate(:limit => 3, :page => -50).collect {|r| r.name}.should ==
        ["Person 1", "Person 2", "Person 3"]
    end
    
    it 'should return last page if options[:page] > total pages' do
      @model.paginate(:limit => 5, :page => 11).collect {|r| r.name}.should ==
        ["Person 46", "Person 47", "Person 48", "Person 49", "Person 50"]
  
      @model.paginate(:limit => 5, :page => 20).collect {|r| r.name}.should ==
        ["Person 46", "Person 47", "Person 48", "Person 49", "Person 50"]
    end
    
    it 'should return last page for page == -1' do
      @model.paginate(:limit => 5, :page => -1).collect {|r| r.name}.should ==
        ["Person 46", "Person 47", "Person 48", "Person 49", "Person 50"]
        
      @model.paginate(:limit => 3, :page => -1).collect {|r| r.name}.should ==
        ["Person 49", "Person 50"]
    end
    
    it 'should return page from last for negative options[:page]' do
      @model.paginate(:limit => 3, :page => -2).collect {|r| r.name}.should ==
        ["Person 46", "Person 47", "Person 48"]
      
      @model.paginate(:limit => 3, :page => -3).collect {|r| r.name}.should ==
        ["Person 43", "Person 44", "Person 45"]
    end
    
    it 'should return first page for very negative options[:page] values' do
      @model.paginate(:limit => 3, :page => -50).collect {|r| r.name}.should ==
        ["Person 1", "Person 2", "Person 3"]
    end
    
    it 'should have at least one result on the last page' do
      @model.paginate(:limit => 5, :page => 10).should_not be_empty
      
      collection = @model.paginate(:limit => 5, :page => 11)
      collection.should_not be_empty
      collection.current_page.should == 10
    end
  end

  describe '#current_page' do
    it 'should be added to collection' do
      collection = @model.paginate(:limit => 10)
      # collection.methods.should include("current_page")
      # Not sure why the above won't work. #singleton_methods doesn't either.
      collection.current_page.should be_kind_of(Integer)
    end
    
    it 'should be the number of the current page' do
      collection = @model.paginate(:limit => 10, :page => 2)
      collection.current_page.should == 2

      collection = @model.paginate(:limit => 10, :page => 5)
      collection.current_page.should == 5
    end
    
    it 'should be 1 if there are no results' do
      destroy_all
      collection = @model.paginate(:limit => 10)
      collection.current_page.should == 1
    end
    
    it 'should be >= 1 and <= #pages (ie actual page, not given page)' do
      collection = @model.paginate(:limit => 10, :page => -100)
      collection.current_page.should == 1
      collection = @model.paginate(:limit => 10, :page => 100)
      collection.current_page.should == 5
      collection = @model.paginate(:limit => 10, :page => -1)
      collection.current_page.should == 5
      collection = @model.paginate(:limit => 10, :page => 0)
      collection.current_page.should == 1
    end
  end
  
  describe '#pages' do
    it 'should be added to collection' do
      collection = @model.paginate(:limit => 10)
      # collection.methods.should include("pages")
      # Not sure why the above won't work. #singleton_methods doesn't either.
      collection.pages.should be_kind_of(Integer)
    end
    
    it 'should be the total number of pages for the collection' do
      collection = @model.paginate(:limit => 10)
      collection.pages.should == 5
      collection = @model.paginate(:limit => 49)
      collection.pages.should == 2
      collection = @model.paginate(:limit => 50)
      collection.pages.should == 1
    end
    
    it 'should be 1 if there are no results' do
      destroy_all
      collection = @model.paginate(:limit => 10)
      collection.pages.should == 1
    end
  end
end

shared_examples_for "Paginate ORM modules" do
  it "should set limit and offset options" do
    @model.should_receive(:all).with(:offset => 0, :limit => @limit)
    @model.paginate(:page => 1, :limit => @limit)
    
    @model.should_receive(:all).with(:offset => 0, :limit => @limit + 1)
    @model.paginate(:page => 1, :limit => @limit + 1)
    
    @model.should_receive(:all).with(:offset => 0, :limit => @limit + 2)
    @model.paginate(:limit => @limit + 2)
    
    @model.should_receive(:all).with(:offset => @limit, :limit => @limit)
    @model.paginate(:page => 2, :limit => @limit)

    @model.should_receive(:all).with(:offset => 40, :limit => @limit)
    @model.paginate(:page => -1, :limit => @limit)
  end
end
