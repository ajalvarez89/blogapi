module PostSearchService
  class Internal
    def self.search(curr_posts, query) 
      curr_posts.where("title like '%#{query}%'")
    end
  end
end