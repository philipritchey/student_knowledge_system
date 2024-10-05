# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :require_user!
  # before_action :authenticate_user!
  # before_action :authenticate_by_session

  def index
    @current_user = current_user
    @id = current_user.email
    @dueStudents = Student.getDue(@id)
  end

  def stripYear(var)
    tmp = var.strip
    idx = tmp.rindex(' ')
    unless idx.nil?
      idx += 1
      tmp = tmp[idx..].strip
    end
    tmp
  end

  def getYears
    sems = Course.where(teacher: @id)
    uniqSems = Set.new
    sems.each do |s|
      year = stripYear(s.semester)
      uniqSems << year
    end
    uniqSems.length
  end
  helper_method :getYears

  def getNumDue
    @dueStudents.length
  end
  helper_method :getNumDue

  def getDueStudentQuiz
    return home_path unless @dueStudents.length.positive?

    student = @dueStudents.sample
    quiz_students_path(student)
  end
  helper_method :getDueStudentQuiz
end
