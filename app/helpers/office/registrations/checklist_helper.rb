module Office::Registrations::ChecklistHelper

  def checklist_pdf
    content_for_prawn(:page_layout => :landscape) do |pdf|
      pdf.font "Times-Roman"
      pdf.font_size(10)
        
      pdf.table(checklist_data,
                :width => pdf.bounds.width,
                :header => true) do
        cells.padding = 3
        columns(3..5).align = :center
        column(8).width = 13.cm
      end

      pdf.text "\nCreated at #{Time.now}", :size => 8
    end
  end

  private
  
  def checklist_data
    t = []
    t << %w(Da? Nbrs Name BJ SD SS Pay.Meth. Payments Notes)
    code = 'X'
    registrations.each_with_index do |r, index|
      t << ['',
            index+1,
            r.full_name,
            checkmark_if(r.backjack_rental, code),
            checkmark_if(r.sunday_meal, code),
            checkmark_if(r.sunday_stayover, code),
            r.payment_method,
            '',
            '']
    end
    t
  end

end
