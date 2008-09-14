require File.dirname(__FILE__) + '/../../spec_helper'

describe I18n, "Russian pluralization" do
  before(:each) do
    @hash = {}
    %w(one few many other).each do |key|
      @hash[key.to_sym] = key
    end
    @backend = I18n.backend
  end
  
  it "should pluralize correctly" do
    @backend.send(:pluralize, :'ru-RU', @hash, 1).should == 'one'
    @backend.send(:pluralize, :'ru-RU', @hash, 2).should == 'few'
    @backend.send(:pluralize, :'ru-RU', @hash, 3).should == 'few'
    @backend.send(:pluralize, :'ru-RU', @hash, 5).should == 'many'
    @backend.send(:pluralize, :'ru-RU', @hash, 10).should == 'many'
    @backend.send(:pluralize, :'ru-RU', @hash, 11).should == 'many'
    @backend.send(:pluralize, :'ru-RU', @hash, 21).should == 'one'
    @backend.send(:pluralize, :'ru-RU', @hash, 29).should == 'many'
    @backend.send(:pluralize, :'ru-RU', @hash, 131).should == 'one'
    @backend.send(:pluralize, :'ru-RU', @hash, 1.31).should == 'other'
    @backend.send(:pluralize, :'ru-RU', @hash, 2.31).should == 'other'
    @backend.send(:pluralize, :'ru-RU', @hash, 3.31).should == 'other'
  end
end