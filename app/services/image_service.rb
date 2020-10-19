# frozen_string_literal: true

class ImageService
  def self.persist_images(home, image_urls)
    return if image_urls.blank?

    image_urls.each do |img_url|
      image = home.images.create(external_url: img_url)
      ImagePersistJob.perform_later(image.id)
    end
  end
end
