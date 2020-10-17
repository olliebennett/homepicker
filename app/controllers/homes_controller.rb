class HomesController < ApplicationController
  before_action :set_home, only: %i[show edit update destroy restore]
  before_action :set_hunt

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
    build_images
  end

  def edit
    build_images
  end

  def create
    @home = Home.new(home_params)
    @home.creator_user = current_user

    if params[:url].present?
      retrieved_data = LinkRetrieverService.retrieve(params[:url])
      @home.assign_attributes(retrieved_data.except(:images))

      # Avoid saving a duplicate of existing home
      if @home.zoopla_url.present?
        existing_z_home = @home.hunt&.homes&.find_by(zoopla_url: @home.zoopla_url)
        return redirect_to(hunt_home_path(@hunt, existing_z_home), alert: 'Home already imported from Zoopla; see below.') if existing_z_home.present?
      elsif @home.rightmove_url.present?
        existing_rm_home = @home.hunt&.homes&.find_by(rightmove_url: @home.rightmove_url)
        return redirect_to(hunt_home_path(@hunt, existing_rm_home), alert: 'Home already imported from Rightmove; see below.') if existing_rm_home.present?
      end
    end

    if @home.save
      (retrieved_data&.dig(:images) || []).each do |img_url|
        image = @home.images.create(external_url: img_url)
        ImagePersistJob.perform_later(image.id)
      end
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

  def build_images
    blank_images = (@home.images.size % 4).zero? ? 4 : 4 - (@home.images.size % 4)
    blank_images.times { @home.images.build }
  end

  def set_home
    @home = Home.find(params[:id])
  end

  def set_hunt
    @hunt = Hunt.find(params[:hunt_id])
  end

  def home_params
    params.require(:home).permit(
      :title,
      :description,
      :address_street,
      :address_locality,
      :address_region,
      :postcode,
      :latitude,
      :longitude,
      :agent_url,
      :zoopla_url,
      :rightmove_url,
      :price,
      :hunt_id,
      images_attributes: %i[id external_url _destroy]
    )
  end
end
