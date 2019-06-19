#
# script to split the request information by URL
#

if [ $# -ne 1 ]; then
   echo "use: $(basename $0) <infile>" >&2
   exit 1
fi

INFILE=$1

if [ ! -f $INFILE ]; then
   echo "ERROR: $INFILE does not exist or is not readable" >&2
   exit 1
fi

# Count number of data points
N=$(grep " GET " $INFILE | wc -l | awk '{print $1}')

# root query
grep " GET \"/\"" $INFILE | awk '{print $1, $2, $5}' > $INFILE.path.root

# all the other paths we are interested in
INTERESTING_PATHS="account articles catalog fedora folder music shelf_browse video"

# specific path queries
for i in $INTERESTING_PATHS; do
   grep " GET \"/$i" $INFILE | awk '{print $1, $2, $5}' > $INFILE.path.$i
done

# create the summary file

SUMMERY_FILE=$INFILE.summery
rm $SUMMERY_FILE > /dev/null 2>&1

echo "$N total requests\n" >> $SUMMERY_FILE

for i in root $INTERESTING_PATHS; do
   N=$(wc -l $INFILE.path.$i | awk '{print $1}')
   printf " %-15s : %d\n" $i $N >> $SUMMERY_FILE
done

# calculate the maximum number of requests per hour (exclude root queries)
grep " GET \"" $INFILE | grep -v " GET \"/\"" | awk '{print $2}' | awk -F: '{print $1}' | sort | uniq -c | sort -n | tail -1 | awk '{ printf "\nMax requests/hour: %s (%s:00 hours). This excludes root/healthchecks\n", $1, $2}' >> $SUMMERY_FILE

exit 0

#
# end of file
#
