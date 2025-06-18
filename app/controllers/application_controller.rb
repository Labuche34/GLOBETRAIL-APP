class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  def default_url_options
    { hôte : ENV["DOMAINE"] || "localhost :3000" }
  end
end
