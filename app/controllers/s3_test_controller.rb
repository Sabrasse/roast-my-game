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
      
      # Create a test file
      file = Tempfile.new(['test', '.txt'])
      file.write("Test content #{Time.current}")
      file.rewind
      
      # Attach the file
      content.media.attach(
        io: file,
        filename: "test-#{Time.current.to_i}.txt",
        content_type: 'text/plain'
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