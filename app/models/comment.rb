# Comment module to handle all comments
class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :replies, class_name: 'Comment',
                     foreign_key: 'parent_id'

  belongs_to :parent, class_name: 'Comment', optional: true
end
