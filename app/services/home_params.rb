# frozen_string_literal: true

class HomeParams
  PERMITTED_PARAMS = %i[
    title
    description
    address_street
    address_locality
    address_region
    postcode
    latitude
    longitude
    agent_url
    zoopla_url
    rightmove_url
    price
    hunt_id
  ].freeze

  def initialize(params)
    @params = params
  end

  def permitted
    @params.require(:home).permit(
      PERMITTED_PARAMS,
      images_attributes: %i[id external_url _destroy]
    )
  end
end
