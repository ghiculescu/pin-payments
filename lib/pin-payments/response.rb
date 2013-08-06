module Pin
  class CollectionResponse
    attr_reader :collection, :page_count, :per_page, :page

    def initialize(collection, per_page, page_count, current_page)
      @collection = collection
      @page_count = page_count
      @per_page = per_page
      @page = current_page
    end

    def first_page?
      @page == 1
    end

    def last_page?
      @page == @page_count
    end

    def next_page?
      @page_count > 1 && !last_page?
    end

    def previous_page?
      @page_count > 1 && !first_page?
    end

    def method_missing(meth, *args, &block)
      if collection.respond_to?(meth)
        collection.send(meth, *args, &block)
      else
        super
      end
    end
  end
end