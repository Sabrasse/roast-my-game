class ContentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show, :new, :create]
  before_action :set_content, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @contents = Content.includes(:user)
                      .recent
                      .page(params[:page])
                      .per(12)
  end

  def show
    @comments = @content.comments.includes(:user).order(created_at: :desc)
  end

  def new
    @content = Content.new
  end

  def create
    @content = Content.new(content_params)
    @content.user = current_user if user_signed_in?

    if @content.save
      redirect_to @content, notice: 'Game was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @content.update(content_params)
      redirect_to @content, notice: 'Game was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @content.destroy
    redirect_to contents_url, notice: 'Game was successfully deleted.'
  end

  private

  def set_content
    @content = Content.find(params[:id])
  end

  def content_params
    params.require(:content).permit(:description, :media)
  end

  def authorize_user!
    unless @content.user == current_user
      redirect_to @content, alert: 'You are not authorized to perform this action.'
    end
  end
end
