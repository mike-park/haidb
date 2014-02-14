class SimilarAngel
  attr_reader :title, :angels

  def initialize(title, angels)
    @title = title
    @angels = angels
  end

  def <=>(other)
    title <=> other.title
  end

  def self.find_by_email
    find_by_match do |angel|
      angel.email.downcase
    end
  end

  def self.find_by_name
    find_by_match do |angel|
      angel.full_name.downcase
    end
  end

  def to_partial_path
    "similar_angel"
  end

  def to_key
    ['similar_angel']
  end

  private

  def self.find_by_match(&block)
    Angel.all.group_by(&block).find_all {|x| x[1].length > 1}.map do |name, angels|
      title = angels.first.full_name
      new(title, angels)
    end
  end
end