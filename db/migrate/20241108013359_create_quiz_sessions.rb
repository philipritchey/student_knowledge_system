class CreateQuizSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :quiz_sessions do |t|
      t.references :user, null: false, foreign_key: true      # Associate with user
      t.json :courses_filter, default: []                    # Store array of course filters
      t.json :semesters_filter, default: []                  # Store array of semester filters
      t.json :sections_filter, default: []                   # Store array of section filters
      t.json :quiz_data, default: {}                         # Store any other quiz data
      t.integer :current_score, default: 0                    # Track the score
      t.datetime :expires_at                                  # Optional expiration timestamp

      t.timestamps
    end

    add_index :quiz_sessions, :expires_at                     # Index for quick expiration checks
  end
end
