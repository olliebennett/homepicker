class HuntsController < ApplicationController
  before_action :set_hunt, only: %i[show]

  def index
    @hunts = current_user.hunts
  end

  def show; end

  def create
    @hunt = Hunt.new(hunt_params)
    @hunt.creator_user = current_user

    if @hunt.save
      current_user.hunt_memberships.create(hunt: @hunt)
      redirect_to hunt_path(@hunt), notice: 'Hunt was successfully created.'
    else
      render :new
    end
  end

  private

  def set_hunt
    @hunt = current_user.hunts.find(params[:id])
  end

  def hunt_params
    params.require(:hunt).permit(
      :title
    )
  end
end
