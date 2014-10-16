class DirectDebt
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def persisted?
    false
  end

  ATTRIBUTES = [:event, :post_date, :debt_send_date, :comment, :to_iban, :checked, :send_emails]
  attr_accessor *ATTRIBUTES

  validates_presence_of :event, :post_date, :debt_send_date, :to_iban, :comment

  def self.new_from(event)
    to_iban = SiteDefault.get('direct_debt.to_iban')
    comment = "#{event.display_name} Workshopfee"
    post_date = I18n.localize(event.start_date - 4, locale: 'de')
    debt_send_date = I18n.localize(event.start_date - 7, locale: 'de')
    new(event: event, to_iban: to_iban, comment: comment, post_date: post_date, debt_send_date: debt_send_date)
  end

  def initialize(attrs = {})
    ATTRIBUTES.each do |name|
      send("#{name}=", attrs[name]) if attrs.has_key?(name)
    end
  end

  def registrations
    event.registrations.approved.by_first_name.to_a.reject do |r|
      r.owed.to_i == 0 || r.iban.blank? || r.bic.blank?
    end
  end

  def checked
    @checked ||= []
  end

  def checked=(values)
    @checked = values
  end

  def checked?(id)
    checked.include?(id.to_s)
  end

  def checked_registrations
    event.registrations.find(checked)
  end

  def send_emails?
    send_emails == 'Yes'
  end

  def to_csv
    CSV.generate(force_quotes: false, encoding: 'utf-8', col_sep: ';') do |csv|
      csv << csv_header
      checked_registrations.each do |reg|
        csv << [
            reg.bank_account_name,
            reg.iban,
            reg.bic,
            'EUR',
            de_currency(reg.owed),
            de_currency(reg.owed),
            comment,
            16,
            'CDS',
            post_date,
            'ei',
            to_iban,
            reg.registration_code,
            I18n.localize(reg.created_at.to_date, locale: 'de'),
            1,
            comment,
            0
        ]
      end
    end
  end

  def total
    checked_registrations.sum(&:owed)
  end

  private

  def de_currency(number)
    number.to_s.gsub(/\./, ',')
  end

  def csv_header
    'Begünstigter;IBAN;BIC;Währung;Rechnungsbetrag;Betrag;Verwendungszweck;Textschlüssel;Art;Auftrag ausführen am;Mandatsstatus;Gläubiger ID;Mandatsreferenz;Ausstellungsdatum des Mandats;Automatisch letztmalig;End-To-End Referenz;Offline verwalten'.split(/;/)
  end
end