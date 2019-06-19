#
# script to process all the response files and generate summary information
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

SUMMARY_FILE=$INDIR/summary.http-200
rm $SUMMARY_FILE > /dev/null 2>&1

for file in $(<$TMPFILE); do
   cat $file >> $SUMMARY_FILE
done

rm $TMPFILE

# summary results too
HISTFILE=$SUMMARY_FILE.hist
PERCENTFILE=$SUMMARY_FILE.percentile
echo "processing $SUMMARY_FILE..."
./scripts/response-histogram.ksh $SUMMARY_FILE > $HISTFILE
echo "histogram available in $HISTFILE..."
./scripts/report-percentiles.ksh $SUMMARY_FILE > $PERCENTFILE
echo "percentiles available in $PERCENTFILE..."

exit 0

#
# end of file
#
