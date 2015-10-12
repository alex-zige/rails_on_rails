class AddAdditonalFieldsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_attachment :users, :profile_image
  end

   def down
    remove_column :users, :star_rating
    remove_column :users, :company_name
    remove_attachment :users, :profile_image
  end
end
