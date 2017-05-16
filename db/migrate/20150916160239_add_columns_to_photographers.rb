class AddColumnsToPhotographers < ActiveRecord::Migration
  def change
    add_column :photographers, :nams, :string
    add_column :photographers, :studio_name, :string
    add_column :photographers, :street, :string
    add_column :photographers, :zipcode, :string
    add_column :photographers, :city, :string
    add_column :photographers, :country, :string
    add_column :photographers, :mobile_number, :string
    add_column :photographers, :office_number, :string
    add_column :photographers, :website, :string
    add_column :photographers, :facebook, :string
    add_column :photographers, :twitter, :string
    add_column :photographers, :instagram, :string
    add_column :photographers, :logo, :string
  end
end
