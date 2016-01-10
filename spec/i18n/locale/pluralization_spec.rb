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
    expect(@backend.send(:pluralize, :'ru', @hash, 1)).to eq('one')
    expect(@backend.send(:pluralize, :'ru', @hash, 2)).to eq('few')
    expect(@backend.send(:pluralize, :'ru', @hash, 3)).to eq('few')
    expect(@backend.send(:pluralize, :'ru', @hash, 5)).to eq('many')
    expect(@backend.send(:pluralize, :'ru', @hash, 10)).to eq('many')
    expect(@backend.send(:pluralize, :'ru', @hash, 11)).to eq('many')
    expect(@backend.send(:pluralize, :'ru', @hash, 21)).to eq('one')
    expect(@backend.send(:pluralize, :'ru', @hash, 29)).to eq('many')
    expect(@backend.send(:pluralize, :'ru', @hash, 131)).to eq('one')
    expect(@backend.send(:pluralize, :'ru', @hash, 1.31)).to eq('other')
    expect(@backend.send(:pluralize, :'ru', @hash, 2.31)).to eq('other')
    expect(@backend.send(:pluralize, :'ru', @hash, 3.31)).to eq('other')
  end
end