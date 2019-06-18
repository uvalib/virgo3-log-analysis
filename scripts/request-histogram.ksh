#
# script to create a histogram of request times
#

if [ $# -ne 1 ]; then
   echo "use: $(basename $0) <infile>"
   exit 1
fi

INFILE=$1

if [ ! -f $INFILE ]; then
   echo "ERROR: $INFILE does not exist or is not readable"
   exit 1
fi

TOOL_NAME=hist
which $TOOL_NAME > /dev/null 2>&1
res=$?
if [ $res -ne 0 ]; then
   echo "$TOOL_NAME is not available in this environment"
   exit 1
fi

TMPFILE=/tmp/hist.$$

cat $INFILE | awk '{print $2}' | awk -F: '{printf "%d\n", (int($1)*3600) + (int($2)*60) + int($3)}' > $TMPFILE
$TOOL_NAME -n -b 24 -f $TMPFILE -p. -t "Requests (per hour)"
rm $TMPFILE

exit 0

#
# end of file
#
