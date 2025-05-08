class S3TestController < ApplicationController
  def test_connection
    begin
      # Get the S3 client from Active Storage
      s3 = ActiveStorage::Blob.service.client
      s3_client = s3.client # Get the actual client from the resource
      
      # Try to list objects in the bucket
      response = s3_client.list_objects_v2(bucket: ENV['AWS_BUCKET'], max_keys: 1)
      
      # If we get here, the connection is working
      render json: {
        status: 'success',
        message: 'Successfully connected to S3',
        bucket: ENV['AWS_BUCKET'],
        region: ENV['AWS_REGION'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'].present? ? 'Set' : 'Not Set',
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'].present? ? 'Set' : 'Not Set',
        objects: response.contents&.map { |obj| obj.key } || []
      }
    rescue => e
      render json: {
        status: 'error',
        message: e.message,
        bucket: ENV['AWS_BUCKET'],
        region: ENV['AWS_REGION'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'].present? ? 'Set' : 'Not Set',
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'].present? ? 'Set' : 'Not Set'
      }, status: :internal_server_error
    end
  end

  def test_upload
    begin
      # Create a test content with a valid description
      content = Content.new(
        description: "This is a test upload to verify S3 functionality. Created at #{Time.current}."
      )
      
      # Create a test PNG file
      file = Tempfile.new(['test', '.png'])
      # Create a simple 1x1 pixel PNG
      file.binmode
      file.write([
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
        0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
        0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
        0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
        0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
        0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82
      ].pack('C*'))
      file.rewind
      
      # Attach the file
      content.media.attach(
        io: file,
        filename: "test-#{Time.current.to_i}.png",
        content_type: 'image/png'
      )
      
      if content.save
        render json: {
          status: 'success',
          message: 'Successfully uploaded test file',
          content_id: content.id,
          media_url: url_for(content.media)
        }
      else
        render json: {
          status: 'error',
          message: 'Failed to save content',
          errors: content.errors.full_messages
        }, status: :unprocessable_entity
      end
    rescue => e
      render json: {
        status: 'error',
        message: e.message,
        backtrace: e.backtrace[0..5]
      }, status: :internal_server_error
    ensure
      file&.close
      file&.unlink
    end
  end
end 