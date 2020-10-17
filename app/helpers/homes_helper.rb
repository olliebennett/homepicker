module HomesHelper
  def render_home_changeset(version)
    return unless version.changeset.key?('price')

    from, to = version.changeset['price']

    prefix = "#{version.created_at.strftime('%d/%m/%Y')} : Price "

    return "#{prefix} set to #{to}." if from.nil?

    tag.p("#{prefix} #{from.to_i > to.to_i ? 'decreased' : 'increased'} from #{from} to #{to}.")
  end
end
