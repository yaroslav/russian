# frozen_string_literal: true

require "rails"
require_relative "dummy/config/environment"
require_relative "spec_helper"

RSpec.describe "Dummy Rails request integration", :integration do
  let(:session) { ActionDispatch::Integration::Session.new(Dummy::Application) }

  it "renders Russian helper behavior through a real route" do
    session.get("/widget")

    expect(session.response).to have_attributes(status: 200)
    expect(session.response.body).to include(">декабря<")
    expect(session.response.body).to include(">Декабрь<")
    expect(session.response.body).to include(">март<")
    expect(session.response.body).to include(">марта<")
    expect(session.response.body).to include("Нужно принять лицензию")
  end

  it "falls back to standard Rails month-name keys for English through a real route" do
    session.get("/widget/en")

    expect(session.response).to have_attributes(status: 200)
    expect(session.response.body).to include(">December<")
    expect(session.response.body).to include(">Mar<")
  end
end
