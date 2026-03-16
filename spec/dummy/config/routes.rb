# frozen_string_literal: true

Dummy::Application.routes.draw do
  resource :widget, only: :show
  get "/widget/en", to: "widgets#english"
end
