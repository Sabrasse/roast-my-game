class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :about]

  def home
    # Get latest games without caching to ensure they're always up to date
    @latest_games = Content.includes(:user)
                         .order(created_at: :desc)
                         .limit(6)
    
    # Calculate dynamic counters
    @total_feedbacks = Comment.count
    @total_games = Content.count
    @user_satisfaction = calculate_user_satisfaction
  end

  def about
  end

  private

  def calculate_user_satisfaction
    # This is a placeholder calculation - you might want to implement your own logic
    # For example, based on positive comments, ratings, or other metrics
    return 98 if @total_games.zero? # Default value if no games yet
    
    # Example calculation: percentage of games with at least one positive comment
    games_with_feedback = Content.joins(:comments).distinct.count
    ((games_with_feedback.to_f / @total_games) * 100).round
  end
end
