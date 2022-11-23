require_relative "../hearland_challenge"

describe "Photo Renaming Script" do
	
	let(:sample_input_1) { '''
photo.jpg, Krakow, 2013-09-05 14:08:15
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
'''}

  let(:expected_ouput_for_input_1) { '''
Krakow02.jpg
London1.png
Krakow01.png
Florianopolis2.jpg
Florianopolis1.jpg
London2.jpg
Florianopolis3.png
Krakow03.jpg
Krakow09.png
Krakow07.jpg
Krakow06.jpg
Krakow08.jpg
Krakow04.png
Krakow05.png
Krakow10.jpg
''' }
	
	let (:sample_line) { sample_input_1.split(/\n+/)[1] }
	let (:hash_city) { hash_city = group_by_city(sample_line) }
	let (:sample_input_grouped) { group_by_city(sample_input_1) }

	context "group_by_city" do		

		it "should convert a line into a group of that city" do			
			expect(hash_city.keys).to eq ["Krakow"]
		end

		it "shoult convert a line to an object with the photo file name" do
			expect(hash_city["Krakow"].first[:file_name]).to eq "photo.jpg"			
		end
		it "should convert a line to an object with the taken DateTime" do
			expect(hash_city["Krakow"].first[:taken_at]).to eq DateTime.new(2013, 9, 5, 14, 8, 15)
		end

		it "should convert a line to an object with the file extention" do
			expect(hash_city["Krakow"].first[:extension]).to eq "jpg"
		end

		it "should convert a line to an object with the original order id" do
			expect(hash_city["Krakow"].first[:order]).to eq 1
		end

		it "should convert sample_input 1 to an object with the original order id kept" do
			krakow_photos = sample_input_grouped["Krakow"]
			expect(krakow_photos.select { |p| p[:file_name] == "photo.jpg" }.first[:order]).to eq 1
			expect(krakow_photos.select { |p| p[:file_name] == "myFriends.png" }.first[:order]).to eq 3
		end

		it "should convert the sample_input 1 into a hash with all the cities as keys" do			
			expect(sample_input_grouped.keys).to include "Krakow"
			expect(sample_input_grouped.keys).to include "London"
			expect(sample_input_grouped.keys).to include "Florianopolis"
		end
	end

	context "assign an sequentical ID" do 
		it "should assign 1 for the first photo in Krakow" do
			expect(assign_an_id(hash_city)["Krakow"].first[:id]).to eq '1'
		end

		it "should assign 2 for the second photo in Krakow" do
			expect(assign_an_id(sample_input_grouped)["Krakow"][0][:id]).to eq '02'
		end

		it "should add 1 zero for Krakow and none to London" do
			expect(assign_an_id(sample_input_grouped)["Krakow"][0][:id]).to eq '02'
			expect(assign_an_id(sample_input_grouped)["London"][0][:id]).to eq '1'
		end		
	end

	context "rename_filename" do 
		it "should rename a sample line" do
			expect(rename_filename(assign_an_id(hash_city)).first[:new_name]).to eq "Krakow1.jpg"
		end	

		it "should rename the sample input" do
			krakow_photos = sample_input_grouped["Krakow"]
			expect(rename_filename(assign_an_id(sample_input_grouped)).first[:new_name]).to eq "Krakow02.jpg"
		end		
	end

	it "should rename the photos" do
		expect(solution(sample_input_1)).to eq(expected_ouput_for_input_1)
	end

end