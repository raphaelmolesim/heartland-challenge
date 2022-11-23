# Group by City > Order by Time > Assigns a sequential ID starting with 1
# Rename filenames <city_name><foto_id>.<extesion>, where:
  # <foto_id> need to have fixed amount of characters
  # <extension> should be kept the same before rename
# current name pattern: <\<photoname>>.<\<extension>>, <<city_name>>, yyyy-mm-dd, hh:mm:ss
  # where '<<photo_name>>', '<\<extension>>' and, '<<city_name>>' consist only of letters of the English alphabet

require 'date'

def solution(s)
	output = rename_filename(assign_an_id(group_by_city(s)))
		.sort { |p1, p2| p1[:order] <=> p2[:order] }
		.map { |p| p[:new_name] }.join("\n")
	"""
#{output}
"""
end

def group_by_city s
	order_counter = 1
	s.split(/\n+/).inject({}) do |r, line|
		next r if line == ""
		file_name, city, taken_at = line.split(",")
		city = city.strip
		item = { 
			:file_name => file_name.strip, 
			:taken_at => DateTime.parse(taken_at.strip), 
			:order => order_counter }
		order_counter += 1
		item[:extension] = item[:file_name].split('.').last
		r[city] = []  if not r[city]
		r[city] << item
		r
	end
end

def assign_an_id hash_cites
	hash_cites.each do |city, photos|
		c = 1
		pad_size = (photos.size > 9 ? (photos.size > 99 ? 3 : 2) : 1)
		sequential_counter = -> { c = c + 1 ; c - 1 }
		photos.sort { |p1, p2| p1[:taken_at] <=> p2[:taken_at] }
			.map! { |p| p[:id] = sequential_counter[].to_s.rjust(pad_size, "0") ; p}

	end
end

def rename_filename hash_cites
	result = []
	hash_cites.each do |city, photos|
		photos.each do |p|
			result << { :new_name => "#{city}#{p[:id]}.#{p[:extension]}", :order => p[:order] }
		end
	end
	result
end


input = File.read("input.txt")
output = solution(input)
File.open("output.txt", "w+") { |f| f.puts output }