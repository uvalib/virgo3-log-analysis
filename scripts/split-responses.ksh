#
# script to split the response information by HTTP return code
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

for i in 200 302 400 404; do
   grep "^$i " $INFILE | grep -v "^$i 0ms" | awk '{print $2}' | sed -e 's/ms$//g' > $INFILE.http-$i
done

exit 0

#
# end of file
#
