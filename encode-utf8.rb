#encode_utf8.rb
require 'csv'

#usage ./encode_uf8.rb infile.csv outfile.csv
#where infile is the file to be converted and the outfile is the name of the output file. Cannot be the same

unless ARGV.length == 2
	puts "usage: ./encode_utf8.rb infile.csv outfile.csv"
	exit
end

bad_file = File.read(ARGV[0])
enc_file = bad_file.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
out_file = open(ARGV[1], "wb")
out_file.write(enc_file)
out_file.close
