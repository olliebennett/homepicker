class HomesController < ApplicationController
  before_action :set_home, only: [:show, :edit, :update, :destroy]

  # GET /homes
  # GET /homes.json
  def index
    @homes = Home.order(id: :desc)
  end

  # GET /homes/1
  # GET /homes/1.json
  def show
  end

  # GET /homes/new
  def new
    @home = Home.new
  end

  # GET /homes/1/edit
  def edit
  end

  # POST /homes
  # POST /homes.json
  def create
    @home = Home.new(home_params)

    # TODO: Move to background job
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

      @home.zoopla_url = retrieved_data[:canonical_url] if params[:url].include?('zoopla')
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

  # PATCH/PUT /homes/1
  # PATCH/PUT /homes/1.json
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

  # DELETE /homes/1
  # DELETE /homes/1.json
  def destroy
    @home.destroy
    respond_to do |format|
      format.html { redirect_to homes_url, notice: 'Home was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
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
        :price
      )
    end
end
