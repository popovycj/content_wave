namespace :imgur do
  desc "Update Imgur links"
  task update_links: :environment do
    ImgurService.instance.update_imgur_links
  end
end
