require "photo_list_converter"

RSpec.describe PhotoListConverter do
  describe "#process" do
    let(:new_photo_names) { subject.process(list) }

    context "when given the info for a single file" do
      let(:list) { "single_file_test.jpg, Krakow, 2013-09-05 14:08:15" }

      it "returns the new filename formatted as '<city><zero_padded_order>.<extension>'" do
        expect(new_photo_names).to eq("Krakow1.jpg")
      end
    end

    context "when given the info for two files" do
      let(:list) {
        <<~LIST
        first_test_file.jpg, Krakow, 2013-09-05 14:08:15
        second_test_file.png, Krakow, 2013-09-04 12:00:45
        LIST
      }

      it "returns the correct new names for both files" do
        names = new_photo_names.split("\n")
        expect(names).to match_array(["Krakow2.jpg", "Krakow1.png"])
      end
    end

    context "when given a mix of photos for different locations" do
      let(:list) {
        <<~LIST
        photo.jpeg, Krakow, 2013-09-05 14:08:15
        Mike.png, London, 2015-06-20 15:13:22
        myFriends.png, Krakow, 2013-09-05 14:07:13
        Eiffel.jpg, Florianopolis, 2015-07-23 08:03:02
        pisatower.jpg, Florianopolis, 2015-07-22 23:59:59
        BOB.jpg, London, 2015-08-05 00:02:03
        notredame.png, Florianopolis, 2015-09-01 12:00:00
        me.jpg, Krakow, 2013-09-06 15:40:22
        a.png, Krakow, 2016-02-13 13:33:50
        b.jpg, Krakow, 2016-01-02 15:12:22
        c.jpg, Krakow, 2016-01-02 14:34:30
        d.jpg, Krakow, 2016-01-02 15:15:01
        e.png, Krakow, 2016-01-02 09:49:09
        f.png, Krakow, 2016-01-02 10:55:32
        g.jpg, Krakow, 2016-02-29 22:13:11
        LIST
      }

      it "returns the correct new names for all files in the original order" do
        names = new_photo_names.split("\n")
        expect(names).to match_array([
          "Krakow02.jpeg",
          "London1.png",
          "Krakow01.png",
          "Florianopolis2.jpg",
          "Florianopolis1.jpg",
          "London2.jpg",
          "Florianopolis3.png",
          "Krakow03.jpg",
          "Krakow09.png",
          "Krakow07.jpg",
          "Krakow06.jpg",
          "Krakow08.jpg",
          "Krakow04.png",
          "Krakow05.png",
          "Krakow10.jpg",
        ])
      end
    end
  end
end
