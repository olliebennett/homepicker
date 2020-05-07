class HomesController < ApplicationController
  before_action :set_home, only: %i[show edit update destroy]

  def index
    @homes = Home.order(id: :desc)
  end

  def show
  end

  def new
    @home = Home.new
    build_images
  end

  def edit
    build_images
  end

  def create
    @home = Home.new(home_params)

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
      @home.zoopla_url = retrieved_data[:canonical_url] if params[:url].include?('zoopla.com')
      @home.rightmove_url = retrieved_data[:canonical_url] if params[:url].include?('rightmove.co.uk')

      # Avoid saving a duplicate of existing home
      if @home.zoopla_url.present?
        existing_home = Home.find_by(zoopla_url: @home.zoopla_url)
        return redirect_to(existing_home, alert: 'Home already imported from Zoopla; see below.') if existing_home.present?
      elsif @home.rightmove_url.present?
        existing_home = Home.find_by(rightmove_url: @home.rightmove_url)
        return redirect_to(existing_home, alert: 'Home already imported from Rightmove; see below.') if existing_home.present?
      end
    end

    respond_to do |format|
      if @home.save
        (retrieved_data[:images] || []).each do |img|
          Image.create(url: img, home: @home)
        end
        format.html { redirect_to @home, notice: 'Home was successfully created.' }
        format.json { render :show, status: :created, location: @home }
      else
        format.html { render :new }
        format.json { render json: @home.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @home.update(home_params)
        format.html { redirect_to @home, notice: 'Home was successfully updated.' }
        format.json { render :show, status: :ok, location: @home }
      else
        format.html { render :edit }
        format.json { render json: @home.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @home.destroy
    respond_to do |format|
      format.html { redirect_to homes_url, notice: 'Home was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def build_images
      blank_images = (@home.images.size % 4).zero? ? 4 : 4 - (@home.images.size % 4)
      blank_images.times { @home.images.build }
    end

    def set_home
      @home = Home.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
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
        images_attributes: %i[id url _destroy]
      )
    end
end
