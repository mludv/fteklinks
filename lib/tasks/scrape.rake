require 'mechanize'

task :scrape => :environment do
  url = 'https://student.portal.chalmers.se/sv/chalmersstudier/programinformation/Sidor/SokProgramutbudet.aspx?program_id=879&parsergrp=1'
  agent = Mechanize.new
  page = agent.get(url)

  # Årskurs 1
  get_courses(page)

  # Årskurs 2
  page = agent.page.link_with(:text => '2').click
  get_courses(page)

  # Årskurs 3
  page = agent.page.link_with(:text => '3').click
  get_courses(page)

end

def get_courses(page)
  page.search("#WebPartWPQ1").each do |node|
    node.search("./div/div/table[3]//a").each do |node|
      course_page = fetch_coursepage('https://student.portal.chalmers.se' + node['href'])
      save_coursepage(node.text, course_page)
    end
  end
end

def fetch_coursepage(url)
  agent = Mechanize.new
  page = agent.get(url)
  link = page.link_with(:text => 'Gå till kurshemsida')
  return link ? link.href : nil
end

def save_coursepage(name, url)
  if name
    c = Course.create! :name => name, :url => url
  end
  
  if url and c
    puts "#{name} är nu sparad!"
  elsif not c
    puts "#{name} kunde inte sparas"
  else
    puts "Ingen kurshemsida hittades för #{name}"
  end
end