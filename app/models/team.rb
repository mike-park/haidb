class Team < ActiveRecord::Base
  belongs_to :event
  has_many :members, dependent: :destroy

  scope :upcoming, -> { where('date >= ?', Date.current) }
  scope :previous, -> { where('date < ?', Date.current) }
  scope :by_date, -> { order('date asc') }
  scope :by_date_desc, -> { order('date desc') }

  validates_uniqueness_of :event_id, allow_nil: true, message: 'A team already exists for this event'
  validates_presence_of :name, :date

  def stats
    @stats ||= TeamStats.new(self)
  end
end
