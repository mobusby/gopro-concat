#!/bin/sh

usage() {
	echo "$0 Series"
	echo "where \"Series\" is the 4-digit identifier of the series of videos to combine"
	echo "eg: \"$0 1234\" will combine all the files with names \"GHXX1234.MP4\""
	echo "Note that this command must be run from the directory containing the files to"
	echo "combine."
	echo ""
	echo "Based on instructions found here:"
	echo "<https://gopro.github.io/labs/control/chapters/>"
	exit
}

if [ ! $# = 1 ]; then 
	echo "I'm confused, what do you want me to do? \"\$# = $#\""
	echo ""
	usage
fi

firstFile="GH01$1.MP4"

if [ ! -f "$firstFile" ]; then
	echo "Invalid argument: $firstFile does not exist"
	echo ""
	usage
fi

secondFile="GH02$1.MP4"

if [ ! -f "$secondFile" ]; then
	echo "Nothing to do, no second file: \$secondFile=$secondFile"
	echo ""
	usage
fi

mkdir -p $HOME/.local/temp/gopro-concat

listFile=$1.list

if [ -f "$listFile" ]; then
	rm "$listFile"
fi

echo "Creating \$listFile = $listFile"
for file in GH*$1.MP4; do 
	echo file \'$file\' >> "$listFile"
done

cat "$listFile"

combinedFile=GH00$1.MP4

echo "ffmpeg -y -f concat -i \"$listFile\" -c copy -map 0:0 -map 0:1 -map 0:3 \"$combinedFile\""

ffmpeg -y -f concat -i "$listFile" -c copy -map 0:0 -map 0:1 -map 0:3 "$combinedFile"
udtacopy "$firstFile" "$combinedFile"

rm $listFile

echo "Done!"

