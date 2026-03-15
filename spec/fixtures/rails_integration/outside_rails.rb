# frozen_string_literal: true

require "bundler/setup"
require "date"
require "uri"
require_relative "../../../lib/russian"
require "active_model"
require "action_view"

model_class = Class.new do
  include ActiveModel::Model

  attr_accessor :name

  validates :name, presence: {message: "^must exist"}
end
Object.const_set(:NonRailsModel, model_class)

record = NonRailsModel.new
record.valid?

view = Class.new do
  include ActionView::Helpers::DateHelper
end.new

I18n.locale = :ru

abort "full_messages unexpectedly patched" unless record.errors.full_messages.include?("Name ^must exist")
abort "date_select unexpectedly patched" unless view.date_select(:post, :published_on,
  default: Date.new(2024, 12, 1)).include?(">Декабрь<")
