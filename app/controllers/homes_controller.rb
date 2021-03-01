# frozen_string_literal: true

class HomesController < ApplicationController
  before_action :set_home, only: %i[show edit update destroy restore]
  before_action :set_hunt

  before_action :store_location, only: %i[index show new edit]

  def index
    filter_disabled = params[:disabled] == 'true'
    @homes = @hunt.homes.where(disabled: filter_disabled).includes(:ratings)
  end

  def show
    @ratings = Rating.aspects.keys.map do |aspect|
      current_user.ratings.find_or_initialize_by(home: @home, aspect: aspect)
    end

    @others_ratings = @home.ratings.where.not(user: current_user).includes(:user).to_a
  end

  def new
    @home = @hunt.homes.new
  end

  def edit; end

  def create
    @home = Home.new(home_params)
    @home.creator_user = current_user

    retrieve_attributes_from_url

    # Avoid saving a duplicate of existing home
    return if redirect_to_duplicate?

    if @home.save
      ImageService.persist_images(@home, @images) if @images.present?
      redirect_to hunt_home_path(@hunt, @home), notice: 'Home was successfully created.'
    else
      render :new
    end
  end

  def update
    if @home.update(home_params)
      redirect_to hunt_home_path(@hunt, @home), notice: 'Home was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @home.update!(disabled: true)
    redirect_to hunt_homes_path(@hunt), notice: 'Home archived!'
  end

  def restore
    @home.update!(disabled: false)
    redirect_to hunt_home_path(@hunt, @home), notice: 'Home restored!'
  end

  private

  def redirect_to_duplicate?
    redirect_to_duplicate_rightmove? || redirect_to_duplicate_zoopla?
  end

  def redirect_to_duplicate_rightmove?
    return false if @home.rightmove_url.nil?

    existing_rm_home = @home.hunt&.homes&.find_by(rightmove_url: @home.rightmove_url)
    if existing_rm_home.present?
      redirect_to(hunt_home_path(@hunt, existing_rm_home), alert: 'Home already imported from Rightmove; see below.')
      return true
    end

    false
  end

  def redirect_to_duplicate_zoopla?
    return false if @home.zoopla_url.nil?

    existing_z_home = @home.hunt&.homes&.find_by(zoopla_url: @home.zoopla_url)
    if existing_z_home.present?
      redirect_to(hunt_home_path(@hunt, existing_z_home), alert: 'Home already imported from Zoopla; see below.')
      return true
    end

    false
  end

  def retrieve_attributes_from_url
    return if params[:url].nil?

    retrieved_data = LinkRetrieverService.retrieve(params[:url])
    @images = retrieved_data.delete(:images)
    @home.assign_attributes(retrieved_data.except(:floorplans, :key_features))
  end

  def set_home
    @home = Home.find_by_hashid!(params[:id])
  end

  def set_hunt
    @hunt = Hunt.find_by_hashid!(params[:hunt_id])
  end

  def home_params
    HomeParams.new(params).permitted
  end
end
