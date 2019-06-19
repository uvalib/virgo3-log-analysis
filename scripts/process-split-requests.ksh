#
# script to process all the request files and generate summery information
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

TMPFILE=/tmp/split-requests.$$

# find all the files
find $INDIR -name *.requests.path.* | grep -v ".hist$" | sort > $TMPFILE

for file in $(<$TMPFILE); do
   echo "processing $file..."
   HISTFILE=$file.hist
   ./scripts/request-histogram.ksh $file > $HISTFILE
   echo "histogram available in $HISTFILE..."
done

rm $TMPFILE

exit 0

#
# end of file
#
