module FontAwesomeHelper
  def fa_icon(glyph, type: :solid, text: nil)
    fa_prefix = case type
                when :solid
                  'fas'
                when :light
                  'fal'
                when :regular
                  'far'
                when :duotone
                  'fad'
                else
                  raise "Unexpected FontAwesome type; #{type}; expected regular/solid/light/duotone"
                end
    content_tag(:i, text, class: "#{fa_prefix} fa-#{glyph}")
  end
end
