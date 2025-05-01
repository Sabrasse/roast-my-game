class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_content
  before_action :set_comment, only: [:destroy]
  before_action :ensure_owner, only: [:destroy]

  def create
    @comment = @content.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.turbo_stream
        format.html { redirect_to @content, notice: "Comment was successfully added!" }
      else
        format.html { redirect_to @content, alert: "Error adding comment. Please try again." }
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @content, notice: "Comment was successfully deleted." }
    end
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