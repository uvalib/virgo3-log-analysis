#
# script to run all the response files and generate histograms
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

TMPFILE=/tmp/process.$$

# find all the files
find $INDIR -name *.responses.http-200 | sort > $TMPFILE

SUMMERY_FILE=$INDIR/summery.http-200
rm $SUMMERY_FILE > /dev/null 2>&1

for file in $(<$TMPFILE); do
   echo "processing $file..."
   cat $file >> $SUMMERY_FILE
   HISTFILE=$file.hist
   PERCENTFILE=$file.percentile
   ./scripts/response-histogram.ksh $file > $HISTFILE
   ./scripts/report-percentiles.ksh $file > $PERCENTFILE
done

rm $TMPFILE

# summery results too
HISTFILE=$SUMMERY_FILE.hist
PERCENTFILE=$SUMMERY_FILE.percentile
echo "processing $SUMMERY_FILE..."
./scripts/response-histogram.ksh $SUMMERY_FILE > $HISTFILE
./scripts/report-percentiles.ksh $SUMMERY_FILE > $PERCENTFILE

exit 0

#
# end of file
#
