class AddAnswerAndCorrectStudentIdToQuizSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :quiz_sessions, :answer, :integer
    add_column :quiz_sessions, :correct_student_id, :integer
  end
end
