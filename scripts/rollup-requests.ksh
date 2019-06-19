#
# script to process all the request files and generate summary information
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

TMPFILE=/tmp/rollup-requests.$$

# find all the files
find $INDIR -name *.requests.summary | sort > $TMPFILE

SUMMARY_FILE=$INDIR/summary.requests
rm $SUMMARY_FILE > /dev/null 2>&1

for file in $(<$TMPFILE); do
   DATE=$(basename $file ".requests.summary")
   TOTAL=$(grep "total requests" $file | awk '{print $1}')
   MAX_HOUR=$(grep "Max requests" $file | awk '{print $3}')
   echo "$DATE total requests: $TOTAL"  >> $SUMMARY_FILE
   echo "$DATE max/hour: $MAX_HOUR"  >> $SUMMARY_FILE
   echo "" >> $SUMMARY_FILE
done

rm $TMPFILE

grep "total requests" $SUMMARY_FILE | awk '{print $4, $1}' | sort -n | tail -1 | awk '{printf "Most requests: %s (on %s)\n", $1, $2}' >> $SUMMARY_FILE
grep "max/hour" $SUMMARY_FILE | awk '{print $3, $1}' | sort -n | tail -1 | awk '{printf "Max/hour: %s (on %s)\n", $1, $2}' >> $SUMMARY_FILE

echo "summary available $SUMMARY_FILE"

exit 0

#
# end of file
#
