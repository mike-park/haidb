class SummaryAngelDecorator < Draper::Decorator
  delegate :full_name, :id, :email, :gravatar

  def address
    h.br(h.compact_address(model))
  end

  def phones
    h.compact_phones(model)
  end

  def created_at
    datetime(model.created_at)
  end

  def updated_at
    datetime(model.updated_at)
  end

  def <=>(other)
    id <=> other.id
  end

  private

  def datetime(dt)
    dt.strftime("%d.%m.%Y %H:%M") if dt
  end
end
