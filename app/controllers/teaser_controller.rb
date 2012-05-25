class TeaserController < ApplicationController
  skip_before_filter :authenticate_user!
  
  def create
    t = Teaser.find_or_create_by_email({email: params[:email]})
    if t.valid?
      render status: 200
    else
      render status: 400
    end
  end
end