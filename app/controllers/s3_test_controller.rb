class S3TestController < ApplicationController
  def test_connection
    begin
      # Get the S3 client from Active Storage
      s3_client = ActiveStorage::Blob.service.client
      
      # Try to list objects in the bucket
      response = s3_client.list_objects_v2(bucket: ENV['AWS_BUCKET'], max_keys: 1)
      
      # If we get here, the connection is working
      render json: {
        status: 'success',
        message: 'Successfully connected to S3',
        bucket: ENV['AWS_BUCKET'],
        region: ENV['AWS_REGION'],
        access_key_id: ENV['AWS_ACCESS_KEY_ID'].present? ? 'Set' : 'Not Set',
        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'].present? ? 'Set' : 'Not Set'
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
end 