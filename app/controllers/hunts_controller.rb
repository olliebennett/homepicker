class HuntsController < ApplicationController
  before_action :set_hunt, only: %i[show]

  def index
    @hunts = current_user.hunts
  end

  def show; end

  private

  def set_hunt
    @hunt = Hunt.find(params[:id])
  end
end
