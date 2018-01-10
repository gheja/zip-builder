#!/bin/bash

_usage_and_exit()
{
	echo "Usage:"
	echo "  $0 <source directory> <target directory> [project name] [project version]"
	echo ""
	echo "Project name and version is optional, default values are \"unnamed\" and \"0.1.0\"."
	echo ""
	echo "Examples:"
	echo "  $0 src dist"
	echo "  $0 src dist test-project 0.9.3"
	exit 1
}

if [ $# -lt 2 ] || [ $# -gt 4 ]; then
	_usage_and_exit
fi

PROG=`readlink -f "$0"`
ROOT_DIR=`dirname "$PROG"`

# override HOME to avoid trashing user's home
export HOME="$ROOT_DIR"

SOURCE_DIR=`readlink -f "$1" 2>/dev/null`
TARGET_DIR=`readlink -f "$2" 2>/dev/null`
PROJECT_NAME="$3"
PROJECT_VERSION="$4"

if [ "$SOURCE_DIR" == "" ]; then
	echo "ERROR: invalid source directory, exiting."
	exit 1
fi

if [ "$TARGET_DIR" == "" ]; then
	echo "ERROR: invalid target directory, exiting."
	exit 1
fi

if [ "$PROJECT_NAME" == "" ]; then
	PROJECT_NAME="unnamed"
fi

if [ "$PROJECT_VERSION" == "" ]; then
	PROJECT_VERSION="0.1.0"
fi


cd "$SOURCE_DIR"

target="${TARGET_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}.zip"

i=0
while [ -e "$target" ]; do
	i=$((i + 1))
	target="${TARGET_DIR}/${PROJECT_NAME}-${PROJECT_VERSION}-${i}.zip"
done

zip -r9 "$target" .

cd "$TARGET_DIR"

ls -alh

exit 0
