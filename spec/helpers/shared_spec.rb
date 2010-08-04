require 'spec_helper'

describe Paginate::Helpers::Shared do
  before(:all) do
    @klass = Class.new
    @klass.__send__(:include, Paginate::Helpers::Shared)
    @object = @klass.new
  end
  
  describe '#page_set' do
    it 'should pad around current page' do
      @object.page_set(5, 10, 2).should ==
        [1,0,3,4,5,6,7,0,10]

      @object.page_set(5, 10, 1).should ==
        [1,0,4,5,6,0,10]

      @object.page_set(5, 10, 0).should ==
        [1,0,5,0,10]
    end
    
    it 'should default padding to 3' do
      @object.page_set(10, 20).should ==
        [1,0,7,8,9,10,11,12,13,0,20]
    end
    
    it 'should not repeat first page' do
      @object.page_set(2, 10, 2).should ==
        [1,2,3,4,0,10]

      @object.page_set(1, 10, 2).should ==
        [1,2,3,0,10]
    end
    
    it 'should not repeat last page' do
      @object.page_set(9, 10, 2).should ==
        [1,0,7,8,9,10]

      @object.page_set(10, 10, 2).should ==
        [1,0,8,9,10]
    end
    
    it 'should include 0 when pages skipped' do
      @object.page_set(5, 10, 2).should ==
        [1,0,3,4,5,6,7,0,10]
    end
    
    it 'should not include 0 when padding is next to first or last' do
      @object.page_set(3, 10, 2).should ==
        [1,2,3,4,5,0,10]

      @object.page_set(8, 10, 2).should ==
        [1,0,6,7,8,9,10]
    end
    
    it 'should just return [1] if only 1 page' do
      @object.page_set(1, 1, 3).should ==
        [1]
    end
  end

  describe '#url_for_pagination' do
    it 'should add page query option' do
      @object.url_for_pagination(5, 'path', '').should ==
        'path?page=5'
    end

    it 'should leave other query options' do
      @object.url_for_pagination(5, 'path', 'limit=10&something=text').should ==
        'path?page=5&limit=10&something=text'
    end

    it 'should remove existing page option' do
      # middle
      @object.url_for_pagination(5, 'path', 'limit=10&page=10&something=text').should ==
        'path?page=5&limit=10&something=text'

      # start
      @object.url_for_pagination(5, 'path', 'page=10&limit=10&something=text').should ==
        'path?page=5&limit=10&something=text'

      # end
      @object.url_for_pagination(5, 'path', 'limit=10&something=text&page=10').should ==
        'path?page=5&limit=10&something=text'
    end

    it 'should remove existing negative page option' do
      @object.url_for_pagination(5, 'path', 'limit=10&page=-10&something=text').should ==
        'path?page=5&limit=10&something=text'

      @object.url_for_pagination(5, 'path', 'page=-5&limit=10&something=text').should ==
        'path?page=5&limit=10&something=text'
    end
  end
end
