class PagesController < ApplicationController
  def home
    @travel = Travel.all.count
    @stop
  end

end
