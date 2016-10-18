class PopulateResources < ActiveRecord::Migration[5.0]
  def change
    Resource.create(name: 'development')
    Resource.create(name: 'staging')
    Resource.create(name: 'browserstack')
  end
end
