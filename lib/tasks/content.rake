namespace :content do
  desc "Regenerate thumbnails for all content"
  task regenerate_thumbnails: :environment do
    Content.find_each do |content|
      puts "Processing content ##{content.id}..."
      if content.media.attached?
        begin
          if content.media.content_type.start_with?('image/')
            content.thumbnail.attach(
              content.media.variant(resize_to_limit: [300, 300]).processed
            )
          elsif content.media.content_type.start_with?('video/')
            content.thumbnail.attach(
              content.media.preview(resize_to_limit: [300, 300]).processed
            )
          end
          puts "✓ Thumbnail generated for content ##{content.id}"
        rescue => e
          puts "✗ Error processing content ##{content.id}: #{e.message}"
        end
      end
    end
    puts "Done!"
  end
end 