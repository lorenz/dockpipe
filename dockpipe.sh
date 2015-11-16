TEMP=$(mktemp -d)
while read command
do
    echo "$command" > $TEMP/Dockerfile1
done < $1