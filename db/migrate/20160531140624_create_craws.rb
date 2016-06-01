class CreateCraws < ActiveRecord::Migration
  def change
    create_table :craws do |t|

      t.timestamps null: false
    end
  end
end
