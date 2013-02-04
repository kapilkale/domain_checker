class CreateNames < ActiveRecord::Migration
  def change
    create_table :names do |t|
      t.string :domain, :unique => true
      t.boolean :registered
      t.string :redirect_domain
      t.boolean :parked
      t.timestamps
    end
  end
end
