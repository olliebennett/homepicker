# frozen_string_literal: true

module HomesHelper
  def render_home_changeset_price(version)
    return unless version.changeset.key?('price')

    from, to = version.changeset['price']

    prefix = "#{version.created_at.strftime('%d/%m/%Y')} : Price "

    return tag.p("#{prefix} set to #{to}.") if from.nil?

    tag.p("#{prefix} #{from.to_i > to.to_i ? 'decreased' : 'increased'} from #{from} to #{to}.")
  end

  def render_home_changeset_listing_status(version)
    return unless version.changeset.key?('listing_status')

    from, to = version.changeset['listing_status']

    prefix = "#{version.created_at.strftime('%d/%m/%Y')} : Listing status "

    return tag.p("#{prefix} set to #{to}.") if from.nil?

    tag.p("#{prefix} changed from #{from} to #{to}.")
  end
end
