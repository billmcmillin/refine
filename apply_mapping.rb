#apply_mapping.rb

require 'csv'
require 'pp'

#takes a csv file, removes the specified element fromt the specified column and outputs the modified csv
#in correct directory, execute 'touch filename' where filename is the name of the output file

#execution: :!ruby apply_mapping.rb data/Elliston_subj_clean.csv data/Elliston_mapped.csv 2 30 map_to_dc-subject-lcsh.csv
# use data/Elliston_subj_clean.csv as source data
# use data/Elliston_mapped.csv as output file
# use column 2 in source data as the key
# use column 30 to append the value to 
# use map_to_dc-subject-lcsh.csv as the dictionary

#cleanup for non-lcsh subject headings was run with
#!ruby apply_mapping.rb data/Elliston_subj_clean.csv data/Elliston_mapped.csv 2 31 data/map_to_dc_subj_master.csv

unless ARGV.length == 5
	puts "usage: ruby remove_element.rb inputfilename.csv outputfilename.csv 0 1 mapping_file.csv(where 0 is the column to operate on and 1 is the column to which the value will be appended with '||')" 
	exit
end

def output(data, column_lookup, column_append, outfile, dictionary)
	CSV.open(outfile, "wb") do |csv_out|
		data.each_with_index do |row_array, i|
			key = row_array[column_lookup]
			dictionary[key].each do |val|
				if row_array[column_append]
					row_array[column_append] << "||" + val.to_s
					#puts key + i.to_s + row_array[column_append]
				else
					row_array[column_append] = val.dup
					#puts key + i.to_s + row_array[column_append]
				end
			end
			csv_out << row_array
		end
	end
end

def create_dict(dict_file)
	dict = Hash.new {|h,k| h[k] = []}
	CSV.foreach(dict_file, headers: true) do |row|
		row.each do |val|
			if val[1]
				#puts val[1] + val[0]
				dict[val[1]] << val[0]
			end
		end	
	end
	pp dict.to_s
	dict
end

##procedure
output_data = [] #to be written to the final output file
infile = ARGV[0] #this file should be the cleaned, reconciled item records 
outfile = ARGV[1] #this file is what will be written to
column_lookup = ARGV[2].to_i #in the infile, which column has the author name to which we want to assign the subject?
column_append = ARGV[3].to_i #in the infile, to which column do we want to append the value of the subject (which column is dc.subject)?
dict_file = ARGV[4] #this file is the reconciled csv in which column headers are subject categories and the values in each column are the names to which the subjects should be applied

#read the inputput file
CSV.foreach(infile, col_sep: ',') do |row|
	#puts row
	out_row = row
	output_data << out_row
end

#create the dictionary
dictionary = create_dict(dict_file)
#compare the data from the input file to the dictionary and if a match is found, append the corresponding value. then output the file.
output(output_data, column_lookup, column_append, outfile, dictionary)

