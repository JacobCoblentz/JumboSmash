class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    secret = user_session[:secret]
    current_user.resolve_queued_connections secret
    @requests    = current_user.get_requests secret
    @connections = current_user.get_connections secret
    @pending     = current_user.get_pending secret

    current_user.save
  end

  def people_search
    everyone = []
    if params[:q]
      search_terms = params[:q].split
      search_terms.each do |t|
        everyone += User.select("name, id, email").where "name LIKE ?", "%"+t+"%"
      end
      everyone.uniq!
      everyone = everyone.map do |e|
        t = {}
        t['id'] = e.id
        t['name'] = e.name
        t['email'] = e.email
        t
      end
    end

    render :json => everyone.to_json
  end

  def make_request
    retv = current_user.add_request params[:their_id], user_session[:secret]
    render  :json => retv.to_json
  end

end
