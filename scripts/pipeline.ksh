#
# pipeline to process the virgo logs into something meaningfull
#

SOURCE_DIR=source
RESULTS_DIR=results

# the interesting result sets
for i in vbt03 vbt04; do

   # first stage, extract the details from the virgo logs
   #./scripts/process-logs.ksh source/$i results/$i

   # next stage, split the responses by HTTP status and create histograms and percentiles
   #./scripts/process-responses.ksh results/$i
   #./scripts/process-split-responses.ksh results/$i

  # next stage, split the requests up by query path
  #./scripts/process-requests.ksh results/$i
  ./scripts/process-split-requests.ksh results/$i

done

#
# end of file
#
