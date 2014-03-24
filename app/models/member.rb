class Member < ActiveRecord::Base
  belongs_to :angel, inverse_of: :members
  belongs_to :team, inverse_of: :members
  belongs_to :membership, inverse_of: :members

  validates_presence_of :angel, :team, :membership, :full_name, :gender
  validates_inclusion_of :gender, :in => Registration::GENDERS, :message => :select
  validates_uniqueness_of :angel_id, scope: :team_id, message: 'Already signed up on this team'

  scope :males, -> { where(gender: Registration::MALE).order('id asc') }
  scope :females, -> { where(gender: Registration::FEMALE).order('id asc') }

  ROLES = [TEAMCO="TeamCo", TRANSLATOR="Translator"]

end
