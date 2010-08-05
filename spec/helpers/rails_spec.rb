require 'spec_helper'

describe Paginate::Helpers::Rails do
  before(:all) do
    @klass = Class.new
    @klass.__send__(:include, Paginate::Helpers::Rails)
    @object = @klass.new
  end
  
  it 'should include #page_set method from Shared' do
    @object.page_set(5, 10, 2).should ==
      [1,0,3,4,5,6,7,0,10]
  end

  # Being lazy and just using a mock here.
  describe '#pagination_partial' do
    it 'should call render(:partial)' do
      collection = (1..50).to_a
      collection.extend(Paginate::Simple)
      collection = collection.paginate(:page => 5, :limit => 5)
      vars = {
        :current_page => 5,
        :pages => 10,
        :padding => 4
      }

      @object.should_receive(:render).with(:partial => 'partial_name', :locals => vars)
      @object.pagination_partial(collection, 'partial_name', 4)
    end
  end
end
