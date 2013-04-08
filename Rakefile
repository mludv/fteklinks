#!/usr/bin/env rake

require "sinatra/activerecord/rake"
require "./server"

#     Scraping task
############################

require 'mechanize'
require 'uri'


require 'rack/test'

# Hack to get sinatras methods to work, navigate to an url
class Builder
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def build
    get '/build'
  end
end

task :build do
  b = Builder.new
  b.build()
end

task :scrape do

  # Kurslistan för F
  url_f = 'https://student.portal.chalmers.se/sv/chalmersstudier/programinformation/Sidor/SokProgramutbudet.aspx?program_id=879&parsergrp=1'
  # Kurslistan för TM
  url_tm = 'https://student.portal.chalmers.se/sv/chalmersstudier/programinformation/Sidor/SokProgramutbudet.aspx?program_id=904&parsergrp=1'
  

  agent = Mechanize.new
  page = agent.get(url_f)
  
  if Course.delete_all()
    puts 'Tog bort alla gamla kurser'
  end

  # F
  #####

  # Årskurs 1
  get_courses(page, {:year => 1, :program => 'f'})

  # Årskurs 2
  page = agent.page.link_with(:text => '2').click
  get_courses(page, {:year => 2, :program => 'f'})

  # Årskurs 3
  page = agent.page.link_with(:text => '3').click
  get_courses(page, {:year => 3, :program => 'f'})

  # TM
  ######

  page = agent.get(url_tm)
  
  # Årskurs 1
  get_courses(page, {:year => 1, :program => 'tm'})

  # Årskurs 2
  page = agent.page.link_with(:text => '2').click
  get_courses(page, {:year => 2, :program => 'tm'})

  # Årskurs 3
  page = agent.page.link_with(:text => '3').click
  get_courses(page, {:year => 3, :program => 'tm'})
end

# Search the course-list for the links
def get_courses(page, info)
  page.search("#WebPartWPQ1").each do |node|

    info[:period] = 0

    # För varje rad i tabellen:
    node.search("./div/div/table[3]//td").each do |node|
      
      # Måste kolla efter läsperiod
      if node.text =~ /läsperiod/i
        info[:period] = node.text.match(/\d/).to_s.to_i
      end
      
      # Vi kanske har en länk, isåfall vill vi spara kurshemsidan:
      node.search(".//a").each do |node|
        # Hämta kurshemsidan
        course_page = fetch_coursepage(make_absolute(node['href']))
        # Spara i databasen
        save_coursepage(node.text, course_page, info)
      end
    end
  end
end

# Går in på den kursspecifika sidan och hämtar kurshemsidan
def fetch_coursepage(url)
  agent = Mechanize.new
  page = agent.get(url)
  link = page.link_with(:text => 'Gå till kurshemsida')
  return link ? make_absolute(link.href) : nil
end

# Sparar kurshemsidan i databasen
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
  puts "==================================\n\n"
end

# Lägger till grund-hemsidan till alla relativa länkar
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