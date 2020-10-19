# frozen_string_literal: true

module FontAwesomeHelper
  # Add any new icons in fontawesome_icons.yml
  FA_ICON_SVGS = YAML.safe_load(File.read(Rails.root.join('lib/assets/fontawesome_icons.yml'))).freeze

  def fa_icon_inline(glyph, type: :solid, cls: '')
    x = fa_icon_svg(glyph, type).dup
    x.gsub!('class="', "class=\"#{cls} ") if cls.present? # add custom classes
    # We're confident it's safe because we define the <svg> data in the YAML config ourselves
    # (we could parse/re-build the SVG safely, then modify class, but this would be unnecessary complexity)
    # rubocop:disable Rails/OutputSafety
    x.html_safe
    # rubocop:enable Rails/OutputSafety
  end

  private

  def fa_icon_svg(glyph, type)
    FA_ICON_SVGS.fetch("#{glyph}-#{type}")
  end
end
