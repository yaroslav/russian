require File.dirname(__FILE__) + '/../../spec_helper'

describe I18n, "Russian pluralization" do
  before(:each) do
    @hash = {:one => 'вещь', :few => 'вещи', :many => 'вещей', :other => 'вещи'}
    @backend = I18n.backend
  end
  
  it "should pluralize correctly" do
    @backend.send(:pluralize, :'ru-RU', @hash, 1).should == 'вещь'
    @backend.send(:pluralize, :'ru-RU', @hash, 2).should == 'вещи'
    @backend.send(:pluralize, :'ru-RU', @hash, 3).should == 'вещи'
    @backend.send(:pluralize, :'ru-RU', @hash, 5).should == 'вещей'
    @backend.send(:pluralize, :'ru-RU', @hash, 10).should == 'вещей'
    @backend.send(:pluralize, :'ru-RU', @hash, 21).should == 'вещь'
    @backend.send(:pluralize, :'ru-RU', @hash, 29).should == 'вещей'
    @backend.send(:pluralize, :'ru-RU', @hash, 129).should == 'вещей'
    @backend.send(:pluralize, :'ru-RU', @hash, 131).should == 'вещь'
  end
end