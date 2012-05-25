class AdminController < ApplicationController
  def index
    @users = Whitelist.all
  end
end