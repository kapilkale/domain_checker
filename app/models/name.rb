class Name < ActiveRecord::Base
  # attr_accessible :title, :body
  def self.schedule_jobs
    file = File.open('word_list.txt')
    file.each_line do |word|
      Name.delay.create_or_update(word)
    end
    puts "jobs in DJ"
  end

  def self.create_or_update(word)
    # No duplicates.
    return if Name.find_by_domain(word)

    agent = Mechanize.new
    c = Whois::Client.new
    whois = c.query("#{word.strip}.com")
    page_registered = whois.registered?

    if page_registered
      begin
        page = agent.get("http://www.#{word.strip}.com")
        #list_of_redirects = agent.history.inspect
        final_domain = agent.history.last.uri.to_s
        page_parked = page.parked?(final_domain)
      rescue
        page_parked = true
      end
    end
    n = Name.new
    n.domain = word.strip
    n.registered = page_registered
    n.redirect_domain = final_domain
    n.parked = page_parked
    n.save
  end
end
