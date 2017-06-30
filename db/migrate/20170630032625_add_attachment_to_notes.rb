class AddAttachmentToNotes < ActiveRecord::Migration[5.1]
  def up
    add_attachment :notes, :attachment
  end

  def down
    remove_attachment :notes, :attachment
  end
end
