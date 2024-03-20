require_relative "photo"

# The +PhotoListConverter+ class contains the logic for parsing formatted file
# metadata and generating new filenames.
class PhotoListConverter
  # Converts a string containing photo metadata for one or more files into a
  # string containing new filenames for each photo. The new names are based on
  # the individual and aggregated metadata.
  #
  # @param photo_list [String] Lines of the photo_list are separated by newline
  #   characters and each line of the +photo_list+ is of the format:
  #
  #    <<photoname>>.<<extension>>, <<city_name>>, yyyy-mm-dd hh:mm:ss
  #
  # @return [String] filenames, Lines of the filenames are still separated by
  #   newline characters and each line corresponds to the input in the same
  #   position. Filenames are of the format:
  #
  #    <<city_name>><<zero_padded_order_number>>.<<extension>>
  def process(photo_list)
    photos = parse_photos_from_list(photo_list)
    cities = Hash.new { |h,k| h[k] = {} }
    aggregate_metadata(photos, cities)
    generate_new_filename_list(photos)
  end

  private

  # Adds a nested hash entry to the 'cities' param based on the city and
  # timestamp of a photo.
  #
  # Mutates 'cities' param.
  #
  # @param photo [Photo]
  # @param cities [Hash{String => Hash}]
  # @return [void]
  def add_to_cities(photo, cities)
    cities[photo.city][photo.timestamp] = photo
  end

  # Groups the photos by city, then sorts the timestamps for each city and
  # updates the photos with their order (including proper zero-padding).
  #
  # Mutates the 'photos' and 'cities' params.
  #
  # @param photos [Array<Photo>]
  # @param cities [Hash{String => Hash}]
  # @return [void]
  def aggregate_metadata(photos, cities)
    photos.each { |photo| add_to_cities(photo, cities) }
    cities.each { |city, metadata|
      sorted = metadata.keys.sort
      required_digits = sorted.size.to_s.length
      sorted.each_with_index { |timestamp, index|
        metadata[timestamp].order = format("%0#{required_digits}d", (index + 1))
      }
    }
  end

  # @param entries [Array<String>]
  # @return [Array<Photo>]
  def convert_entries_to_photos(entries)
    entries.map { |entry| convert_entry_to_photo(entry) }
  end

  # Parses an individual list entry string to initialize a new Photo object.
  #
  # @param entry [String]
  # @return [Photo]
  def convert_entry_to_photo(entry)
    filename, city, timestamp = entry.split(",")
    name, extension = filename.split(".")
    ::Photo.new(
      name:      name,
      extension: extension,
      city:      city.strip,
      timestamp: timestamp.strip
    )
  end

  # Generates the new filename for a photo based on its attributes.
  #
  # @param photo [Photo]
  # @return [String]
  def generate_new_filename(photo)
    "#{photo.city}#{photo.order}.#{photo.extension}"
  end

  # Converts the processed list of photos back into a string containing the new
  # filenames separated by newline characters.
  #
  # @param photos [Array<Photo>]
  # @return [String]
  def generate_new_filename_list(photos)
    photo_list = photos.map { |photo| generate_new_filename(photo) }
    photo_list.join("\n")
  end

  # Converts the list of metadata from a single string into an array of objects
  # that can provide relevant info about each line.
  #
  # @param list [String] List items are separated by newline characters
  # @return [Array<Photo>]
  def parse_photos_from_list(list)
    convert_entries_to_photos(split_entries(list))
  end

  # Splits a string on newline characters.
  #
  # @param entries [String]
  # @return [Array<String>]
  def split_entries(entries)
    entries.split("\n")
  end
end
