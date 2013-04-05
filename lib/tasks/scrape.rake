require 'mechanize'
require 'uri'

task :scrape => :environment do
  url = 'https://student.portal.chalmers.se/sv/chalmersstudier/programinformation/Sidor/SokProgramutbudet.aspx?program_id=879&parsergrp=1'
  agent = Mechanize.new
  page = agent.get(url)

  if Course.delete_all()
    puts 'Tog bort alla gamla kurser'
  end

  # Årskurs 1
  get_courses(page, {:year => 1, :program => 'fysik'})

  # Årskurs 2
  page = agent.page.link_with(:text => '2').click
  get_courses(page, {:year => 2, :program => 'fysik'})

  # Årskurs 3
  page = agent.page.link_with(:text => '3').click
  get_courses(page, {:year => 3, :program => 'fysik'})

end

def get_courses(page, info)
  page.search("#WebPartWPQ1").each do |node|
    info[:period] = 0
    node.search("./div/div/table[3]//td").each do |node|
      if node.text =~ /läsperiod/i
        info[:period] = node.text.match(/\d/).to_s.to_i
      end
      node.search(".//a").each do |node|
        course_page = fetch_coursepage(make_absolute(node['href']))
        save_coursepage(node.text, course_page, info)
      end
    end
  end
end

def fetch_coursepage(url)
  agent = Mechanize.new
  page = agent.get(url)
  link = page.link_with(:text => 'Gå till kurshemsida')
  return link ? make_absolute(link.href) : nil
end

def save_coursepage(name, url, info)
  if name
    c = Course.create!(
            :name => name,
            :url => url,
            :year => info[:year],
            :program => info[:program],
            :period => info[:period]
          )
  end
  
  if url and c
    puts "#{name} är nu sparad!"
  elsif not c
    puts "#{name} kunde inte sparas"
  else
    puts "Ingen kurshemsida hittades för #{name}"
  end
end

def make_absolute(url)
  begin
    uri = URI(url)
  rescue
    puts 'Fel format på url'
    return nil
  end
  
  if uri.absolute?
    return url
  else
    root = 'https://student.portal.chalmers.se'
    return URI(root).merge(url).to_s
  end
end