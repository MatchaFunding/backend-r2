HEADER=util.h
rm util.h
for file in model/*.h
do
    echo -e "#include \"$file\"" >> $HEADER
done
for file in json/*.h
do
    echo -e "#include \"$file\"" >> $HEADER
done
