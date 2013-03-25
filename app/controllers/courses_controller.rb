class CoursesController < ApplicationController

  def index
    @courses = Course.all

    respond_to do |format|
      format.html
      format.json { render :json => @posts }
    end
  end
end
