# frozen_string_literal: true

module FontAwesomeHelper
  # Add any new icons in fontawesome_icons.yml
  FA_ICON_SVGS = YAML.safe_load(File.read(Rails.root.join('lib/assets/fontawesome_icons.yml'))).freeze

  def fa_icon_inline(glyph, type: :solid, cls: '')
    x = fa_icon_svg(glyph, type).dup
    x.gsub!('class="', "class=\"#{cls} ") if cls.present? # add custom classes
    x.html_safe
  end

  private

  def fa_icon_svg(glyph, type)
    FA_ICON_SVGS.fetch("#{glyph}-#{type}")
  end
end
