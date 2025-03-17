class ContentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :new, :create]
  before_action :set_content, only: [:show, :edit, :update, :destroy, :claim]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def index
    @contents = Content.recent.includes(:user)
  end

  def show
  end

  def new
    @content = Content.new
  end

  def edit
  end

  def create
    @content = Content.new(content_params)
    
    # Set user if logged in, otherwise set session token
    if user_signed_in?
      @content.user = current_user
    else
      @content.session_token = generate_session_token
    end

    if @content.save
      flash[:notice] = user_signed_in? ? 
        "Your content was successfully uploaded!" : 
        "Content uploaded! Create an account to keep it permanently."
      redirect_to @content
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @content.update(content_params)
      flash[:notice] = "Your content was successfully updated!"
      redirect_to @content
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @content.destroy
    flash[:notice] = "Your content was successfully deleted."
    redirect_to contents_path, status: :see_other
  end

  # Allow registered users to claim anonymous content
  def claim
    return unless user_signed_in? && @content.user_id.nil?
    
    if @content.session_token == cookies[:content_session_token]
      @content.update(user: current_user, session_token: nil)
      flash[:notice] = "Content successfully claimed to your account!"
    else
      flash[:alert] = "You can only claim content from your current session"
    end
    redirect_to @content
  end

  private

  def set_content
    @content = Content.find(params[:id])
  end

  def content_params
    params.require(:content).permit(:media, :description)
  end

  def generate_session_token
    token = SecureRandom.hex(20)
    cookies[:content_session_token] = {
      value: token,
      expires: 7.days.from_now
    }
    token
  end

  def ensure_owner
    unless @content.user == current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to contents_path
    end
  end
end
