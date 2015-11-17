#!/bin/bash
set -e
DF=.dockpipe/Dockerfile
TARGET=$2
RANDOM=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)
MODE="root"
rm -Rf $TARGET/.dockpipe
mkdir -p $TARGET/.dockpipe
while read COMMAND
do
	echo $COMMAND
	case "$(echo "$COMMAND" | awk '{print $1}')" in
		SUB)
			echo "Entering SUB mode"
			MODE="sub"
			echo "$COMMAND" | awk '{print "FROM " $2 "\n"}' > $TARGET/$DF-$MODE
		;;
		RETURN)
			RETURN_LID=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)
			docker build -t dockpipe-$RETURN_LID -f $DF-$MODE $2
			CID=$(docker create dockpipe-$RETURN_LID)
			docker cp "$CID:$(echo "$COMMAND" | awk '{print $2}')" $TARGET/.dockpipe/ret-$RETURN_LID
			docker rm -f $CID
			echo "Leaving SUB mode"
			MODE="root"
			echo "ADD $TARGET/.dockpipe/ret-$RETURN_LID $(echo "$COMMAND" | awk '{print $3}')" >> $TARGET/$DF-$MODE
		;;
		*)
			echo "$COMMAND" >> $TARGET/$DF-$MODE
		;;
	esac
done < $2/Dockerfile
docker build -t $1 -f $DF-root $2
rm -Rf $TARGET/.dockpipe