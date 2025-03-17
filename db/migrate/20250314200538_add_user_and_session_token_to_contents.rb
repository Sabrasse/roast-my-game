class AddUserAndSessionTokenToContents < ActiveRecord::Migration[7.1]
  def change
    # Add user reference with foreign key and index
    add_reference :contents, :user, foreign_key: true, null: true
    
    # Add session token with index
    add_column :contents, :session_token, :string
    add_index :contents, :session_token

    # Add index for expiring content queries
    add_index :contents, :created_at
  end
end
