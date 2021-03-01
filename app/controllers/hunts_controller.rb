# frozen_string_literal: true

class HuntsController < ApplicationController
  before_action :set_hunt, only: %i[show]

  skip_before_action :authenticate_user!, only: %i[join]

  def index
    @hunts = current_user.hunts.includes(:creator_user)
  end

  def show; end

  def join
    @hunt = Hunt.find(params[:id])

    unless @hunt.token_match?(params[:token])
      return redirect_to root_path, alert: 'This invite link is incorrect or has expired.'
    end

    return if join_hunt

    store_location

    render :join
  end

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
    @hunt = current_user.hunts.find_by_hashid!(params[:id])
  end

  def join_hunt
    return false unless user_signed_in? && params[:confirm] == 'true'

    msg = if current_user.hunt_member?(@hunt)
            "You've already joined this hunt"
          else
            current_user.hunt_memberships.create!(hunt: @hunt)
            "You're in! Get hunting!"
          end
    redirect_to hunt_path(@hunt), notice: msg

    true
  end

  def hunt_params
    params.require(:hunt).permit(
      :title
    )
  end
end
