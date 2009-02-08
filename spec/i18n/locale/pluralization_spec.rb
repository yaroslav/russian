# -*- encoding: utf-8 -*- 

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
    @backend.send(:pluralize, :'ru', @hash, 1).should == 'one'
    @backend.send(:pluralize, :'ru', @hash, 2).should == 'few'
    @backend.send(:pluralize, :'ru', @hash, 3).should == 'few'
    @backend.send(:pluralize, :'ru', @hash, 5).should == 'many'
    @backend.send(:pluralize, :'ru', @hash, 10).should == 'many'
    @backend.send(:pluralize, :'ru', @hash, 11).should == 'many'
    @backend.send(:pluralize, :'ru', @hash, 21).should == 'one'
    @backend.send(:pluralize, :'ru', @hash, 29).should == 'many'
    @backend.send(:pluralize, :'ru', @hash, 131).should == 'one'
    @backend.send(:pluralize, :'ru', @hash, 1.31).should == 'other'
    @backend.send(:pluralize, :'ru', @hash, 2.31).should == 'other'
    @backend.send(:pluralize, :'ru', @hash, 3.31).should == 'other'
  end
end