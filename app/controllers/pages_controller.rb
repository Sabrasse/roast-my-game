class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    # Cache the latest games query for 1 hour
    # This prevents hitting the database every time someone visits the home page
    @latest_games = Rails.cache.fetch("latest_games", expires_in: 1.hour) do
      # Using includes to prevent N+1 queries
      Content.includes(:user)
            .order(created_at: :desc)
            .limit(6)
    end
  end
end
