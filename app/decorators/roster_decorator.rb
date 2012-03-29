# encoding: utf-8

class RosterDecorator < ApplicationDecorator
  decorates :roster

  def to_pdf
    # HACK ALERT!
    if Site.de?
      I18n.locale = :de
    else
      I18n.locale = :en
    end

    h.content_for_prawn(title: title, warning: warning) do |pdf|
      pdf.font "Times-Roman"
      pdf.font_size(10)
      [Registration::PARTICIPANT,
       Registration::TEAM,
       Registration::FACILITATOR].each do |role|

        next unless roster.registrations.where_role(role).size > 0

        label = h.translate("enums.registration.roster.#{role.downcase}")
        pdf.pad_top(10) do
          pdf.text label, :align => :center, :size => 14
        end

        widths = [6.cm, 6.cm]
        pdf.table(roster_data(role),
                  :header => true,
                  :width => pdf.bounds.width,
                  :column_widths => widths) do
          cells.padding = 3
          column(0).inline_format = true
          column(1).inline_format = true
        end
      end
      pdf.text "\nCreated at #{Time.current}", :size => 8
      if @password
        pdf.encrypt_document(:user_password => @password,
                             :owner_password => @password)
      end
    end
  end

  def title
    h.translate('enums.registration.roster.title', :event => roster.name)
  end

  def filename
    "#{roster.name} roster.pdf"
  end

  def warning
    if Site.de?
      ["Diese Liste ist vertraulich - bitte sicher aufbewahren und NUR für private Zwecke benutzen.",
       "This list is confidential - store if safely and use it ONLY for private matters."]
    else
      ["This list is confidential - store if safely and use it ONLY for private matters."]
    end
  end

  private

  def roster_data(role)
    table = []
    table << ['Name & Email',
              h.translate('enums.registration.roster.address'),
              h.translate('enums.registration.roster.phones')]
    roster.registrations.where_role(role).by_first_name.each do |r|
      table << ["#{r.full_name}\n" +
                    r.email,
                h.map_address(h.compact_address(r.angel, "\n")),
                h.compact_phones(r.angel, true)
      ]
    end
    table
  end
end