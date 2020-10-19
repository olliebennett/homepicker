# frozen_string_literal: true

class HomeParams
  def initialize(params)
    @params = params
  end

  def permitted
    @params.require(:home).permit(
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
