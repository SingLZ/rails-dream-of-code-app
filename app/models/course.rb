class Course < ApplicationRecord
  belongs_to :coding_class
  belongs_to :trimester
  has_many :enrollments

  delegate :title, to: :coding_class

  def student_name_list
    name_list=[]
    self.enrollments.each do |enrollment|
      name_list << "#{enrollment.student.first_name} #{enrollment.student.last_name}"
    end
    name_list
  end

  def student_email_list
    email_list=[]
    self.enrollments.each do |enrollment|
      email_list << "#{enrollment.student.email}"
    end
    email_list
  end
end
