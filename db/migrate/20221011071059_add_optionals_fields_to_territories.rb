class AddOptionalsFieldsToTerritories < ActiveRecord::Migration[6.1]
  def change
    add_column :territories, :enable_mail_to_agent_field, :boolean, default: false
    add_column :territories, :enable_changing_button_color_field, :boolean, default: false
  end
end
