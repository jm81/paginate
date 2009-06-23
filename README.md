Paginate
========

This paginate library assists in paginating collections and results of database
queries. It is particularly designed for use with DataMapper and ActiveRecord, 
and for the Merb and Rails frameworks, but can be used in many other situations.
The library includes three sections (with more information on each below)

1. Paginate modules - These are the modules that a collection (such as an Array)
   or a model Class extends to allow the collection to call #paginate

2. Paginator classes - classes in the Paginator module do the actual work.
   Paginator::Simple is the base class.

3. Helper modules - modules with helper methods for use by frameworks
   (currently Merb only).

##General Information

There are many pagination libraries available for Ruby (in particular for Ruby
ORMs). This is just one more, but with three particular design goals:

1. Add *#current_page* and *pages* singleton methods to the paginated 
   collection. The pagination libraries I've used usually return two values:
   the collection and a total pages value. For no good reason, this bugs me.
2. A more flexible *:page* option. The *:page* option can be negative,
   representing number of pages from the last (-1 being the last), as occurs
   with many Ruby objects. Also, the *paginate* method will always return a
   page within the actual collection. Finally, the *current_page* singleton
   method returns the actual number of the page returned, which may be different
   from that given.
3. Re-use as much code as possible for different situations. That is, the method
   that calculates the current page and adds the singleton methods is shared
   by implementations for Array, DataMapper, ActiveRecord, etc.

##Examples

Two examples are below, one using Paginate::Simple, one using Paginate::DM.
See below and the documentation of the individual modules for more details.

    ary = Array.new(1,2,3,4,5)
    ary.extend(Paginate::Simple)
    paged = ary.paginate(:page => 1, :limit => 2)
    => [1, 2]
    paged.current_page
    => 1
    paged.pages
    => 3
    
    class DmModel
      include DataMapper::Resource
      extend Paginate::DM
    end
    paged = DmModel.paginate(:page => 2, :limit => 10)
    
Note that neither the :page nor the :limit option is required. :page defaults
to 1, :limit defaults to *Paginate.config[:default_limit]* 
(See **Configuration**).

##Configuration

Paginate has one configurable parameter (for defaults across an application):
*default_limit*. This specifies the limit (number of records per page) to use
if not given as an option to the *#paginate* method. By default, it is 10. To
change:

    Paginate.config[:default_limit] = 100

For Merb apps, Merb plugin configuration can also be used:

    Merb::Plugins.config[:paginate][:default_limit] = 100

##Paginate Modules

Paginate modules provide a *paginate* method to Objects that extend them. The
actual work is done by a Paginator class.

*paginate* accepts an options hash with at least two options:

- *:page*: The desired page number, 1-indexed. Negative numbers represent
  page from the last page (with -1) being the last.
- *:limit*: represents records per page.

Depending on the module, other options may be passed through to, for example, an
*all* method. See individual modules for more details.

There are currently three modules.

- Paginate::Simple - for use with Arrays and similar objects.
- Paginate::DM - extended by a class that includes DataMapper::Resource
- Paginate::AR - extended by a class that inherits ActiveRecord::Base

For associated collections with DataMapper, you can use Paginator::ORM directly,
or (for example):

    jobs = Person.first.jobs
    jobs.extend(Paginate::DM)
    jobs.paginate(:page => 1)
    # or
    DataMapper::Collection.__send__(:include, Paginate::DM) # perhaps in init.rb
    jobs = Person.first.jobs.paginate(:page => 1)

Using the +DataMapper::Collection.__send__(:include, Paginate::DM)+ option makes
the *#paginate* methods to all association collections. The first method could
be used for ActiveRecord.

##Paginator Classes

Paginator classes do the actual work of paginating and are called by the 
modules. They can be used directly. The *#paginate* method in Paginators::Simple
does all the generic work. It calls two methods, *#get_full_count*, 
and *#get_paginated_collection* to do the implementation-specific work.
Paginator classes should need to override only these two methods.

##Custom Paginators

To create an additional Paginator, create a class that inherits 
Paginate::Paginators::Simple (or another Paginator). The key is to override
the following methods:

- *#get_paginated_collection* - This returns the paginated collection. At it's
  disposal is the @options hash and two particular options:
  - @options[:offset] is the zero-indexed offset of the first record of the
    page.
  - @options[:limit] is the number of items per page.
  - Other options passed the #initialize method will also be available.

- *#get_full_count* - Return the total number of items on all pages. The @options 
  hash is available here, but :offset, :order and :limit options will not be 
  included. Options such as conditions will be available.
  
See Paginators for examples.

To use, add a paginate method to your Class or Object:

    def paginate(options = {})
      MyPaginator.new(self, options).paginate
    end

##Helper Modules

There is currently a Helpers::Shared module and Helpers::Merb.

###Helpers::Shared

Contains one method, *#page_set*, which returns an Array of page numbers useful
in creating page links for the collection.

###Helpers::Merb

In addition to including Shared, this helper includes other methods useful for
displaying page links. See Helpers::Merb module for details.
