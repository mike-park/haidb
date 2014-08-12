class Team < ActiveRecord::Base
  belongs_to :event
  has_many :members, inverse_of: :team, dependent: :destroy
  has_many :messages, as: :source

  scope :upcoming, -> { where('date >= ?', Date.current) }
  scope :previous, -> { where('date < ?', Date.current) }
  scope :by_date, -> { order('date asc') }
  scope :by_date_desc, -> { order('date desc') }

  validates_uniqueness_of :event_id, allow_nil: true, message: 'A team already exists for this event'
  validates_presence_of :name, :date

  def display_name
    "Team for #{event.display_name}"
  end

  def stats
    @stats ||= TeamStats.new(self)
  end
end
