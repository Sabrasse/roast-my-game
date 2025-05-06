# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("app/javascript")

# Precompile additional assets.
# Removed JavaScript files as they are now handled by importmaps
Rails.application.config.assets.precompile += %w(
  application.css
)
