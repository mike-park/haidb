class SimilarAngelDecorator < Draper::Decorator
  delegate_all
  decorates_association :angels, with: SummaryAngelDecorator

  def angel_ids
    angels.map(&:id).join(",")
  end
end
