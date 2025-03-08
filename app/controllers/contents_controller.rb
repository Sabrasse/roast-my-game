class ContentsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @content = Content.new
  end

  def create
    @content = Content.new(content_params)
    if @content.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def content_params
    params.require(:content).permit(:media, :description)
  end
end
