class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string   "name"
      t.string   "url"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.integer  "year"
      t.string   "program"
      t.integer  "period"
    end
  end
end
