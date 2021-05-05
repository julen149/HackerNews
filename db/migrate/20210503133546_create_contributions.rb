class CreateContributions < ActiveRecord::Migration[6.1]
  def change
    create_table :contributions do |t|
      t.string :contr_type
      t.string :contr_subtype
      t.text :content
      t.integer :user_id
      t.string :url
      t.integer :upvote
      t.integer :parent_id

      t.timestamps
    end
  end
end
