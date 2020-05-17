class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]

  def edit
  end

  def create
    @comment = current_user.comments.new(comment_params)

    if @comment.save
      redirect_to hunt_home_url(@comment.home.hunt, @comment.home), notice: 'Comment added.'
    else
      render :new
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to hunt_home_url(@comment.home.hunt, @comment.home), notice: 'Comment updated.'
    else
      render :edit
    end
  end

  def destroy
    @comment.destroy

    redirect_to hunt_home_url(@comment.home.hunt, @comment.home), notice: 'Comment deleted.'
  end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:text, :home_id)
  end
end
