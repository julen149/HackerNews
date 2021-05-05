class AddFieldToContributions < ActiveRecord::Migration[6.1]
  def change
    add_column :contributions, :title, :string
  end
end
