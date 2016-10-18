class CreateResources < ActiveRecord::Migration[5.0]
  def change
    create_table :resources do |t|
      t.string :name
      t.string :locked_by
      t.time   :locked_until
    end
  end
end
