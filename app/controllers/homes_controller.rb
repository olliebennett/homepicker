class HomesController < ApplicationController
  before_action :set_home, only: %i[show edit update destroy restore]
  before_action :set_hunt

  def index
    filter_disabled = params[:disabled] == 'true'
    @homes = Home.where(disabled: filter_disabled)
  end

  def show
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
      @home.price = retrieved_data[:price] if @home.price.blank?
      @home.title = retrieved_data[:title] if @home.title.blank?
      @home.description = retrieved_data[:description] if @home.description.blank?
      @home.latitude = retrieved_data[:latitude] if @home.latitude.blank?
      @home.longitude = retrieved_data[:longitude] if @home.longitude.blank?
      @home.postcode = retrieved_data[:postcode] if @home.postcode.blank?
      @home.address_street = retrieved_data[:address_street] if @home.address_street.blank?
      @home.address_locality = retrieved_data[:address_locality] if @home.address_locality.blank?
      @home.address_region = retrieved_data[:address_region] if @home.address_region.blank?
      @home.zoopla_url = retrieved_data[:canonical_url] if params[:url].include?('zoopla.co')
      @home.rightmove_url = retrieved_data[:canonical_url] if params[:url].include?('rightmove.co.uk')

      # Avoid saving a duplicate of existing home
      if @home.zoopla_url.present?
        existing_z_home = @home.hunt&.homes&.find_by(zoopla_url: @home.zoopla_url)
        return redirect_to(existing_z_home, alert: 'Home already imported from Zoopla; see below.') if existing_z_home.present?
      elsif @home.rightmove_url.present?
        existing_rm_home = @home.hunt&.homes&.find_by(rightmove_url: @home.rightmove_url)
        return redirect_to(existing_rm_home, alert: 'Home already imported from Rightmove; see below.') if existing_rm_home.present?
      end
    end

    if @home.save
      (retrieved_data&.dig(:images) || []).each do |img|
        @home.images.create(url: img)
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
        images_attributes: %i[id url _destroy]
      )
    end
end
