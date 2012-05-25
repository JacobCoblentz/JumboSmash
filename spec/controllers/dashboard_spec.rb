require 'spec_helper'

describe DashboardController, "dashboard" do
  it "should display an index page" do
    get 'index'
    response.should render_template("index")
  end
end