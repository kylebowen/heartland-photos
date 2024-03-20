# Heartland - Photo List Converter

This project contains a simple class to aid in parsing CSV formatted data from a
string to generate new filenames for the referenced image files.

## Getting Started

### Prerequisites

- A current version of Ruby installed & available.
  (Tested with 3.2.2 & 2.7.8)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/kylebowen/heartland-photos.git
   ```

### Testing

1. Navigate to the project directory:

   ```bash
   cd heartland-photos
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Run the specs:

   ```bash
   bundle exec rspec spec/
   ```

### Usage

1. Open IRB while sourcing the PhotoListConverter class:

   ```bash
   irb -r "./lib/photo_list_converter.rb"
   ```

2. Create a new instance of the PhotoListConverter class:

   ```ruby
   converter = PhotoListConverter.new
   ```

3. Import the string containing your CSV list:

   ```ruby
   list = File.read("sample_list.txt")
   ```

4. Process the list with the converter:

   ```ruby
   new_names = converter.process(list)
   ```

5. Display the list of new filenames:

   ```ruby
   print new_names
   ```

6. (Optional) Save the list of new filenames to a text file:

   ```ruby
   File.write("my_new_filename.txt", new_names)
   ```

