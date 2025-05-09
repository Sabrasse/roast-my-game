namespace :content do
  desc "Regenerate thumbnails for all content"
  task regenerate_thumbnails: :environment do
    Content.find_each do |content|
      puts "Processing content ##{content.id}..."
      if content.media.attached?
        begin
          if content.media.content_type.start_with?('image/')
            puts "  Generating image thumbnail..."
            content.thumbnail.attach(
              content.media.variant(resize_to_limit: [300, 300]).processed
            )
            puts "  ✓ Image thumbnail generated"
          elsif content.media.content_type.start_with?('video/')
            puts "  Generating video thumbnail..."
            preview = content.media.preview(resize_to_limit: [300, 300])
            puts "  Video preview generated, attaching thumbnail..."
            content.thumbnail.attach(preview.processed)
            puts "  ✓ Video thumbnail attached"
          end
          puts "✓ Thumbnail generated for content ##{content.id}"
        rescue => e
          puts "✗ Error processing content ##{content.id}: #{e.message}"
          puts e.backtrace.join("\n")
        end
      else
        puts "✗ Content ##{content.id} has no media attached"
      end
    end
    puts "Done!"
  end
end 