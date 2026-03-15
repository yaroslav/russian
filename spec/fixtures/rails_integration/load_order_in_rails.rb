# frozen_string_literal: true

require "bundler/setup"
require "date"
require "uri"
require "rails"
require_relative "../../../lib/russian"
require "active_model"
require "action_view"

ActionView::Base.name

model_class = Class.new do
  include ActiveModel::Model

  attr_accessor :name

  validates :name, presence: {message: "^must exist"}
end
Object.const_set(:LoadOrderModel, model_class)

record = LoadOrderModel.new
record.valid?

view = Class.new do
  include ActionView::Helpers::DateHelper
end.new

I18n.locale = :ru

abort "railtie missing" unless defined?(Russian::Railtie)
abort "railtie type failed" unless Russian::Railtie < Rails::Railtie
abort "full_messages failed" unless record.errors.full_messages.include?("must exist")
abort "select_month failed" unless view.select_month(Date.new(2024, 12, 1)).include?(">Декабрь<")
abort "date_select failed" unless view.date_select(:post, :published_on,
  default: Date.new(2024, 12, 1)).include?(">декабря<")
