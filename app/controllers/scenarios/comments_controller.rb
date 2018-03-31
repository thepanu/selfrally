# Scenario commments controller
class Scenarios::CommentsController < CommentsController # rubocop:disable Style/ClassAndModuleChildren
  before_action :set_commentable

  def index; end

  def comments; end

  private

  def set_commentable
    @commentable = Scenario.friendly.find(params[:slug])
  end
end
