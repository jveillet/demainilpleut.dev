require 'time'

class CategoryPages < SiteBuilder
  def build
    generator do
      if site.layouts.key? "category_index"
        site.categories.each_key do |category|
          site.pages << CategoryPage.new(site, category)
        end
      end
    end
  end

  # A Page subclass
  class CategoryPage < Bridgetown::Page
    def initialize(site, category)
      @site = site
      @base = site.source # start in src
      @dir  = "archives/#{category.downcase.gsub(' ', '-')}" # aka src/archives/<category>
      @name = "index.html" # filename
      process(@name) # saves internal filename and extension information

      # Load in front matter and content from the layout
      read_yaml("_layouts", "category_index.html")

      # Inject data into the generated page:
      data["category"] = category
      data["title"] = "#{category}"
      data["posts"] = site.posts.docs.select do |post|
        post.data["categories"].include? category
      end
    end
  end
end
