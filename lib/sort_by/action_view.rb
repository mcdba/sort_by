module ActionView
  module SortBy
    
    @@default_method_options = {
      :only => [],
      :except => [],
      :titleize => true,
      :names => {},
      :class => 'sort_by',
      :header=>'',
      :footer=>''
    }
    
    def paginated_sort_table(collection, method_options={}, paginate_options={})
      method_options = @@default_method_options.merge( method_options)
      methods = method_options[:only] if !method_options[:only].empty?
      methods ||= collection.first.attributes.keys if collection.first.respond_to?(:attributes)
      methods ||= []
      methods -= method_options[:except].map!(&:to_s) if !method_options[:except].empty?
      
      links = will_paginate(collection, paginate_options)
      o = links
      # There may be no page links.
      o ||= ""
      o += "\n<table class='#{method_options[:class]}'>"
      o += "\n  <caption>"+ h(method_options[:header])+"</caption>" if !method_options[:header].empty?
      o += "\n  <thead>
    <tr>\n"
      methods.each do |method|
        title = method_options[:names][method] || method
        title = h title.titleize if method_options[:titleize]
        order = request.params[:order] == "asc" && request.params[:sort_by] == method ? "desc" : "asc"
        o += "      <th#{params[:sort_by]==method.to_s ? ' class="sort'+order+'"': ''}>#{link_to(title, url_for(request.params.merge(:sort_by => method, :order => order)))}</th>\n"
      end
      o += "    </tr>
  </thead>
  <tbody>\n"
      for object in collection
        o += "    <tr class='#{cycle('odd','even')}'>\n"
        for method in methods
          o += "      <td>#{object.send(method)}</td>\n"
        end
        o += "    </tr>\n"
      end
      o += "  </tbody>\n"
      o += "  <tfoot>
    <tr>
      <th colspan=50>#{h(method_options[:footer])}</th>
    </tr>
  </tfoot>\n" if !method_options[:footer].empty?
      o += "</table>\n"  
      o += links.to_s
    end
  end
end