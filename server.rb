require "sinatra"
require "sinatra/activerecord"
require "json"

# Configuration

set :database, "sqlite3:///db/db.sqlite3"
ActiveRecord::Base.include_root_in_json = false

# Model

class Course < ActiveRecord::Base
end

# Routes

get '/' do
  @json = Course.all.to_json
  erb :index
end

get '/courses.json' do
  content_type :json
  Course.all.to_json
end