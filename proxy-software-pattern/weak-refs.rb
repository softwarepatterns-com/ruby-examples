require 'weakref'

class Image
  def display
    # Abstract method
  end
end

class RealImage < Image
  def initialize(filename)
    @filename = filename
    load_from_disk
  end

  def load_from_disk
    puts "Loading image: #{@filename}"
  end

  def display
    puts "Displaying image: #{@filename}"
  end
end

class ProxyImage < Image
  def initialize(filename)
    @filename = filename
    @real_image_ref = nil
  end

  def display
    real_image = @real_image_ref&.weakref_alive? ? @real_image_ref : nil

    unless real_image
      real_image = RealImage.new(@filename)
      @real_image_ref = WeakRef.new(real_image)
    end

    real_image.display
  end
end

image1 = ProxyImage.new("image1.jpg")
image2 = ProxyImage.new("image2.jpg")

# First display will load images
image1.display
image2.display

# Subsequent displays won't reload if the images are still in memory
image1.display
image2.display