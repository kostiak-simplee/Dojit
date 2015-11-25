require 'wikipedia'

class Topic < ActiveRecord::Base
  has_many :posts

  before_save do
    wiki_obj = Wikipedia.find(self.name)
    if wiki_obj && wiki_obj.text
      text = wiki_obj.text[0..800]
      text = text[0..text.rindex(/ /)-1] + "..."
      puts "#{self.inspect}"
      puts "#{self.methods - Object.methods}"
      self.wikipedia_text = text
      puts "#{self.inspect}"
      self.wikipedia_link = wiki_obj.fullurl
    end
  end
end