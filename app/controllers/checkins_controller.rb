class CheckinsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json
  
  def create
    if current_user.checkins.create! params[:checkin]
      respond_to do |format|
        format.json { render :json => {"status" => "Successful checkin." }}
      end
    else
      respond_to do |format|
        format.json {render :json => {"status" => "Fail.", "error" => "couldn't check in"} }
      end
    end
  end
  
  def index
    respond_to do |format|
      format.json {render :json => {"checkins" => current_user.all_friends_checkins } }
    end
  end
end