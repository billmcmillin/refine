#dedup_within_column.rb

require 'csv'

#takes a csv file and examines each row of the specified column to determine if duplicate values have been entered into a multivalue column
#for instance a cell with the value "a||b||c||a" will have the second a removed
#run with ruby dedup_within_column.rb 

unless ARGV.length == 4
	puts "usage: ruby dedup_within_column.rb inputfilename.csv outputfilename.csv 0 \"sep\" where 0 is the column to be operated on and sep is the value separating values within the cell" 
	exit
end

def output(data, outfile)
	CSV.open(outfile, "wb") do |csv_out|
		data.each do |row_array|
			csv_out << row_array
		end
	end
end


##procedure
output_data = []
infile = ARGV[0]
outfile = ARGV[1]
column = ARGV[2].to_i
sep = ARGV[3]

CSV.foreach(infile, col_sep: ',') do |row|
	#puts row
	out_row = row
	if out_row[column]
		subjs = out_row[column].split(sep).uniq	
		out_row[column] = subjs.join("||")
	end
	puts out_row
	output_data << out_row
end

output(output_data, outfile)

