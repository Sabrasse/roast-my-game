namespace :storage do
  desc "Migrate files from local storage to S3"
  task migrate_to_s3: :environment do
    # Get all contents with attached media
    contents = Content.where.associated(:media_attachment)
    
    puts "Found #{contents.count} contents with media attachments"
    
    contents.find_each do |content|
      if content.media.attached?
        begin
          # Get the current blob
          blob = content.media.blob
          
          puts "Processing content ##{content.id} - #{blob.filename}"
          puts "Blob key: #{blob.key}"
          puts "Content type: #{blob.content_type}"
          puts "Byte size: #{blob.byte_size}"
          
          # Check if the file exists in local storage
          unless blob.service.exist?(blob.key)
            puts "Warning: File not found in local storage for content ##{content.id}"
            next
          end
          
          # Create a new blob in S3
          new_blob = ActiveStorage::Blob.create_before_direct_upload!(
            filename: blob.filename,
            byte_size: blob.byte_size,
            checksum: blob.checksum,
            content_type: blob.content_type
          )
          
          # Download the file from local storage
          local_file = blob.download
          
          # Upload to S3
          new_blob.upload(local_file)
          
          # Update the attachment to use the new blob
          content.media.update(blob: new_blob)
          
          puts "Successfully migrated content ##{content.id} - #{blob.filename}"
        rescue => e
          puts "Error migrating content ##{content.id}: #{e.message}"
          puts "Error class: #{e.class}"
          puts e.backtrace.join("\n")
        end
      end
    end
    
    puts "Migration completed!"
  end
end 