class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Making session helper methods available to all controllers
  include SessionsHelper

  def recent_announcements
    @recent_announcements  ||= Announcement.all.order('created_at DESC').limit(10)
  end
  helper_method :recent_announcements

  # Lists most recent works and users
  def index
    @recent_works = Work.all.order('created_at DESC').limit(10)
  end

  # Displays the user's search results
  def search
    @work_search_results = nil
    @user_search_results = nil

    if params.has_key?(:q) && params[:q].length > 0
      searchKeys = params[:q].split
      @work_search_results = Work.tagged_with(searchKeys, :any => true, :order_by_matching_tag_count => true).paginate(page: params[:page], per_page: 1)
      @user_search_results = User.tagged_with(searchKeys, :any => true, :order_by_matching_tag_count => true).paginate(page: params[:page], per_page: 3)
    else
      @work_search_results = Work.all.order('created_at DESC').paginate(page: params[:page], per_page: 2)
      @user_search_results = User.all.order('created_at DESC').paginate(page: params[:page], per_page: 3)
    end
  end

end
