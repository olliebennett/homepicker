# frozen_string_literal: true

require 'transloadit'

class ImagePersistJob < ApplicationJob
  def perform(image_id)
    @image = Image.find(image_id)

    await_response

    raise 'assembly errored!' if @response.error?

    update_image
  end

  private

  def assembly
    transloadit.assembly(steps:)
  end

  def await_response
    # Empty array as no 'files' needed; we set the image URL above instead
    @response = assembly.create!([])

    # reloads the response once per second until all processing is finished
    @response.reload_until_finished!
  end

  def steps
    [
      step_original,
      step_filter,
      step_thumb,
      step_store
    ]
  end

  def step_original
    transloadit.step('original',
                     '/http/import',
                     url: @image.external_url)
  end

  def step_filter
    transloadit.step('filter',
                     '/file/filter',
                     use: 'original',
                     accepts: [['${file.mime}', 'regex', 'image']],
                     error_on_decline: true)
  end

  def step_thumb
    transloadit.step('thumb',
                     '/image/resize',
                     use: 'filter',
                     width: 150,
                     height: 150,
                     imagemagick_stack: 'v2.0.7',
                     resize_strategy: 'fillcrop')
  end

  def step_store
    transloadit.step('store',
                     '/s3/store',
                     use: %w[thumb original],
                     credentials: 'AWS_S3_CREDENTIALS')
  end

  def transloadit
    @transloadit ||= Transloadit.new(
      key: ENV.fetch('TRANSLOADIT_KEY'),
      secret: ENV.fetch('TRANSLOADIT_SECRET')
    )
  end

  def update_image
    results = @response.body.fetch('results')

    original = results.fetch('original').fetch(0).fetch('ssl_url')
    thumb = results.fetch('thumb').fetch(0).fetch('ssl_url')

    # Persist 'original' and 'thumb' URLs to Image record
    @image.update!(full_url: original, thumb_url: thumb)
  end
end
