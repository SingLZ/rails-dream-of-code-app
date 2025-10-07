class SubmissionsController < ApplicationController
  # GET /submissions/new
  before_action :set_enrollment
  before_action :set_submission, only: [:edit, :update, :show, :destroy]
  before_action :require_student, only: [:new, :create]
  before_action :require_mentor, only: [:edit, :update]

  def new
    @submission = Submission.new
    @enrollments = @course.enrollments  # TODO: What set of enrollments should be listed in the dropdown?
    @lessons = @course.lessons    # TODO: What set of lessons should be listed in the dropdown?
    @students = @course.enrollments.includes(:student).map(&:student)
  end

  def create
    @submission = Submission.new(submission_params)

    if @submission.save
      redirect_to course_path(@course), notice: 'Submission was successfully created.'
    else
      @enrollments = @course.enrollments
      @lessons = @course.lessons
      @students = @course.enrollments.includes(:student).map(&:student)
      render :new
    end
  end

  # GET /submissions/1/edit
  def edit
  end

  # PATCH/PUT /submissions/1 or /submissions/1.json
  def update
  end

  private
    def set_enrollment
      @enrollment = Enrollment.find(params[:enrollment_id])
    end

    def set_submission
      @submission = @enrollment.submissions.find(params[:id])
    end
    # Only allow a list of trusted parameters through.
    def submission_params
      params.require(:submission).permit(:lesson_id, :enrollment_id, :mentor_id, :review_result, :reviewed_at)
    end
end
