class CoursesController < ApplicationController

  def index
    @courses = Course.where(:year => 2)

    respond_to do |format|
      format.html
      format.json { render :json => @posts }
    end
  end
end
