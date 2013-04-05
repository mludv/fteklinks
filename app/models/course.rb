class Course < ActiveRecord::Base
  attr_accessible :name, :url, :year, :program, :period

  validates :program, :inclusion => { :in => %w(fysik matematik)}

end
