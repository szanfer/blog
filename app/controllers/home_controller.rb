class HomeController < ApplicationController
  def index
  	@friends = current_user.upcoming_birthdays if current_user and current_user.facebook_token
  	@photos = current_user.photos_together(@friends) if @friends
  	@dates_coming = Celebration.upcoming
  end

  def invite
  end
end
