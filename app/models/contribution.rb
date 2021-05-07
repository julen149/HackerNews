class Contribution < ApplicationRecord
    belongs_to :user
    has_many :vote
    belongs_to :parent, :class_name => 'Contribution', optional: true
    has_many :replies, :class_name => 'Contribution', foreign_key: "parent_id", dependent: :destroy
    
    validates :url, :format => URI::regexp(%w(http https)), if: -> {contr_type=='post' and contr_subtype=='url'}
    validates :user_id, presence: true
    validates :contr_subtype, presence: true, if: -> {contr_type=='post'}
    validates :title, presence: true, if: -> {contr_type=='post'}
    validates :content, presence: true, if: -> {contr_type=='post' and contr_subtype=='ask'}
    validates :parent, presence: true, if: -> {contr_type!='post'}
    validates :user, presence: true
    validates :url, uniqueness: true, if: -> {contr_subtype=='url'}
    
    after_initialize :init

    def init
      self.upvote ||= 0
        if self.url.blank?
          self.contr_subtype='ask'
        elsif self.content.blank?
          self.contr_subtype='url'
        end
    end
end
