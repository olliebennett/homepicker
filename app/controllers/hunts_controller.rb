# frozen_string_literal: true

class HuntsController < ApplicationController
  before_action :set_hunt, only: %i[show]

  skip_before_action :authenticate_user!, only: %i[join]

  def index
    @hunts = current_user.hunts
  end

  def show; end

  def join
    @hunt = Hunt.find(params[:id])

    if user_signed_in?
      hm = current_user.hunt_memberships.find_by(hunt: @hunt)
      return redirect_to hunt_path(@hunt), notice: "You've already joined this hunt!" if hm.present?
    end

    if params[:token].blank? || params[:token].squish != @hunt.join_token
      return redirect_to root_path,
                         alert: 'This invite link is incorrect or has expired. Please ask to be invited again.'
    end

    if user_signed_in? && params[:confirm] == 'true'
      current_user.hunt_memberships.create!(hunt: @hunt)
      return redirect_to hunt_path(@hunt), notice: "You're in! Get hunting!"
    else
      # Save this page so user returns here after registration/login
      store_location_for(:user, request.fullpath)
    end

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
    @hunt = current_user.hunts.find(params[:id])
  end

  def hunt_params
    params.require(:hunt).permit(
      :title
    )
  end
end
