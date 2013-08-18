dir=/usr/share/common-bashing
if [ ! -d $dir ]; then
  exit 1
fi

find $dir/ -name "*.sh" | grep -v all.sh | while read f; do
  echo "sourcing" $f
  source $f
done
