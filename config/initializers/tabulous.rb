module Tabulous
  class HackedBootstrapRenderer < BootstrapRenderer

    protected

    def tab_link_with_subtabs(tab)
      html = ''
      html << %Q{<a data-collapsible href="#">#{tab_text(tab)} </a>}
      html << %Q{<ul class="nav nav-pills nav-stacked subnav">}
      for subtab in tab.subtabs
        next unless subtab.visible?(@view)
        klass = (subtab.enabled?(@view) ? '' : 'disabled')
        if klass.empty?
          html << '<li>'
        else
          html << %Q{<li class="#{klass}">}
        end
        html << tab_link(subtab)
        html << "</li>"
      end
      html << "</ul>"
      html
    end

  end

  class BootstrapPillStackedRenderer < HackedBootstrapRenderer

    def tabs_html
      <<-HTML.strip_heredoc
        <ul class="nav nav-pills nav-stacked">
          #{ tab_list_html }
        </ul>
      HTML
    end

  end
end
