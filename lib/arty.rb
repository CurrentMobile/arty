require "HTTParty"
require 'digest'
require 'rmagick'
require 'jaro_winkler'

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
      response = HTTParty.get(URI.encode("https://itunes.apple.com/search?term=#{artist}"))
      response_object = JSON.parse(response.body)
      for object in response_object["results"]
        if JaroWinkler.distance(object["artistName"], artist) > 0.95 && object["collectionArtistName"] == nil && object["primaryGenreName"] != "Soundtrack"
          url = object["artworkUrl100"]
          url = url.sub("100x100", "600x600")
          @artwork_urls.push(url)
          break
        end
      end
    end

    while @artwork_urls.count < 4

      random_artist = @artists.sample
      response = HTTParty.get(URI.encode("https://itunes.apple.com/search?term=#{random_artist}"))
      response_object = JSON.parse(response.body)

      for object in response_object["results"]
        if JaroWinkler.distance(object["artistName"], random_artist) > 0.95 && object["collectionArtistName"] == nil && object["primaryGenreName"] != "Soundtrack"
          url = object["artworkUrl100"]
          url = url.sub("100x100", "600x600")

          if @artwork_urls.include?(url) == false
            @artwork_urls.push(url)
            break
          end
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

  def generate_montage(output_file_path = nil)
    self.find_artwork()
    self.fetch_images()

    i = Magick::ImageList.new

    for image_url in @artwork_urls
      i.read("./tmp/#{Digest::MD5.hexdigest(image_url)}.png")
    end

    image = i.montage do |mont|
      mont.geometry = "400x400"
    end

    width = image.columns

    degrees = 7

    image.rotate!(degrees)
    radians = degrees * Math::PI / 180

    trim = Math.sin(radians) * width

    image.shave!(trim, trim)

    if output_file_path.nil?
      output_file_path = "./tmp/output.jpeg"
    end

    image.write(output_file_path) {
      self.quality = 100
      self.format = 'JPEG'
    }
  end
end
