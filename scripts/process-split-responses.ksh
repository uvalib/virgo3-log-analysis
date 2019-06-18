#
# script to process all the response files and generate summery information
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

TMPFILE=/tmp/split-responses.$$

# find all the files
find $INDIR -name *.responses.http-200 | sort > $TMPFILE

for file in $(<$TMPFILE); do
   echo "processing $file..."
   HISTFILE=$file.hist
   PERCENTFILE=$file.percentile
   ./scripts/response-histogram.ksh $file > $HISTFILE
   ./scripts/report-percentiles.ksh $file > $PERCENTFILE
done

rm $TMPFILE

exit 0

#
# end of file
#
