#!/bin/bash
set -e
DF=.dockpipe/Dockerfile
RANDOM=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)
MODE="root"
cd $2
rm -Rf .dockpipe
mkdir -p .dockpipe
while read COMMAND
do
	echo $COMMAND
	case "$(echo "$COMMAND" | awk '{print $1}')" in
		SUB)
			echo "Entering SUB mode"
			MODE="sub"
			echo "$COMMAND" | awk '{print "FROM " $2 "\n"}' > $DF-$MODE
		;;
		RETURN)
			RETURN_LID=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)
			docker build -t dockpipe-$RETURN_LID -f $DF-$MODE .
			CID=$(docker create dockpipe-$RETURN_LID "")
			docker cp "$CID:$(echo "$COMMAND" | awk '{print $2}')" .dockpipe/ret-$RETURN_LID
			docker rm -f $CID
			echo "Leaving SUB mode"
			MODE="root"
			echo "ADD .dockpipe/ret-$RETURN_LID $(echo "$COMMAND" | awk '{print $3}')" >> $DF-$MODE
		;;
		*)
			echo "$COMMAND" >> $DF-$MODE
		;;
	esac
done < Dockerfile
docker build -t $1 -f $DF-root .
rm -Rf .dockpipe
