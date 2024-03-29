#
# pipeline to process the virgo logs into something meaningfull
#

LOG_SET=may-june
SOURCE_DIR=../$LOG_SET/logs
RESULTS_DIR=../$LOG_SET/results
INTERESTING_SERVERS="vbt03 vbt04"

# the interesting result sets
for i in $INTERESTING_SERVERS; do

   mkdir -p $RESULTS_DIR/$i

   # first stage, extract the details from the virgo logs
   ./scripts/process-logs.ksh $SOURCE_DIR/$i $RESULTS_DIR/$i

   # next stage, split the responses by HTTP status and create histograms and percentiles
   ./scripts/process-responses.ksh $RESULTS_DIR/$i
   ./scripts/process-split-responses.ksh $RESULTS_DIR/$i

   # next stage, split the requests up by query path
   ./scripts/process-requests.ksh $RESULTS_DIR/$i
   ./scripts/process-split-requests.ksh $RESULTS_DIR/$i

   # lastly, summerize by month
   ./scripts/rollup-responses.ksh $RESULTS_DIR/$i
   ./scripts/rollup-requests.ksh $RESULTS_DIR/$i
done

#
# end of file
#
