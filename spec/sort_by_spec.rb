# Testing process inspired by will_paginate
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'will_paginate'

ActionController::Routing::Routes.draw do |map|
  map.connect 'dummy/page/:page', :controller => 'dummy'
  map.connect 'dummy/dots/page.:page', :controller => 'dummy', :action => 'dots'
  map.connect 'ibocorp/:page', :controller => 'ibocorp',
                               :requirements => { :page => /\d+/ },
                               :defaults => { :page => 1 }
                               
  map.connect ':controller/:action/:id'
end

module ActionView
  class InlineTemplate
    def relative_path
      './'
    end
    
  end
end

  

describe ActiveRecord do
  
  it "should be sorted" do
    Post.sort_by(:created_at).first.should eql(Post.find_by_created_at("#{Time.zone.now.year-1}-01-01".to_time))
  end
  
  it "should also be sorted" do
    Post.sort_by(:created_at, 'desc').first.should eql(Post.find_by_created_at("#{Time.zone.now.year}-12-31".to_time.end_of_day))
  end
  
  it "should be paginated" do
    @records = Post.paginated_sort_by(:created_at, 'asc', :per_page => 10, :page => 1)
    @records.size.should eql(10)
    @records.first.should eql(Post.find(87))
    @records.last.should eql(Post.find(9))
    
    @records = Post.paginated_sort_by(:created_at, 'asc', :per_page => 10, :page => 2)
    @records.size.should eql(10)
    @records.first.should eql(Post.find(10))
    @records.last.should eql(Post.find(16))
  end
  
  it "should not be able to sort based on a false field" do
    lambda { Post.sort_by(:pancakes) }.should raise_error(ActiveRecord::SortBy::InvalidField)
  end
  
  
end

describe ActionView do
  def request
    DummyRequest.new
  end
  
  def params
    request.params
  end
  
  
  include WillPaginate::ViewHelpers
  include ActionView::Base::TagHelper
  include ActionView::Helpers::UrlHelper
  include ActionView::SortBy
  
  before do
    @controller = DummyController.new
    @view = ActionView::Base.new
    @request     = @controller.request
    @html_result = nil
    @template    = '<%= paginated_sort_table collection, options %>'
    @view.assigns['controller'] = @controller
    @view.assigns['_request']   = @request
    @view.assigns['_params']    = @request.params
    @options = {}
    
    # Because times are a changin'
    Post.delete_all
    
    time = "15-05-2009".to_time
    Time.stub(:now).and_return(time)
    
    30.times do |i|
      Post.create!(:created_at => Time.now + i.minutes)
    end
  end
  
  it "should be a pretty table" do
    collection = Post.paginated_sort_by("created_at")
    locals = { :collection => collection, :options => @options }
    @html_result = ActionView::InlineTemplate.new(@template).render(@view, locals)
    @html_result.should eql("<div class=\"pagination\"><span class=\"disabled prev_page\">&laquo; Previous</span> <span class=\"current\">1</span> <a href=\"/foo/bar?page=2\" rel=\"next\">2</a> <a href=\"/foo/bar?page=3\">3</a> <a href=\"/foo/bar?page=2\" class=\"next_page\" rel=\"next\">Next &raquo;</a></div>\n<table class='sort_by'>\n  <thead>\n    <tr>\n      <td><a href=\"/foo/bar?order=asc&amp;sort_by=updated_at\">Updated At</a></td>\n      <td><a href=\"/foo/bar?order=asc&amp;sort_by=text\">Text</a></td>\n      <td><a href=\"/foo/bar?order=asc&amp;sort_by=id\">Id</a></td>\n      <td><a href=\"/foo/bar?order=asc&amp;sort_by=created_at\">Created At</a></td>\n    </tr>\n  </thead>\n  <tbody>\n    <tr>\n      <td>2009-05-15T00:00:00+00:00</td>\n      <td></td>\n      <td>90</td>\n      <td>2009-05-15T00:00:00+00:00</td>\n    </tr>\n    <tr>\n      <td>2009-05-15T00:00:00+00:00</td>\n      <td></td>\n      <td>91</td>\n      <td>2009-05-15T00:01:00+00:00</td>\n    </tr>\n    <tr>\n      <td>2009-05-15T00:00:00+00:00</td>\n      <td></td>\n      <td>92</td>\n      <td>2009-05-15T00:02:00+00:00</td>\n    </tr>\n    <tr>\n      <td>2009-05-15T00:00:00+00:00</td>\n      <td></td>\n      <td>93</td>\n      <td>2009-05-15T00:03:00+00:00</td>\n    </tr>\n    <tr>\n      <td>2009-05-15T00:00:00+00:00</td>\n      <td></td>\n      <td>94</td>\n      <td>2009-05-15T00:04:00+00:00</td>\n    </tr>\n    <tr>\n      <td>2009-05-15T00:00:00+00:00</td>\n      <td></td>\n      <td>95</td>\n      <td>2009-05-15T00:05:00+00:00</td>\n    </tr>\n    <tr>\n      <td>2009-05-15T00:00:00+00:00</td>\n      <td></td>\n      <td>96</td>\n      <td>2009-05-15T00:06:00+00:00</td>\n    </tr>\n    <tr>\n      <td>2009-05-15T00:00:00+00:00</td>\n      <td></td>\n      <td>97</td>\n      <td>2009-05-15T00:07:00+00:00</td>\n    </tr>\n    <tr>\n      <td>2009-05-15T00:00:00+00:00</td>\n      <td></td>\n      <td>98</td>\n      <td>2009-05-15T00:08:00+00:00</td>\n    </tr>\n    <tr>\n      <td>2009-05-15T00:00:00+00:00</td>\n      <td></td>\n      <td>99</td>\n      <td>2009-05-15T00:09:00+00:00</td>\n    </tr>\n  </tbody>\n</table>\n<div class=\"pagination\"><span class=\"disabled prev_page\">&laquo; Previous</span> <span class=\"current\">1</span> <a href=\"/foo/bar?page=2\" rel=\"next\">2</a> <a href=\"/foo/bar?page=3\">3</a> <a href=\"/foo/bar?page=2\" class=\"next_page\" rel=\"next\">Next &raquo;</a></div>")
  end
end


class DummyRequest
  attr_accessor :symbolized_path_parameters
  
  def initialize
    @get = true
    @symbolized_path_parameters = @params = { :controller => 'foo', :action => 'bar' }
  end
  
  def get?
    @get
  end

  def post
    @get = false
  end

  def relative_url_root
    ''
  end

  def params(more = nil)
    @params.update(more) if more
    @params
  end
end

class DummyController
  attr_reader :request
  attr_accessor :controller_name
  
  def initialize
    @request = DummyRequest.new
    @url = ActionController::UrlRewriter.new(@request, @request.params)
  end

  def params
    @request.params
  end
  
  def url_for(params)
    @url.rewrite(params)
  end
end