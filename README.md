#Garbage Reconciliation: Data Cleaning and Linking 
##Documents for the presentation on OpenRefine at Ohio IR day

###Acknowledgements
* Major thanks to Christina Harlow for not only creating LC-Reconcile, but also for creating and sharing this [excellent documentation](http://christinaharlow.com/openrefine-reconciliation-workshop-c4lmdc). 

* Data Carpentry has some great materials for [getting started with OpenRefine](http://www.datacarpentry.org/OpenRefine-ecology-lesson/01-working-with-openrefine.html).
###The setup - OpenRefine
* Ubuntu running in VirtualBox
* [Installation instructions](https://github.com/OpenRefine/OpenRefine/wiki/Installation-Instructions#linux)
* [requires jre](https://www.digitalocean.com/community/tutorials/how-to-install-java-on-ubuntu-with-apt-get)

###The goals
1. Perform authority control on all names and subject headings
2. Save a copy of controlled entities as URLs for future updates
3. Apply a list of new subject headings to existing records

###The setup - LC Reconcile

1. ```git clone https://github.com/cmh2166/lc-reconcile.git```
2. ```cd lc-reconcile```
3. ```sudo pip install -r requirements.txt```
4. ```python reconcile.py```
5. The service should be running on http://0.0.0.0:5000
6. Leave that terminal open and open OpenRefine.

###Starting OR
1. Switch to directory where OR is installed and ```./refine```
2. A browser should open and go to http://127.0.0.1:3333/

###The data
1. In a DRC repository, go to a collection and click 'Export metadata.'
2. Save in your working directory as 'data/original_data.csv'
3. The data must be saved in csv format with UTF-8 encoding. 
4. To convert a csv to UTF-8 encoding, you can use the encode-utf8.rb in this repository with ```./encode-utf8.rb infile.csv outfile.csv```

###Import
1. In OR, browse to your file and click 'next.'
2. Make sure the encoding is UTF-8.
3. Columns are separated by commas (make sure nothing else is checked). 
4. Check 'parse next 1 line(s) as column headers.'
5. Check 'quotation marks are used to enclose cells containing column separators.'
6. Create project
7. Make sure the number of rows matches the number of records in your collection. 

###Letting OR know where to find LC Reconcile
1. in OR, under dc.contributor.author go to Reconcile > Start reconciling
2. Add Standard Service
3. Enter http://0.0.0.0:5000/
4. For now, cancel the reconciliation because we haven't looked at the data yet.

###Identifying data to clean
####Names
1. dc.contributor.author
2. dc.subject
3. Notice that there is more than one entry per column:
	Ashbery, John, 1927-||Lehman, David, 1948-

####Splitting values
1. We'll need to separate these so we can work on each piece of data.
2. Go to the arrow next to dc.contributor.author
3. Edit column > Split into several columns...
4. Separator = ||
5. Now we have over a dozen columns with dc.contributor.author and it will be hard to work on these. Another solution is to separate the authors by creating a new record for each one. 
6. In the undo/redo pane, click on 0 to undo the changes.4. Now we have over a dozen columns with dc.contributor.author and it will be hard to work on these. Another solution is to separate the authors by creating a new row for each one. For more on rows/records, see [the Programming Historian's post on Cleaning Data with OpenRefine](http://programminghistorian.org/lessons/cleaning-data-with-openrefine). 
7. On the dc.contributors.author column, click on Edit Cells > Split multivalue cells
8. Additional authors are now placed in their own row, so we can work on all authors in one column. 

####Cleaning the values
1. We will want to get the data as close to the format with which it will be reconciled as possible. 
2. Any time we use GREL, it can be applied via the column header triangle > Edit Cells > Transform...
3. Remove the trailing years from the names with GREL ```value.replace(/[0-9]/"")```
4. Remove the extra whitespace with GREL ```trim(value)```
5. Remove the trailing comma with value.replace(/,$/,"")

###Reconciliation
1. Now we can reconcile the names following the steps outlined above.
2. When reconciliation is complete, we may still need to select the best match. Look at Claudia Emerson. There are 3 possible matches for her name. Clicking on an item will take you to its page at id.loc.gov. After looking determining the correct match, click on the double check box to apply that heading to all identical cells.
3. We can view only those that need attention by selecting 'none' under the judgment facet

###Find and replace
* There are likely still values that will need to be updated that the reconciliation service missed.
1. On the column arrow, select Edit Cells > Transform
2. In expression, you can use GREL 
3. For find and replace: ```value.replace(/Giovanni.*/,"Giovanni, Nikki")```
4. We may want to reconcile again if values are more likely to be recognized.
5. Removing values: ```value.replace("The Elliston Project: ","")```
6. Replace all occurrences of anything starting with the word 'Dwelling' with 'Dwelling, a Poetry Podcast: ```value.replace(/^Dwelling/,"Dwelling, a Poetry Podcast")```

###Bringing them back together 
* wait to do this if we're assigning addtional subjects to the records
1. Are we done working on this column? If so, let's bring the values back together.
2. In the column triangle, select Edit Cells > Join multi-valued cells
3. Choose a separator that won't be found in the data such as ||.
4. Export as a csv with a name like 'subject_clean.csv'

###Adding data
1. We have a list of subject headings and the authors to which those headings are to be applied. Do we just search for names and paste in the headings?
2. For large datasets, it's better to compare each record to a key-value structure that maps authors to subjects.
3. E.g. {"Levertov, Denise" => ["Frost Medal", "New American Poetry", "Feminism"]}
4. If we're going to match the data to the keys in our subjects, we'll need to reconcile both.
5. The author names we were given had names in direct order. Use invert_order.rb to put the last name first. It's not perfect, but gets us closer to inverse order.
6. In the file with our records, make sure the multi-value cells have been split into mulitple rows 
7. Reconcile the subject dictionary file just like we did for the records. 
8. Export the dictionary file as 'dictionary.csv'.
9. With the reconciled subject dictionary, run the script apply_mapping.rb with the command ```ruby apply_mapping.rb data/subj_clean.csv data/mapping_output.csv 2 31 data/dictionary.csv``` where 2 is the column in the input data (subj_clean.csv) that holds the values we want to compare against the subject dictionary. 31 is the number of the column in the input data to which we'd like to append the subjects when a match is found.  
10. Import mapping_out.csv into OR and  join multi-valued cells as we did above.
11. Export as CSV and upload to the repository. Be sure to save a copy of the OR project as well.

###The result
####We now have
1. A set of records on which we've performed cleaning and authority control.
2. An OR Project with URIs pointing to id.loc.gov that can be used for updating headings or beginning a linked data project.
3. A subject > author dictionary that has been reconciled with the LCNAF that can be applied to future records.

###The takeaway
* Learning regular expressions (regex) is the first and most important step in mastering data wrangling. All of these tools are at their core ways to help you apply regex to your data. 

