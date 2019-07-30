
require 'aws-sdk-s3'




module AwsHelper
    def uploadImage(image, userId)
        puts 'Uploading to AWS S3'
        s3 = Aws::S3::Resource.new(
            credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
            region:'us-west-2'
    )
        
        obj = s3.bucket('koiospics').object("images/image#{userId}.jpg")
        obj.upload_file(image)
        obj.public_url.to_s #returns public url of file at s3 server


    end
end