# frozen_string_literal: true

class AddPrescripteurs < ActiveRecord::Migration[6.1]
  def change
    add_enum_value :user_created_through, "prescripteur"

    create_table :prescripteurs do |t|
      t.bigint :rdv_id, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone_number
      t.timestamps null: false
    end

    add_index :prescripteurs, :rdv_id, unique: true
  end
end
