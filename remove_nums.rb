#remove_element.rb

require 'csv'

#takes a csv file, removes the specified element fromt the specified column and outputs the modified csv
#in correct directory, execute 'touch filename' where filename is the name of the output file

unless ARGV.length == 3
	puts "usage: ruby remove_element.rb inputfilename.csv outputfilename.csv 0 (where 0 is the column to operate on (e.g. 0 removes the first, -1 removes the last)" 
	exit
end

def output(data, outfile)
	CSV.open(outfile, "wb") do |csv_out|
		data.each do |row_array|
			csv_out << row_array
		end
	end
end

def remove_trailing_comma(str)
	str.nil? ? nil : str.chomp(',')
end

##procedure
output_data = []
infile = ARGV[0]
outfile = ARGV[1]
column = ARGV[2].to_i

CSV.foreach(infile, col_sep: ',') do |row|
	#puts row
	out_row = row
	if out_row[column]
		out_row[column] = out_row[column].gsub(/[0-9-]/,"")
		out_row[column] = remove_trailing_comma(out_row[column].strip)
		puts out_row[column]	
	end
	output_data << out_row
end
output(output_data, outfile)

