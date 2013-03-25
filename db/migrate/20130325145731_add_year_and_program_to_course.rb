class AddYearAndProgramToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :year, :integer
    add_column :courses, :program, :string
  end
end
