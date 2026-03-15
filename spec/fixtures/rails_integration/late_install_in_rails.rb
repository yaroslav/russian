# frozen_string_literal: true

require "bundler/setup"
require "date"
require "uri"
require "rails"
require_relative "../../../lib/russian"
require "active_model"
require "action_view"

Russian::RailsIntegration.install!

model_class = Class.new do
  include ActiveModel::Model

  attr_accessor :name

  validates :name, presence: {message: "^must exist"}
end
Object.const_set(:LateInstallModel, model_class)

record = LateInstallModel.new
record.valid?

view = Class.new do
  include ActionView::Helpers::DateHelper
end.new

I18n.locale = :ru

unless ActionView::Helpers::DateTimeSelector.instance_method(:translated_month_names).owner == Russian::ActionViewExt::Helpers::DateTimeSelectorPatch
  abort "date helper patch missing"
end
abort "full_messages failed" unless record.errors.full_messages.include?("must exist")
abort "select_date failed" unless view.select_date(Date.new(2024, 12, 1)).include?(">декабря<")
abort "select_datetime failed" unless view.select_datetime(DateTime.new(2024, 12, 1, 16, 5)).include?(">декабря<")
