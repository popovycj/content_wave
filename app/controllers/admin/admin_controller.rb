class Admin::AdminController < ApplicationController
  def get_content_types
    profile = Profile.find(params[:profile_id])
    content_types = profile.social_network.content_types
    render json: content_types
  end
end
