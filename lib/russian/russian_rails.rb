# Rails hacks
if defined?(ActiveModel)
  require 'active_model_ext/custom_error_message'
end

if defined?(ActionView::Helpers)
  require 'action_view_ext/helpers/date_helper' 
end
