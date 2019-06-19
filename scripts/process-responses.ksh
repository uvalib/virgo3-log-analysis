#
# script to process all the response files
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

TMPFILE=/tmp/responses.$$

# find all the files
find $INDIR -name *.responses | sort > $TMPFILE

for file in $(<$TMPFILE); do
   echo "processing $file..."
   ./scripts/split-responses.ksh $file
done

rm $TMPFILE

exit 0

#
# end of file
#
