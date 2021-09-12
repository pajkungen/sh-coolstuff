#!/bin/bash

# backup script for homefolder

if [ -z $1 ]; then
	user=$USER
else
	if [ ! -d "/home/$1" ]; then
		echo "Selected User or User's home-folder doesnt exist."
		exit 1
	fi
	user=$1
fi

input=/home/$USER/Dokument
output=/tmp/${USER}_home_$(date +%Y-%m-%d_%H%M%S).tar.gz

function total_files {
	find $1 -type f | wc -l
}

function total_directories {
	find $1 -type d | wc -l
}

function total_archived_directories {
	tar -tzf $1 | grep /$ | wc -l
}

function total_archived_files {
	tar -tzf $1 | grep -v /$ | wc -l
}

tar -czf $output $input 2> /dev/null

src_files=$( total_files $input )
src_directories=$( total_archived_directories $output )
arch_directories=$( total_archived_directories $output ) 
arch_files=$( total_archived_files $output )

echo "Your tar will include $src_files files and $src_directories directories. Filename:" 
ls -l $output 
echo "$arch_files files and $arch_directories are now archived."

if [ $src_files -eq $arch_files ]; then
	echo  "backup of $input complete!"
else
	echo "backup of $input failed!"
fi
