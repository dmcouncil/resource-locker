class UpdateResources < ActiveRecord::Migration[5.0]
  def change
    change_column :resources, :locked_until, :datetime
    add_index :resources, :name

    r = Resource.find_by_name('development')
    r.name = 'ds-development'
    r.save
    r = Resource.find_by_name('staging')
    r.name = 'ds-staging'
    r.save
    Resource.create(name: 'dp-development')
    Resource.create(name: 'dp-staging')
  end
end
