#
# script to process all the request files and generate summery information
#

if [ $# -ne 1 ]; then
   echo "use: $(basename $0) <in directory>"
   exit 1
fi

INDIR=$1

if [ ! -d $INDIR ]; then
   echo "ERROR: $INDIR does not exist or is not readable"
   exit 1
fi

TMPFILE=/tmp/split-requests.$$

# find all the files
find $INDIR -name *.requests.path.* | grep -v ".hist$" | sort > $TMPFILE

for file in $(<$TMPFILE); do
   echo "processing $file..."
   HISTFILE=$file.hist
   #PERCENTFILE=$file.percentile
   ./scripts/request-histogram.ksh $file > $HISTFILE
   #./scripts/report-percentiles.ksh $file > $PERCENTFILE
done

rm $TMPFILE

# summery results too
#HISTFILE=$SUMMERY_FILE.hist
#PERCENTFILE=$SUMMERY_FILE.percentile
#echo "processing $SUMMERY_FILE..."
#./scripts/response-histogram.ksh $SUMMERY_FILE > $HISTFILE
#./scripts/report-percentiles.ksh $SUMMERY_FILE > $PERCENTFILE

exit 0

#
# end of file
#
