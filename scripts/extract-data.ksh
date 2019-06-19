#
# script to extract the request times and response times from the specified log file
#

if [ $# -ne 2 ]; then
   echo "use: $(basename $0) <infile> <outfile base>" >&2
   exit 1
fi

INFILE=$1
OUTBASE=$2

if [ ! -f $INFILE ]; then
   echo "ERROR: $INFILE does not exist or is not readable" >&2
   exit 1
fi

# output file names
REQUEST_NAME=${OUTBASE}.requests
RESPONSE_NAME=${OUTBASE}.responses

# create request list 
grep "^Started " $INFILE | awk '{print $7, $8, $9, $2, $3}' > $REQUEST_NAME

# create response time list
grep "^Completed \d\d\d" $INFILE | awk '{print $2, $5, $6}' | sed -e 's/ (Views://g'| sed -e 's/ in / /g' > $RESPONSE_NAME

exit 0

#
# end of file
#
