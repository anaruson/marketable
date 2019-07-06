class CreateDomains < ActiveRecord::Migration[5.2]
  def change
    create_table :domains do |t|
      t.string :name, index: true, required: true, unique: true
      t.timestamp :expiration
      t.boolean :available, index: true
      t.boolean :registered, index: true
      t.timestamp :registered_at
      t.timestamp :processed_at
      t.text :whois_data

      t.timestamps
    end
  end
end
