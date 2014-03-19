class Team < ActiveRecord::Base
  belongs_to :event

  scope :upcoming, -> { where('date >= ?', Date.current) }
  scope :previous, -> { where('date < ?', Date.current) }
  scope :by_date, -> { order('date asc') }
  scope :by_date_desc, -> { order('date desc') }

  validates_uniqueness_of :event_id, allow_nil: true, message: 'A team already exists for this event'
  validates_presence_of :name, :date
end
