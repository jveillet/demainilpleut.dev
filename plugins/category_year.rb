class CategoryYear < SiteBuilder
  def build
    generator do
      if site.layouts.key? "category_year"
        site.posts.each do |post|
          site.pages << CategoryYear.new(site, post.date)
        end
      end
    end
  end

  # A Page subclass
  class CategoryYear < Bridgetown::Page
    def initialize(site, date)
      @site = site
      @base = site.source # start in src
      @dir  = "archives/#{date.year}" # aka src/archives/<year>
      @name = "index.html" # filename
      process(@name) # saves internal filename and extension information

      # Load in front matter and content from the layout
      read_yaml("_layouts", "category_year.html")

      # Inject data into the generated page:
      data["category"] = date.year
      data["title"] = "#{date.year}"
      data["date"] = date
      data["posts"] = site.posts.docs.select do |post|
        post.data["date"].year == date.year
      end
    end
  end
end
