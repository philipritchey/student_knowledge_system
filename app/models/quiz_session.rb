class QuizSession < ApplicationRecord
  belongs_to :user

  serialize :courses_filter, Array
  serialize :semesters_filter, Array
  serialize :sections_filter, Array

  attribute :streak, :integer, default: 0
  attribute :total_questions, :integer, default: 0
  attribute :correct_answers, :integer, default: 0


  attribute :answer, :string
  attribute :correct_student_id, :string

  def increment_streak
    self.streak += 1
    save
  end

  def reset_streak
    self.streak = 0
    save
  end

  def increment_total_questions(correct: false)
    self.total_questions += 1
    self.correct_answers += 1 if correct
    save
  end

  def accuracy
    return 0 if total_questions.zero?
    (correct_answers.to_f / total_questions * 100).round(2)
  end

  def add_course_filter(course)
    self.courses_filter << course
    save
  end

  def add_semester_filter(semester)
    self.semesters_filter << semester
    save
  end

  def add_section_filter(section)
    self.sections_filter << section
    save
  end
end