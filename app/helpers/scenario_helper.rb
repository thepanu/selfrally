# Scenaario view helpers
module ScenarioHelper
  # TODO: Tarvii korjata turvalliseksi
  def publication_line(scenario_publication)
    publication = scenario_publication.publication
    publisher = publication.publisher
    format('<div><strong>%<year>s</strong> by %<publisher>s in %<publication>s %<code>s</div>',
           year: publication.publishing_year,
           publisher: publisher_link(publisher),
           publication: publication_link(publication),
           code: scenario_publication.code).html_safe
  end

  def publisher_link(publisher)
    link_to(publisher.name, publisher)
  end

  def publication_link(publication)
    link_to(publication.name, publication)
  end

  def force_counter(force, scenario)
    html = ''
    force.scenarios_counters(scenario.id).each do |counter|
      html << "#{counter}<br>"
    end
    html.html_safe
  end

  def map_list(maps)
    maps.pluck(:name).join(', ').html_safe
  end

  def overlay_list(overlays)
    overlays.pluck(:name).join(', ').html_safe
  end
end
