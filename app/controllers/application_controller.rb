class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  # Had to switch from :exception to :null_session to allow post requests
end
