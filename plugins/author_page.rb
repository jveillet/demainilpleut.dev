##
# Bridgetown plugin to generate dynamically each author page.
#
class AuthorPage < SiteBuilder
  def build
    generator do
      if site.layouts.key? "author_index"
        site.data.authors.each_key do |author|
          site.pages << AuthorPage.new(site, author)
        end
      end
    end
  end

  # A Page subclass
  class AuthorPage < Bridgetown::Page
    def initialize(site, author)
      @site = site
      @base = site.source # start in src
      @dir  = "authors/#{author.downcase.gsub(' ', '-')}" # aka authors/<author>
      @name = "index.html" # filename
      process(@name) # saves internal filename and extension information

      # Load in front matter and content from the layout
      read_yaml("_layouts", "author_index.html")

      # Inject data into the generated page:
      data["author"] = author
      data["title"] = "Author @#{author}"
    end
  end
end
