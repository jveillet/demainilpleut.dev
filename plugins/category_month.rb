class CategoryMonth < SiteBuilder
  def build
    generator do
      if site.layouts.key? "category_year"
        site.posts.each do |post|
          site.pages << CategoryMonth.new(site, post.date)
        end
      end
    end
  end

  # A Page subclass
  class CategoryMonth < Bridgetown::Page
    def initialize(site, date)
      @site = site
      @base = site.source # start in src
      @dir  = "archives/#{date.year}/#{date.month.to_s.rjust(2, "0")}" # aka src/archives/<year>/<month>
      @name = "index.html" # filename
      process(@name) # saves internal filename and extension information

      # Load in front matter and content from the layout
      read_yaml("_layouts", "category_month.html")

      # Inject data into the generated page:
      data["category"] = "#{date.month}-#{date.year}"
      data["title"] = "#{date.month}-#{date.year}"
      data["date"] = date
      data["posts"] = site.posts.docs.select do |post|
        post.data["date"].year == date.year && post.data["date"].month == date.month
      end
    end
  end
end
