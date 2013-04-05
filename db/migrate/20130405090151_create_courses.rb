class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string   "name"
      t.string   "url"
      t.integer  "year"
      t.string   "program"
      t.integer  "period"
      t.timestamps
    end
  end
end
