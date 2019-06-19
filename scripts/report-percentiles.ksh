#
# script to calculate percentiles from the file contents numbers
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

echo "processing $INFILE"

TMPFILE=/tmp/summery.$$
cat $INFILE | sort -n > $TMPFILE

# Count number of data points
N=$(wc -l $TMPFILE | awk '{print $1}')
echo "calculating for $N datapoints"

# Calculate line numbers for each percentile we're interested in
P50=$(dc -e "$N 2 / p")
P90=$(dc -e "$N 9 * 10 / p")
P99=$(dc -e "$N 99 * 100 / p")

PC50=$(awk "FNR==$P50" $TMPFILE)
PC90=$(awk "FNR==$P90" $TMPFILE)
PC99=$(awk "FNR==$P99" $TMPFILE)
PC100=$(awk "FNR==$N" $TMPFILE)

echo "percentage of values within a certain time (ms)"
echo " 50%:  $PC50"
echo " 90%:  $PC90"
echo " 99%:  $PC99"
echo " 100%: $PC100 (largest)"

rm $TMPFILE

exit 0

#
# end of file
#
