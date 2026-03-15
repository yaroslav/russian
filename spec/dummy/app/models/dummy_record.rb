# frozen_string_literal: true

class DummyRecord
  include ActiveModel::Model

  attr_accessor :published_on, :published_at, :license_accepted

  validates :license_accepted, presence: {message: "^Нужно принять лицензию"}
end
