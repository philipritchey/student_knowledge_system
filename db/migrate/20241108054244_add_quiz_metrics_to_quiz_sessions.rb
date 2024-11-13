# frozen_string_literal: true

class AddQuizMetricsToQuizSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :quiz_sessions, :streak, :integer, default: 0
    add_column :quiz_sessions, :total_questions, :integer, default: 0
    add_column :quiz_sessions, :correct_answers, :integer, default: 0
  end
end
