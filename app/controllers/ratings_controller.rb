class RatingsController < ApplicationController
  before_action :set_rating, only: %i[update]

  def create
    @rating = current_user.ratings.new(rating_params)

    if @rating.save
      redirect_to hunt_home_url(@rating.home.hunt, @rating.home), notice: 'Rating added.'
    else
      redirect_back fallback_location: '/',
                    flash: { danger: @rating.errors.full_messages.join(', ') }
    end
  end

  def update
    if @rating.update(rating_params)
      redirect_to hunt_home_url(@rating.home.hunt, @rating.home), notice: 'Rating updated.'
    else
      redirect_back fallback_location: '/',
                    flash: { danger: @rating.errors.full_messages.join(', ') }
    end
  end

  private

  def set_rating
    @rating = current_user.ratings.find(params[:id])
  end

  def rating_params
    params.require(:rating).permit(:score, :home_id, :aspect)
  end
end
