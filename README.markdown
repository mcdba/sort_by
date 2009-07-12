# sort_by

Sort By is a plugin that allows you to generate a table that has sortable columns. It'll probably only work on the latest version of Rails, which is what you should be using. No excuses, thanks.

## ActiveRecord

Provided to you by this plugin in ActiveRecord is a method called `sort_by` which takes two arguments:

* The first is the field you want to sort by, and this must be a valid field otherwise an error will be raised.
* The second is the direction you want to sort by, also must be valid otherwise an error will be raised. Valid directions are "asc" and "desc" and it is case-insensitive.

Another method is `paginated_sort_by`. This takes the same arguments as the above method but also takes an additional `options` argument which is then passed to _will\_paginate_'s `paginate` method. The sorting is achieved using `with_scope`.

## ActionView

The great stuff comes in the view. This plugin provides a method called `paginated_sort_table`. This generates a table like the ["one seen here"](http://skitch.com/radarlistener/bam21/blogs-index "one seen here"). This uses the generated scaffold from an everyday Rails application. In my index action in the controller I've edited it to now be:
   
    def index
      @blogs = Blog.paginated_sort_by(params[:sort_by] || "id", params[:order])
    end
    
And my corresponding index template:

    <h1>Listing blogs</h1>
    <%= paginated_sort_table(@blogs) %>
    
That's all! Now if I were to have more than 10 blogs there I would be given pagination icons above and below the table ["as seen here"](http://skitch.com/radarlistener/bam4m/blogs-index "as seen here").

## More ActionView

By default it will give you a table of all the fields in no particular order. To fix this, call the method like this:

    <%= paginated_sort_table(@blogs, :only => ["field1", "field2"]) %>
    
The fields will be displayed in order that you specify them.

If you only want to remove some fields there's the `:except` option:

    <%= paginated_sort_table(@blogs, :except => ["field1", "field2"]) %>
    
To specify alternative names to the fields pass in the `:names` option:
    
    <%= paginated_sort_table(@blogs, :names => { :field1 => "Field 2 in disguise"}) %>

If you don't want your fields to be titleized just say so:

    <%= paginated_sort_table(@blogs, :titleize => false) %>
    
## Will Paginate Options Go Where?!

In the last options hash:

    <%= paginated_sort_table(@blogs, {}, { :options => "go here" }) %>
    
Check out the ["awesome will paginate docs"](http://wiki.github.com/mislav/will_paginate) on what these options are.

## Sorting Icons

You'll have to provide your own sorting icons, though. The names are sort\_asc and sort\_desc and the extesnion defaults to `jpg` but you can change it by specifying it in the last options hash:

      <%= paginated_sort_table(@blogs, {}, { :image_type => "png" }) %>
      