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
			MODE="sub"
			echo "$COMMAND" | awk '{print "FROM " $2 "\n"}' > $DF-$MODE
		;;
		RETURN)
			RETURN_LID=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32)
			docker build -t dockpipe-$RETURN_LID -f $DF-$MODE .
			CID=$(docker create dockpipe-$RETURN_LID "")
			docker cp "$CID:$(echo "$COMMAND" | awk '{print $2}')" .dockpipe/ret-$RETURN_LID
			docker rm -f $CID
			
			MODE="root"
			echo "ADD .dockpipe/ret-$RETURN_LID $(echo "$COMMAND" | awk '{print $3}')" >> $DF-$MODE
		;;
		*)
			echo "$COMMAND" >> $DF-$MODE
		;;
	esac
done < Dockerfile

# Build root image
docker build -t $1 -f $DF-root .

# Push if given tag is on a registry
if [[ $1 =~ [^/]+/[^/]+/[^/]+ ]]; then
	docker push $1
fi

# Clean up
rm -Rf .dockpipe