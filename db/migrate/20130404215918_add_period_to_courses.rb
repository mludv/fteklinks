class AddPeriodToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :period, :integer
  end
end
