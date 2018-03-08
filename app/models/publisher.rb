class Publisher < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  paginates_per 15

  filterrific(
    default_filter_params: { sorted_by: 'name_asc' },
    available_filters: [
      :sorted_by,
      :search_query,
    ]
  )
  has_many :publications
  has_many :scenarios, through: :publications
  has_many :games, through: :scenarios

  scope :search_query, lambda { |query|
    where("name ILIKE ?", "%#{sanitize_sql_like(query)}%")
  }
  scope :sorted_by, lambda { |sort_key|
    direction = (sort_key =~ /desc$/) ? 'desc' : 'asc'
    case sort_key.to_s
    when /^name_/
      order("name #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
      ['name (a-z)', 'name_asc'],
      ['name (z-a)', 'name_desc']
    ]
  end
end
