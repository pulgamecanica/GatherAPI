require "http"
require "json"

API_ENCODED_SECRET="Your Secret"
API_SECRET="Your Secret"
SPACE_ID="8V8iMEujg5pMIMaA"
SPACE_NAME="42Portfolio"
BASE_URL="api.gather.town/api"
PROTOCOLE="https"
CONTENT_TYPE="application/json"

# Source: https://stackoverflow.com/questions/1489183/how-can-i-use-ruby-to-colorize-the-text-output-to-a-terminal
class String
	def black;          "\e[30m#{self}\e[0m" end
	def red;            "\e[31m#{self}\e[0m" end
	def green;          "\e[32m#{self}\e[0m" end
	def brown;          "\e[33m#{self}\e[0m" end
	def blue;           "\e[34m#{self}\e[0m" end
	def magenta;        "\e[35m#{self}\e[0m" end
	def cyan;           "\e[36m#{self}\e[0m" end
	def gray;           "\e[37m#{self}\e[0m" end

	def bg_black;       "\e[40m#{self}\e[0m" end
	def bg_red;         "\e[41m#{self}\e[0m" end
	def bg_green;       "\e[42m#{self}\e[0m" end
	def bg_brown;       "\e[43m#{self}\e[0m" end
	def bg_blue;        "\e[44m#{self}\e[0m" end
	def bg_magenta;     "\e[45m#{self}\e[0m" end
	def bg_cyan;        "\e[46m#{self}\e[0m" end
	def bg_gray;        "\e[47m#{self}\e[0m" end

	def bold;           "\e[1m#{self}\e[22m" end
	def italic;         "\e[3m#{self}\e[23m" end
	def underline;      "\e[4m#{self}\e[24m" end
	def blink;          "\e[5m#{self}\e[25m" end
	def reverse_color;  "\e[7m#{self}\e[27m" end
	def no_colors
	  self.gsub /\e\[\d+m/, ""
	end
end

# Display some Meta Info this can help trace issues with base variables
puts "*".blue.bg_cyan * 42
puts "Space ID:\t#{SPACE_ID}".bg_cyan	
puts "Space Name:\t#{SPACE_NAME}".bg_cyan
puts "Protocole:\t#{PROTOCOLE}".bg_cyan
puts "BASE_URL:\t#{BASE_URL}".bg_cyan
puts "*".blue.bg_cyan * 42

# Create file with write access
# Write the content to the file 
# Close the file
# Output success message
def save_to_file(file_name, content)
	if (file_name && content)
		out_file = File.new(file_name, "w")
		out_file.puts(content)
		out_file.close
	end
	puts " +\tFile saved (creating) --> #{file_name}".bold.green
end

# Put togeather the string to make an HTTP request
# See more about how the gather api should receive requests
# 	- https://gathertown.notion.site/Gather-HTTP-API-3bbf6c59325f40aca7ef5ce14c677444#9b3f938f84c645b9a1bff488d782cc22
# Show full request formed
# Start HTTP request, with porper headers
# Create File Name String
# Save request to file
# See more about how HTTP gem works:
#  - https://github.com/httprb/http/wiki
def get_maps(space_id=SPACE_ID, space_name=SPACE_NAME)
	request_url = PROTOCOLE + "://" + BASE_URL + "/v2/spaces/" + space_id + "\\" + space_name + "/maps/"
	puts "[GET " + request_url.bold.blue + "]"
	begin
		response = HTTP.headers(apiKey: API_SECRET, accept: CONTENT_TYPE).get(request_url)
		file_name = "gather_#{space_name}_maps.json"
		save_to_file(file_name, response.to_s)
	rescue
		File.delete(file_name)
		puts " -\tSomthing went wrong (deleting) --> #{file_name}".red
		return
	end
	parsed_maps = JSON.parse(response.to_s)
	puts "[#{parsed_maps.length}]".bold.brown + " Maps for: " + space_name.bold.blue
	maps_hash = {}
	parsed_maps.each do |map|
		puts " > Name:\t" + map["name"].magenta.bg_blue
		puts " > Id:\t\t" + map["id"].magenta.bg_blue
		puts "\n"
		maps_hash[map["name"]] = map["id"]
	end
	puts "MapsHash:\t" + maps_hash.to_s
	maps_hash
end

maps = get_maps

