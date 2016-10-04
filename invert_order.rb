#invert_order.rb
require 'csv'

#note: the outfile must exist before running script 
#in correct directory, execute 'touch filename' where filename is the name of the output file

unless ARGV.length == 3
	puts "usage: ruby invert_order.rb inputfilename.csv outputfilename.csv 0 (where 0 is the number of the column to invert)"
	exit
end

def reverse_name(name)
	last_name = ""
	first_name = ""
  if name
		full_name = name.split(" ")
		if full_name[1]
			last_name = full_name[-1]
			first_name = full_name[0...-1].join(" ")
			return last_name.to_s + ", " + first_name
		else
			return name
		end
	end
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

CSV.foreach(infile, col_sep: ',') do |row|
	#puts row
	out_row = row
	if out_row[column]
		out_row[column] = reverse_name(row[column])
		puts out_row[column]
	end
	output_data << out_row
end

output(output_data, outfile)

