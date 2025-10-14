class Api::V1::CoursesController < ApplicationController

   def index
    @current_trimester = Trimester.where("start_date <= ?", Date.today).where("end_date >= ?", Date.today).first
    courses = @current_trimester.courses
    coding_class = 
    courses_hash = []

    courses.each do |course| 
        courses_hash << 
            {id: course.id,
        title: CodingClass.find_by(id: course.coding_class_id)&.title,
        application_deadline: @current_trimester.application_deadline,
        start_date: @current_trimester.start_date,
    end_date: @current_trimester.end_date
    }
    end
    
    render json: courses_hash, status: :ok
  end

end