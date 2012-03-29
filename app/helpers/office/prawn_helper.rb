module Office::PrawnHelper
  require 'prawn/measurement_extensions'

  def content_for_prawn(options = {}, &block)
    #:margin => [2.cm, 1.cm],
    options.reverse_merge!(:page_size => 'A4',
                           :page_layout => :portrait,
                           :margin => [1.cm, 1.cm])

    pdf = Prawn::Document.new(options)
    default_layout(pdf, options, &block)
    pdf.render.html_safe
  end

  protected

  def default_layout(pdf, options, &block)
    title_height = 1.cm
    warning_height = 0.8.cm
    header_height = title_height + warning_height
    footer_height = 1.cm
    gap = 10

    # HACK ALERT! two globals here. better to pass in a parameters
    title = options[:title] || @title || []
    warning = options[:warning] || @warning || []
    
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
                       :height => title_height) do
            #stroke_color "ff0000"
            #stroke_bounds
            #stroke_color '000000'
            
            fill_color Site.theme_color
            rectangle([bounds.left, bounds.top], bounds.width, 20)
            fill
            fill_color "000000"
            
            image("#{Rails.root}/public/images/de/logo-big.png",
                  :fit => [40, 40],
                  :at => [bounds.left, bounds.top]) if Site.de?
              
            text title.to_s, :align => :center, :valign => :center, :size => 20 if title
          
            # action template may put some additional header stuff
            #yield :pdf_header
          
            #stroke_horizontal_line(bounds.left, bounds.right,
            #                       :at => bounds.bottom - 3.mm)
          end
          
          bounding_box([bounds.left, bounds.top - title_height],
                       :width  => bounds.width,
                       :height => warning_height) do
            warning.each do |line|
              text line, :align => :center, :size => 10
            end
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
