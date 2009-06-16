require 'dm-core'
require File.dirname(__FILE__) + '/../spec_helper'
require File.dirname(__FILE__) + '/../fixtures/dm'

describe Paginate::DM do
  before(:all) do
    Paginate::Fixtures::DmModel.auto_migrate!
  end
  
  before(:each) do
    Paginate::Fixtures::DmModel.all.destroy!
    1.upto(200) do |i|
      Paginate::Fixtures::DmModel.create(:name => 'Person #{i}')
    end
    @limit = 10
  end
  
  describe '#paginate' do
    it 'should return correct results per page (correct offset, limit)'
    it 'should add #pages method to collection'
    it 'should return page 1 if options[:page] == 0'
    it 'should return last page if options[:page] > total pages'
    it 'should return last page for page == -1'
    it 'should return page from last for negative options[:page]'
    it 'should return first page for very negative options[:page] values'
    it 'should order per options passed'
    it 'should accept conditions (representative of options to .all)'
    it 'should set limit by options[:limit]'
    it 'should default limit to DEFAULT_LIMIT'
    it 'should have at least one result on the last page'
  end
  
  describe '#current_page' do
    it 'should be added to collection'
    it 'should be 1 if there are no results'
    it 'should be >= 1 and <= #pages (ie actual page, not given page)'
  end
  
  describe '#pages' do
    it 'should be the total number of pages for the collection'
    it 'should be added to collection'
    it 'should be 1 if there are no results'
  end
end