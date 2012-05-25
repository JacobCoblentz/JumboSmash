class MatchMaker < ActionMailer::Base
  default from: "largeparticlesmasher@jumbosmash.com"
  
  def make_match (user)
    @user = user
    mail(:to => user.email, :subject => "Jumbo Smash: We found a match!")
  end
end
