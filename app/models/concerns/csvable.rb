require 'csv'

module Csvable
  extend ActiveSupport::Concern

  included do
  end

  module ClassMethods
    def csv_fields(*names)
      @csv_fields = names
    end

    def to_csv(array, csv_fields = @csv_fields)
      return unless csv_fields
      CSV.generate(:force_quotes => true, :encoding => 'utf-8') do |csv|
        csv << csv_header(csv_fields)
        array.each do |a|
          csv << csv_fields.map {|f| a.send(f) }
        end
      end
    end

    private

    def csv_header(csv_fields)
      csv_fields.map { |f| f.to_s.humanize }
    end
  end
end
