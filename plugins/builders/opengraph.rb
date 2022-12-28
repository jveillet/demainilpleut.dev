##
# Bridgetown plugin to generate dynamically each post opengraph image.
#
class Builders::Opengraph < SiteBuilder
  def build
    return unless ENV.fetch('BRIDGETOWN_ENV', 'development') == 'production'

    generator do
      site.collections.posts.resources.each do |post|
      dest_path = "#{Dir.pwd}/src/images/opengraph"
      image_name = "#{post_id(post)}.png"
      image_path = "#{dest_path }/#{image_name}"
      tags = post_tags(post)
      date = post.data[:date]

      if !File.exist?(image_path)
        system("node opengraph/index.js -t \"#{post.data[:title]}\" -a \"#{post.data[:author]}\" -f #{image_path} -l #{tags} -d #{date}")
      elsif force?
        system("node opengraph/index.js -t \"#{post.data[:title]}\" -a \"#{post.data[:author]}\" -f #{image_path} -l #{tags} -d #{date}")
      end

      # Add the OpenGraph image URL into the post data to be available in templates
      post.data[:og_image] = generate_image_url(site, "images/opengraph/#{image_name}")
      # Initialize a new StaticFile.
      site.static_files << Bridgetown::StaticFile.new(site, "#{Dir.pwd}/src/", 'images/opengraph', image_name)
    end
  end
end

  def generate_image_url(site, path)
    host = ENV.fetch('URL', '') if netlify? && deploy_production?
    host = ENV.fetch('DEPLOY_PRIME_URL', '') if netlify? && deploy_preview?
    current_host = host || site.config.url
    "#{current_host}/#{path}"
  end

  def deploy_preview?
    %w[deploy-preview branch-deploy].include? ENV.fetch('CONTEXT', '').to_s
  end

  def netlify?
    ENV.fetch('NETLIFY', '').to_s == 'true'
  end

  def deploy_production?
    ENV.fetch('CONTEXT', '').to_s == 'production'
  end

  def post_tags(post)
    tags = ''
    post.data[:tags].each do |t|
      tags << t.gsub(' ', '-') + ' '
    end

    tags
  end

  def post_id(post)
    Digest::SHA1.hexdigest("#{post.date}/#{post.id}")
  end

  def force?
    ENV.fetch('OPENGRAPH_FORCE_GENERATION', 'false').to_s == 'true'
  end
end
