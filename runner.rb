
require_relative "lib/heartland_challenge"

input = File.read("input.txt")
output = solution(input)
File.open("output.txt", "w+") { |f| f.puts output }