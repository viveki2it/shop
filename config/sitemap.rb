# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.shopofme.com"
SitemapGenerator::Sitemap.sitemaps_namer = SitemapGenerator::SitemapNamer.new(:sitemap, :extension => '.xml')
SitemapGenerator::Sitemap.sitemap_index_namer = SitemapGenerator::SitemapNamer.new(:sitemap_index, :extension => '.xml')
SitemapGenerator::Sitemap.adapter = Class.new(SitemapGenerator::FileAdapter) { def gzip(stream, data); stream.write(data); stream.close end }.new

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
  
 #ShopOfMe.com
  add "/about", priority: 0.8, changefreq: 'monthly'
 
 #My.ShopOfMe.com
  my_domain = "http://my.shopofme.com"
  add "/", priority: 1.0, changefreq: 'daily', host: my_domain
  add "/pages/privacy", priority: 0.1, changefreq: 'monthly', host: my_domain

end
