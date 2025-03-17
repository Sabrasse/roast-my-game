class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_content
  before_action :set_comment, only: [:destroy]
  before_action :ensure_owner, only: [:destroy]

  def create
    @comment = @content.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "Comment was successfully added!"
    else
      flash[:alert] = "Error adding comment. Please try again."
    end

    redirect_to @content
  end

  def destroy
    @comment.destroy
    flash[:notice] = "Comment was successfully deleted."
    redirect_to @content
  end

  private

  def set_content
    @content = Content.find(params[:content_id])
  end

  def set_comment
    @comment = @content.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def ensure_owner
    unless @comment.user == current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to @content
    end
  end
end 