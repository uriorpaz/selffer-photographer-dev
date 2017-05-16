class RemoveCounterFromLinks < ActiveRecord::Migration
  def change
    remove_column :links, :counter, :integer
  end
end
