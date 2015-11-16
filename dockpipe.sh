TEMP=$(mktemp -d)
while read command
do
	CMD=$(echo "$command" | awk '{print $1}')
	case "$CMD" in
		SUB)
			
			;;
		RETURN)
			
	esac
    echo "$command" > $TEMP/Dockerfile1
done < $1