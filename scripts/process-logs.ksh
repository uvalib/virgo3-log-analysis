#
# script to run all the files through the extract script
#

if [ $# -ne 2 ]; then
   echo "use: $(basename $0) <in directory> <out directory>" >&2
   exit 1
fi

INDIR=$1
OUTDIR=$2

if [ ! -d $INDIR ]; then
   echo "ERROR: $INDIR does not exist or is not readable" >&2
   exit 1
fi

if [ ! -d $OUTDIR ]; then
   echo "ERROR: $OUTDIR does not exist or is not readable" >&2
   exit 1
fi

TMPFILE=/tmp/process.$$

# find all the files
find $INDIR -name search_production.log-* | sort > $TMPFILE

for file in $(<$TMPFILE); do

   DATE=$(echo $file | awk -F\- '{print $2}')
   echo "processing $file..."

   ./scripts/extract-data.ksh $file $OUTDIR/$DATE
done

rm $TMPFILE

exit 0

#
# end of file
#
