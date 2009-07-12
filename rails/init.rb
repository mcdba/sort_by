require 'will_paginate'
require 'sort_by'
ActiveRecord::Base.send :include, ActiveRecord::SortBy
ActionView::Base.send :include, ActionView::SortBy