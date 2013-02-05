require 'mechanize'
# Monkeypatching.
Mechanize::Page.class_eval do
  def parked?(final_domain)
    # Links like '/page'
    relative_internal_links = links.select{|l| l.uri.to_s.length > 0 && l.uri.to_s[0] == '/'}

    # Links like 'domain/page'
    absolute_internal_links = links.select{|l| l.uri.to_s.include?(final_domain) && l.uri.to_s.length > final_domain.length + 3}

    # Page is parked if no internal pointing links
    absolute_internal_links.count + relative_internal_links.count == 0
  end
end