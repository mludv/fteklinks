require "sinatra"
require "sinatra/activerecord"
require "json"

# Configuration

configure :development do
  set :database, "sqlite3:///db/db.sqlite3"
end


ActiveRecord::Base.include_root_in_json = false

# Model

class Course < ActiveRecord::Base
end

# Routes

get '/' do
  @dev = true
  @json = Course.all.to_json
  erb :index
end

get '/build' do
  @dev = false
  filename = 'public/index.html'
  @json = Course.all.to_json
  File.open(filename, 'w') do |f|
    f.write erb :index
  end
  puts 'Created ' + filename
end

get '/courses.json' do
  content_type :json
  Course.all.to_json
end