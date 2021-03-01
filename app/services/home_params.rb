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
    bulk_images = @params[:home]&.delete(:bulk_images)
    handle_bulk_images(bulk_images) if bulk_images.present?

    params_copy = @params.dup

    if params_copy.dig(:home, :hunt_id).present?
      params_copy[:home][:hunt_id] = Hunt.decode_id(params_copy[:home][:hunt_id])
    end

    params_copy.require(:home).permit(
      PERMITTED_PARAMS,
      images_attributes: %i[id external_url _destroy]
    )
  end

  def handle_bulk_images(bulk_images)
    # Split 'bulk images' textarea to separate fields
    images = bulk_images.split("\n").map(&:squish).reject(&:blank?).uniq

    images = deduplicate_images(images)

    images.each do |image_url|
      # Add the image to the hash (with sequential numeric keys)
      next_key = @params[:home][:images_attributes].keys.count.to_s
      @params[:home][:images_attributes][next_key] = { external_url: image_url }
    end
  end

  def deduplicate_images(images)
    @params[:home][:images_attributes] ||= {}

    images.reject do |image_url|
      @params[:home][:images_attributes].values.any? { |v| v[:external_url] == image_url }
    end
  end
end
