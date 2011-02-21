module Office::Registrations::ChecklistHelper

  def checklist_pdf
    content_for_prawn(:page_layout => :landscape) do |pdf|
      pdf.font "Times-Roman"
      pdf.font_size(10)

      tables = {
        'Participants' => registrations.participants.by_first_name,
        'Team & Facilitators' => registrations.non_participants.by_first_name}

      tables.each do |title, regs|
        pdf.pad_top(10) do
          pdf.text title, :align => :center, :size => 14
        end

        pdf.table(checklist_data(regs),
                  :width => pdf.bounds.width,
                  :header => true,
                  :column_widths => [25, 30, 7.cm, 20, 20, 20, 2.cm, 2.cm]) do
          cells.padding = 3
          columns(3..5).align = :center
        end
      end

      pdf.text "\nCreated at #{Time.now}", :size => 8
    end
  end

  private
  
  def checklist_data(regs)
    t = []
    t << %w(Da? Nbrs Name BJ SD SS Pay.Meth. Payments Notes)
    code = 'X'
    regs.by_first_name.each_with_index do |r, index|
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
