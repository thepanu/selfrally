# Scenario model
class Scenario < ApplicationRecord
  include PgSearch

  extend FriendlyId
  friendly_id :name, use: :slugged
  paginates_per 15
  filterrific(
    default_filter_params: { sorted_by: 'name_asc' },
    available_filters: %i[
      sorted_by
      search_query
    ]
  )
  belongs_to :location
  has_many :scenario_publications
  has_many :publications, through: :scenario_publications
  has_many :games
  has_many :scenario_forces, inverse_of: :scenario
  has_many :forces, through: :scenario_forces
  has_many :scenario_counters, inverse_of: :scenario
  has_many :counters, through: :scenario_counters
  has_many :scenario_rules, inverse_of: :scenario
  has_many :rules, through: :scenario_rules
  has_many :ribbons, through: :rules
  has_many :scenario_maps, inverse_of: :scenario
  has_many :maps, through: :scenario_maps
  has_many :scenario_overlays
  has_many :overlays, through: :scenario_overlays
  has_many :comments, -> { order(updated_at: :asc) }, as: :commentable

  accepts_nested_attributes_for :scenario_forces, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :scenario_rules, allow_destroy: true
  accepts_nested_attributes_for :scenario_maps, allow_destroy: true
  accepts_nested_attributes_for :scenario_counters, allow_destroy: true

  pg_search_scope :search,
                  against: %i[name],
                  using: {
                    tsearch: { prefix: true }
                  }

  after_initialize :init

  scope :search_query, lambda { |query|
    where('name ILIKE ?', "%#{sanitize_sql_like(query)}%")
  }
  scope :sorted_by, lambda { |sort_key|
    direction = sort_key.match?(/desc$/) ? 'desc' : 'asc'
    case sort_key.to_s
    when /^name_/
      order("name #{direction}")
    else
      raise(ArgumentError, "Invalid sort option: #{sort_key.inspect}")
    end
  }

  def init
    self.scenario_date ||= Date.new(1942, 6, 30)
  end

  def belligerents
    forces.pluck(:name).map(&:capitalize).join(' - ')
  end

  def initiative
    scenario_forces.order(initiative: :desc).first.force.name
  end

  def self.options_for_sorted_by
    [
      ['name (a-z)', 'name_asc'],
      ['name (z-a)', 'name_desc']
    ]
  end
end
