module ActiveRecord
  module SortBy

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Default sort_by
      def sort_by(field, direction='asc', &block)
        raise InvalidField, "the field you provided is not a field in this table." if !column_names.include?(field.to_s)
        raise InvalidDirection, "the direction you provided is not a valid direction" if !["asc", "desc"].include?(direction.downcase)
    
        if block_given?
          with_scope(:find => { :order => "#{field} #{direction}" }) do
            block.call
          end
        else
          all(:order => "#{field} #{direction}")
        end
      end
  
      # For interaction with will_paginate
      def paginated_sort_by(field, direction='asc', options = {})
        options[:per_page] ||= 10
        options[:page] = 1 if options[:page].nil? || options[:page] < 0 
        sort_by(field, direction) do
          paginate(options)
        end
      end
    end


    class InvalidField < Exception; end
    class InvalidDirection < Exception; end
  end
end