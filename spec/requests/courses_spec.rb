require 'rails_helper'

RSpec.describe "Courses", type: :request do
  describe "GET /courses/:id" do
    before do
      coding_class = CodingClass.create!(title: "Intro to Programming")
      trimester = Trimester.create!(
        term: "Fall",
        year: Date.today.year,
        start_date: Date.today - 1.month,
        end_date: Date.today + 2.months,
        application_deadline: Date.today - 2.weeks
      )

      # Create a course that belongs to both
      @course = Course.create!(
        coding_class: coding_class,
        trimester: trimester
      )

      # Create a student
      student = Student.create!(
        first_name: "Kyoko",
        last_name: "Tanaka",
        email: "kyoko@example.com"
      )

      # Link the student to the course via enrollment
      Enrollment.create!(course: @course, student: student)
    end

    it "returns a 200 OK status" do
      get course_path(@course)
      expect(response).to have_http_status(:ok)
    end

    it "displays the course name" do
      get course_path(@course)
      expect(response.body).to include("Intro to Programming")
    end

    it "displays the name of a student enrolled in the course" do
      get course_path(@course)
      expect(response.body).to include("Kyoko")
    end
  end
end
