require 'transloadit'

class ImagePersistJob < ApplicationJob
  def perform(image_id)
    image = Image.find!(image_id)

    transloadit = Transloadit.new(
      key: ENV.fetch('TRANSLOADIT_KEY'),
      secret: ENV.fetch('TRANSLOADIT_SECRET')
    )

    steps = []
    steps << transloadit.step('original',
                              '/http/import',
                              url: image.external_url)
    steps << transloadit.step('filter',
                              '/file/filter',
                              use: 'original',
                              accepts: [['${file.mime}', 'regex', 'image']],
                              error_on_decline: true)
    steps << transloadit.step('thumb',
                              '/image/resize',
                              use: 'filter',
                              width: 150,
                              height: 150,
                              imagemagick_stack: 'v2.0.7',
                              resize_strategy: 'fillcrop')
    steps << transloadit.step('store',
                              '/s3/store',
                              use: %w[thumb original],
                              credentials: 'AWS_S3_CREDENTIALS')

    assembly = transloadit.assembly(steps: steps)

    # Empty array as no 'files' needed; we set the image URL above instead
    response = assembly.create!([])

    # reloads the response once per second until all processing is finished
    response.reload_until_finished!

    if response.error?
      raise 'assembly errored!'
    else
      results = response.body.fetch('results')
      original = results.fetch('original').fetch(0).fetch('ssl_url')
      thumb = results.fetch('thumb').fetch(0).fetch('ssl_url')

      # TODO: Persist 'original' and 'thumb' URLs to Image record
      puts 'Uploaded files;'
      puts "Original: #{original}"
      puts "Thumb: #{thumb}"
    end
  end
end
