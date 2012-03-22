module Office::Registrations::RosterHelper

  def roster_pdf
    content_for_prawn do |pdf|
      pdf.font "Times-Roman"
      pdf.font_size(10)
      [Registration::PARTICIPANT,
       Registration::TEAM,
       Registration::FACILITATOR].each do |role|

        next unless registrations.completed.where_role(role).size > 0
        
        label = t("enums.registration.roster.#{role.downcase}")
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
      pdf.text "\nCreated at #{Time.now}", :size => 8
      if @password
        pdf.encrypt_document(:user_password => @password,
                             :owner_password => @password)
      end
    end
  end

  private

  def roster_data(role)
    t = []
    t << ['Name & Email',
          t('enums.registration.roster.address'),
          t('enums.registration.roster.phones')]
    registrations.completed.where_role(role).by_first_name.each do |r|
      t << ["#{r.full_name}\n" +
            r.email,
            map_address(compact_address(r.angel, "\n")),
            compact_phones(r.angel, true)
           ]
    end
    t
  end
    
end
