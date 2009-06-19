require File.dirname(__FILE__) + '/../spec_helper'

describe "Paginate.config" do
  before(:each) do
    # Force to default state
    Paginate.instance_variable_set(:@config, nil)
  end
  
  after(:all) do
    # Force to default state for other specs
    Paginate.instance_variable_set(:@config, nil)
  end
  
  it 'should initialize with DEFAULTS' do
    Paginate.config.should == Paginate::DEFAULTS
  end
  
  it 'should be writable' do
    Paginate.config[:default_limit] = 1
    Paginate.instance_variable_get(:@config)[:default_limit].should == 1
  end
  
  describe ':default_limit' do
    it 'should be used as default limit' do
      Paginate.config[:default_limit] = 3
      ary = (1..20).collect {|i| 'Item #{i}'}
      ary.extend(Paginate::Simple)
      ary.paginate.length.should == 3
    end
  end
end
