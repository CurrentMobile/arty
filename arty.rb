require "HTTParty"
require 'digest'
require 'rmagick'

class Arty

  # Provide the names of the artists to render upon initialisation
  def initialize(names)
    @artists = names
    @artwork_urls = []
    @artwork_images = []
  end

  # Use the iTunes API to fetch the artwork images
  # for the @artists provided. If an artist could not be found
  # It will simply omitted from the resulting @artwork_urls array
  def find_artwork
    for artist in @artists
      response = HTTParty.get("https://itunes.apple.com/search?term=#{artist}")
      response_object = JSON.parse(response.body)
      for object in response_object["results"]
        if object["artistName"]
          @artwork_urls.push(object["artworkUrl100"])
          break
        end
      end
    end
  end

  def fetch_images
    for image_url in @artwork_urls
      File.open("./tmp/#{Digest::MD5.hexdigest(image_url)}.png", "wb") do |f|
        f.write HTTParty.get(image_url).body
      end
    end
  end

  def generate_montage
    i = Magick::ImageList.new

    for image_url in @artwork_urls
      i.read("./tmp/#{Digest::MD5.hexdigest(image_url)}.png")
    end

    image = i.montage do |mont|
      mont.geometry = "200x200"
    end

    width = image.columns

    puts "WIDTH #{width}"

    image = image.distort(Magick::ScaleRotateTranslateDistortion, [10]) do
      self.define "distort:viewport", "0x0+0+0"
    end

    image.write("./tmp/output.png")
  end
end


a = Arty.new(["Arctic Monkeys", "The Libertines", "The Kooks", "The Strokes"])
a.find_artwork()
a.fetch_images()
a.generate_montage()
