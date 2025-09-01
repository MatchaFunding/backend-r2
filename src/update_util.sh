HEADER=util.h
rm util.h
for file in sql/*.h
do
    echo -e "#include \"$file\"" >> $HEADER
done
