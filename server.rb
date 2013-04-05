require "sinatra"
require "sinatra/activerecord"
require "json"

# Database configuration

set :database, "sqlite3:///db/db.sqlite3"

# Model

class Course < ActiveRecord::Base
end

# Routes

get '/' do
  @courses = Course.all
  erb :index
end

get '/courses.json' do
  content_type :json
  Course.all.to_json
end