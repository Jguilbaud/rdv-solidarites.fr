# frozen_string_literal: true

class FakeRemoveNotesAndLogementFromProfiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :user_profiles, :logement
    remove_column :user_profiles, :notes
  end
end
