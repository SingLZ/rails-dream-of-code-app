# app/controllers/api/v1/enrollments_controller.rb
class Api::V1::EnrollmentsController < ApplicationController
  # If this endpoint requires auth, keep your require_admin here as needed:
  # before_action :require_admin

  def index
    course = Course.find(params[:course_id])
    enrollments = course.enrollments.includes(:student) # eager-load students

    payload = enrollments.map do |e|
      {
        id: e.id,
        studentId: e.student_id,
        studentFirstName: e.student&.first_name,
        studentLastName: e.student&.last_name,
        finalGrade: e.respond_to?(:final_grade) ? e.final_grade : e.student&.final_grade
      }
    end

    render json: { enrollments: payload }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "not_found" }, status: :not_found
  end
end
