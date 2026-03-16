# frozen_string_literal: true

class WidgetsController < ApplicationController
  before_action :set_russian_locale

  def show
    @date = Date.new(2024, 12, 1)
    @datetime = DateTime.new(2024, 12, 1, 16, 5)
    @march_date = Date.new(2024, 3, 1)
    @record = DummyRecord.new.tap(&:valid?)
  end

  def english
    I18n.locale = :en
    show
    render :show
  end

  private

  def set_russian_locale
    I18n.locale = Russian.locale
  end
end
