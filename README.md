#Garbage Reconciliation: Data Cleaning and Linking. 
##Documents for the presentation on OpenRefine at Ohio IR day.

###Acknowledgements
*Major thanks to Christina Harlow for not only creating LC-Reconcile, but also for creating and sharing this [excellent documentation](http://christinaharlow.com/openrefine-reconciliation-workshop-c4lmdc). 

*Data Carpentry has some great materials for [getting started with OpenRefine](http://www.datacarpentry.org/OpenRefine-ecology-lesson/01-working-with-openrefine.html).
###The setup - OpenRefine
*Ubuntu running in VirtualBox
**[Installation instructions](https://github.com/OpenRefine/OpenRefine/wiki/Installation-Instructions#linux)
**[requires jre](https://www.digitalocean.com/community/tutorials/how-to-install-java-on-ubuntu-with-apt-get)

###The setup - LC Reconcile

1. ```git clone https://github.com/cmh2166/lc-reconcile.git'''
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

**Notice that there is more than one entry per column:
Ashbery, John, 1927-||Lehman, David, 1948-

**We'll need to separate these so we can work on each piece of data.
1. Go to the arrow next to dc.contributor.author
2. Edit column > Split into several columns...
3. Separator = ||
4. Now we have over a dozen columns with dc.contributor.author and it will be hard to work on these. Another solution is to separate the authors by creating a new record for each one. 
5. In the undo/redo pane, click on 0 to undo the changes.4. Now we have over a dozen columns with dc.contributor.author and it will be hard to work on these. Another solution is to separate the authors by creating a new row for each one. For more on rows/records, see [the Programming Historian's post on Cleaning Data with OpenRefine](http://programminghistorian.org/lessons/cleaning-data-with-openrefine). 
6. On the dc.contributors.author column, click on Edit Cells > Split multivalue cells
7. Additional authors are now placed in their own row, so we can work on all authors in one column. 
8. Now we can reconcile the names following the steps outlined above.
9. When reconciliation is complete, we may still need to select the best match. Look at Claudia Emerson. There are 3 possible matches for her name. Clicking on an item will take you to its page at id.loc.gov. After looking determining the correct match, click on the double check box to apply that heading to all identical cells.

###Find and replace
*There are likely still values that will need to be updated that the reconciliation service missed.
1. On the column arrow, select Edit Cells > Transform
2. In expression, you can use GREL 
3. For find and replace: value.replace(/Giovanni.*/,"Giovanni, Nikki"
4. We may want to reconcile again if values are more likely to be recognized.

###Bringing them back together
1. Are we done working on this column? If so, let's bring the values back together.

