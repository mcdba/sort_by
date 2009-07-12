module ActionView
  module SortBy
    
    @@default_method_options = {
      :only => [],
      :except => [],
      :titleize => true,
      :names => {}
    }
    
    def paginated_sort_table(collection, method_options={}, options={})
      method_options = method_options.merge!(@@default_method_options)
      methods = method_options[:only] if !method_options[:only].empty?
      methods ||= collection.first.attributes.keys if collection.first.respond_to?(:attributes)
      methods ||= []
      methods -= method_options[:except].map!(&:to_s) if !method_options[:except].empty?
      
      links = will_paginate(collection, options)
      o = links
      o += "\n<table class='sort_by'>
  <thead>
    <tr>\n"
      methods.each do |method|
        title = method_options[:names][method] || method
        title = title.titleize if method_options[:titleize]
        order = request.params[:order] == "asc" && request.params[:sort_by] == "method" ? "desc" : "asc"
        o += "      <td>#{link_to(title, url_for(request.params.merge(:sort_by => method, :order => order)))}</td>\n"
      end
          
      o += "    </tr>
  </thead>
  <tbody>\n"
      
      for object in collection
        o += "    <tr>\n"
        for method in methods
          o += "      <td>#{object.send(method)}</td>\n"
        end
        o += "    </tr>\n"
      end
      
      o += "  </tbody>
</table>\n"  
      o += links
    end
  end
end