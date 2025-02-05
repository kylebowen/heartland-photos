# The Photo class provides a convenient wrapper for dealing with photo metadata.
class Photo
  attr_reader :city, :extension, :name, :timestamp
  attr_accessor :order

  # Instantiates a new Photo object.
  #
  # @param city [String] The city where the photo was taken.
  # @param extension [String] Original file extension. One of ["jpg"|"jpeg"|"png"]
  # @param name [String] Original filename (without extension)
  # @param timestamp [String] DateTime photo was taken. Format: "yyyy-mm-dd hh:mm:ss"
  # @param order [Integer|nil] The order the photo was taken for its city.
  #   If set, expected to be a natural number 1 or higher.
  # @return [self]
  def initialize(city:, extension:, name:, timestamp:, order: nil)
    @city = city
    @extension = extension
    @name = name
    @timestamp = timestamp
    @order = order
  end
end
