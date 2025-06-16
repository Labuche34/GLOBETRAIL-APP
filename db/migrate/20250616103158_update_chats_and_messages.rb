class UpdateChatsAndMessages < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :title, :string
    add_column :chats, :model_id, :string
    add_reference :chats, :travel, null: false, foreign_key: true
    add_reference :chats, :user, null: false, foreign_key: true

    add_column :messages, :role, :string
    add_column :messages, :content, :string
    add_reference :messages, :chat, foreign_key: true
  end
end
