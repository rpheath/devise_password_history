class CreateOldPasswords < ActiveRecord::Migration
  def self.up
    create_table :old_passwords do |t|
      t.string :encrypted_password, :null => false
      t.string :password_salt
      t.string :password_history_type, :null => false
      t.integer :password_history_id, :null => false 
      t.datetime :created_at
    end
  end

  def self.down
    drop_table :old_passwords
  end
end