SitemapGenerator::Sitemap.default_host = "https://www.roastmygame.com"

SitemapGenerator::Sitemap.create do
  add root_path, changefreq: 'daily', priority: 1.0
end
