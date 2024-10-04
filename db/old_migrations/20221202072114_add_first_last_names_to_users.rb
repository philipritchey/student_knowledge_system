# frozen_string_literal: true

class AddFirstLastNamesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :firstname, :string, default: ''
    add_column :users, :lastname, :string, default: ''
  end
end
