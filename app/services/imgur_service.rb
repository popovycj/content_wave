require 'singleton'

class ImgurService
  include Singleton

  attr_reader :imgur_links

  def initialize
    @imgur_links = load_imgur_links
  end

  def imgur_links_path
    Rails.root.join('imgur_links.json')
  end

  def load_imgur_links
    if File.exist?(imgur_links_path)
      JSON.parse(File.read(imgur_links_path))
    else
      {}
    end
  end

  def save_imgur_links
    File.write(imgur_links_path, @imgur_links.to_json)
  end

  def update_imgur_links
    base_path = "app/assets/images/"
    current_assets = Dir.glob("#{base_path}**/*").select { |f| File.file?(f) }

    current_assets.map! { |f| f.sub(base_path, '') }

    new_assets = current_assets - @imgur_links.keys
    deleted_assets = @imgur_links.keys - current_assets

    new_assets.each do |asset|
      imgur_link = upload_to_imgur("#{base_path}#{asset}")
      @imgur_links[asset] = imgur_link
    end

    deleted_assets.each do |asset|
      @imgur_links.delete(asset)
    end

    save_imgur_links
  end


  def upload_to_imgur(image)
    client_id = Rails.application.credentials.imgur[:client_id]
    puts "Uploading #{image} to Imgur..."
    url = URI.parse('https://api.imgur.com/3/image')
    req = Net::HTTP::Post.new(url.request_uri)
    req['Authorization'] = "Client-ID #{client_id}"
    req.set_form([['image', File.open(image)]], 'multipart/form-data')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    response = http.request(req)
    JSON.parse(response.body)['data']['link']
  end
end
