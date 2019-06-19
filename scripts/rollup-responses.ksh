#
# script to process all the response files and generate summery information
#

if [ $# -ne 1 ]; then
   echo "use: $(basename $0) <in directory>" >&2
   exit 1
fi

INDIR=$1

if [ ! -d $INDIR ]; then
   echo "ERROR: $INDIR does not exist or is not readable" >&2
   exit 1
fi

TMPFILE=/tmp/rollup-responses.$$

# find all the files
find $INDIR -name *.responses.http-200 | sort > $TMPFILE

SUMMERY_FILE=$INDIR/summery.http-200
rm $SUMMERY_FILE > /dev/null 2>&1

for file in $(<$TMPFILE); do
   cat $file >> $SUMMERY_FILE
done

rm $TMPFILE

# summery results too
HISTFILE=$SUMMERY_FILE.hist
PERCENTFILE=$SUMMERY_FILE.percentile
echo "processing $SUMMERY_FILE..."
./scripts/response-histogram.ksh $SUMMERY_FILE > $HISTFILE
echo "histogram available in $HISTFILE..."
./scripts/report-percentiles.ksh $SUMMERY_FILE > $PERCENTFILE
echo "percentiles available in $PERCENTFILE..."

exit 0

#
# end of file
#
