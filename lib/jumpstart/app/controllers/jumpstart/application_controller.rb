module Jumpstart
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    include Users::TimeZone
  end
end
