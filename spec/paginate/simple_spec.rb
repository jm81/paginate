require 'spec_helper'

describe Paginate::Simple do
  before(:each) do
    @full_collection = []
    1.upto(50) do |i|
      @full_collection << "Person #{i}"
    end
    @full_collection.extend(Paginate::Simple)
  end

  def paginated(options = {})
    @full_collection.paginate(options)
  end
  
  def paginated_collected(options = {})
    paginated(options)
  end
  
  def destroy_all
    50.times { @full_collection.pop }
  end
  
  describe '#paginate' do
    it_should_behave_like "all paginate methods"
  end
end
