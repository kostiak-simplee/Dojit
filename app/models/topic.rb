require 'wikipedia'

class Topic < ActiveRecord::Base
  has_many :posts, dependent: :destroy

  scope :publicaly_viewable, -> { where(public: true) }
  scope :privately_viewable, -> { all }
  scope :visible_to, -> (user){ user ? privately_viewable : publicaly_viewable }

  before_save do
    begin
      wiki_obj = Wikipedia.find(self.name)
      if wiki_obj && wiki_obj.text
        text = wiki_obj.text[0..800]
        text = text[0..text.rindex(/ /)-1] + "..."
        self.wikipedia_text = text
        self.wikipedia_link = wiki_obj.fullurl
      end
    rescue SocketError
      Rails.logger.warn { "Failed to connect to wikipedia to get description for topic. "}
    end
  end
end