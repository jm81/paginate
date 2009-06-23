require File.dirname(__FILE__) + '/../spec_helper'

describe Paginate::Helpers::Merb do
  before(:all) do
    @klass = Class.new
    @klass.__send__(:include, Paginate::Helpers::Merb)
    @object = @klass.new
  end
  
  it 'should include #page_set method from Shared' do
    @object.page_set(5, 10, 2).should ==
      [1,0,3,4,5,6,7,0,10]
  end

  # Being lazy and just using a mock here.
  describe '#pagination_partial' do
    it 'should call partial' do
      collection = (1..50).to_a
      collection.extend(Paginate::Simple)
      collection = collection.paginate(:page => 5, :limit => 5)
      vars = {
        :current_page => 5,
        :pages => 10,
        :padding => 4
      }
      
      @object.should_receive(:partial).with('partial_name', vars)
      @object.pagination_partial(collection, 'partial_name', 4)
    end
  end
    
  describe '#page_url' do
    it 'should add page query option' do
      @object.page_url(5, 'path', '').should ==
        'path?page=5'
    end

    it 'should leave other query options' do
      @object.page_url(5, 'path', 'limit=10&something=text').should ==
        'path?page=5&limit=10&something=text'
    end
    
    it 'should remove existing page option' do
      # middle
      @object.page_url(5, 'path', 'limit=10&page=10&something=text').should ==
        'path?page=5&limit=10&something=text'
      
      # start
      @object.page_url(5, 'path', 'page=10&limit=10&something=text').should ==
        'path?page=5&limit=10&something=text'
      
      # end
      @object.page_url(5, 'path', 'limit=10&something=text&page=10').should ==
        'path?page=5&limit=10&something=text'
    end
    
    it 'should remove existing negative page option' do
      @object.page_url(5, 'path', 'limit=10&page=-10&something=text').should ==
        'path?page=5&limit=10&something=text'
      
      @object.page_url(5, 'path', 'page=-5&limit=10&something=text').should ==
        'path?page=5&limit=10&something=text'
    end
  end
end
