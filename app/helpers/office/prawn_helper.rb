module Office::PrawnHelper
  require 'prawn/measurement_extensions'

  def content_for_prawn(options = {}, &block)
    #:margin => [2.cm, 1.cm],
    options.reverse_merge!(:page_size => 'A4',
                           :page_layout => :portrait,
                           :margin => [1.cm, 1.cm])

    pdf = Prawn::Document.new(options)
    default_layout(pdf, &block)
    pdf.render.html_safe
  end

  protected

  def default_layout(pdf, &block)
    header_height = 1.cm
    footer_height = 1.cm
    gap = 10

    title = @title
    pdf.instance_eval do
      repeat :all do
        mask :fill_color, :line_width, :stroke_color do
          fill_color "000000"
          stroke_color '000000'
          line_width(1)
        
          # header
          #stroke_bounds
          bounding_box([bounds.left, bounds.top],
                       :width  => bounds.width,
                       :height => header_height) do
            #stroke_color "ff0000"
            #stroke_bounds
            #stroke_color '000000'
            

            fill_color "99cc33"
            rectangle([bounds.left, bounds.top], bounds.width, 20)
            fill
            fill_color "000000"
            
            image("#{Rails.root}/public/images/logo-big.png",
                  :fit => [40, 40],
                  :at => [bounds.left, bounds.top])
              
            text title.to_s, :align => :center, :valign => :center, :size => 20 if title
          
            # action template may put some additional header stuff
            #yield :header
          
            #stroke_horizontal_line(bounds.left, bounds.right,
            #                       :at => bounds.bottom - 3.mm)
          end
          
          # footer
          #stroke_horizontal_line(bounds.left, bounds.right,
          #                       :at => bounds.bottom + footer_height - 5.mm)
        end
      end
      
      bounding_box([bounds.left, bounds.top - (header_height + gap)],
                   :width  => bounds.width,
                   :height => bounds.height - (gap+header_height+footer_height)) do
        # action rendering comes here!
        yield pdf
      end
      
      # put page numbers now that all pages are generated
      page_count.times do |i|
        go_to_page(i+1)
        mask :fill_color, :line_width, :stroke_color do
          fill_color "000000"
          stroke_color '000000'
          line_width(1)
          
          caption = "#{i+1} / #{page_count}"
          draw_text(caption, :size => 12,
                    :at => [bounds.left + (bounds.width - width_of(caption)) / 2, bounds.bottom])
        end
      end
    end
  end
end
