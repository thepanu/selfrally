# Base comments controller used by class specific comments controllers
class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = @commentable.comments.new comment_params
    @comment.user = current_user
    @comment.save
    redirect_to scenario_comments_path(@commentable) + '#newcomment', notice: 'Your comment was successfully posted.'
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
