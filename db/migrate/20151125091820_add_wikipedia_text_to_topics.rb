class AddWikipediaTextToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :wikipedia_text, :string
    add_column :topics, :wikipedia_link, :string
  end
end
