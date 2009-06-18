require File.dirname(__FILE__) + '/../spec_helper'

describe Paginate::Paginators::Simple do 
  # No instance variables are expected by the shared specs, only a +paginated+
  # and a +destroy_all+ method.
  before(:each) do
    @full_collection = []
    1.upto(50) do |i|
      @full_collection << "Person #{i}"
    end
    @klass = Paginate::Paginators::Simple
  end
  
  # paginated is called by shared specs to get a paginated result for the
  # collection.
  def paginated(options = {})
    @klass.new(@full_collection, options).paginate
  end
  
  # paginated_collected returns results in a standard format: It should just 
  # return an Array of Strings, such as:
  # ["Person 1", "Person 2"], so #collect may be needed in more complex
  # classes.
  def paginated_collected(options = {})
    paginated(options)
  end
  
  # destroy_all is called to make @full_collection an empty set. This may mean
  # that all records need to be deleted in, for example, an ORM Paginator.
  def destroy_all
    @full_collection = []
  end
  
  describe '#paginate' do
    it_should_behave_like "all paginate methods"
  end
end
