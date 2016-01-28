class ApplicationController < ActionController::API
  include ActionController::Serialization
  include CanCan::ControllerAdditions
end
