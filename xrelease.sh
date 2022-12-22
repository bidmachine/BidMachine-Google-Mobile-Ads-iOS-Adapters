#!/bin/sh

# ----------------------------------
# ENVIROMENT VARIABLES
# ----------------------------------
export ERROR='\033[0;31m'   # Red color
export INFO='\033[0m'       # Standart color
export WARNING='\033[0;33m' # Orange color

SPEC="BidMachineAdMobAdapter"
PODSPEC="./$SPEC.podspec"
ADAPTER_VER=""
SDK_VER=""
VER=""
TAG=""
NOTE=""
CREATE_TAG=NO
REPO_PUSH=NO
TRUNK_PUSH=NO

# ----------------------------------
# CONSOLE IO
# ----------------------------------

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo "[options][arguments]"
      echo " "
      echo "options:"
      echo "-h,  --help                                       Show brief help"
      echo "-t,  --tag                                        Creaate tag version of build. ${WARNING}Default = NO${INFO}"
      echo "-rp, --repo_push                                  Update CocoaPods appodeal repo. ${WARNING}Default = NO${INFO}"
      echo "-tp, --trunk_push                                 Update CocoaPods public repo. ${WARNING}Default = NO${INFO}"
      exit 0
      ;;
    -t|--tag)
      CREATE_TAG=$2
      shift # past argument
      shift # past value
      ;;
    -rp|--repo_push)
      REPO_PUSH=$2
      shift # past argument
      shift # past value
      ;;
    -tp|--trunk_push)
      TRUNK_PUSH=$2
      shift # past argument
      shift # past value
      ;;
    -*|--*)
      echo "${ERROR} ❌ Unknown option $1${INFO}"
      exit 1
      ;;
    *)
      break
      ;;
  esac
done

# ----------------------------------
# METHODS
# ----------------------------------

function parseVersion {
  while read line; do
    if [[ "$line" == *"sdkPath"* && $line =~ [0-9]+\.[0-9]+\.[0-9] ]]; then 
        SDK_VER=${BASH_REMATCH[0]}
    elif [[ "$line" == *"adapterPath"* && $line =~ [0-9]+ ]]; then
        ADAPTER_VER=${BASH_REMATCH[0]}
    fi
  done < $PODSPEC

  VER="$SDK_VER.$ADAPTER_VER"
  TAG="v$SPEC-$VER"

  if [[ $VER == "." ]]; then
    echo "${ERROR} ❌ Can't parse version from $SPEC${INFO}"
    exit 0
  fi
}

function parseNotes {
  while read line; do
    if [[ "$line" == *"##"* ]]; then 
      if [[ "$line" == *"$VER"* ]]; then
        NOTE+="$line"
      else
        break
      fi
    else
      if [[ $NOTE != "" ]]; then
        NOTE+="\n $line"
      fi
    fi
  done < "./release/CHANGELOG.md"

  if [[ $NOTE == "" ]]; then
    echo "${ERROR} ❌ Can't parse notes${INFO}"
    exit 0
  fi
}


function upload {
    echo "🌎 Upload"
    name="$SPEC.zip"
    aws s3 cp "$(PWD)/release/$name" "s3://appodeal-ios/BidMachineAdaptors/$SPEC/$VER/$name" --acl public-read
}

function createRelease {
  PATH_NOTE="./NOTE.md"
  NOTE+=" \n - [XCFramework](https://s3-us-west-1.amazonaws.com/appodeal-ios/BidMachineAdaptors/${SPEC}/${VER}/${SPEC}.zip)"
  echo "$NOTE" > "$PATH_NOTE"
  echo "$(tail -n +2 "$PATH_NOTE")" > "$PATH_NOTE"

  gh release delete $TAG -y

  git tag -d $TAG
  git push origin --delete $TAG
  git tag -a $TAG -m "$TAG"
  git push origin $TAG

  gh release create $TAG -F "./NOTE.md"
}

# ----------------------------------
# EXECUTION
# ----------------------------------

parseVersion
parseNotes

echo "🔨 Release configuration:"
echo "Spec name:         ${WARNING}${SPEC}${INFO}"
echo "Spec version:      ${WARNING}${VER}${INFO}"
echo "Git tag:           ${WARNING}${TAG}${INFO}"
echo " "
echo "Repo push          ${WARNING}${REPO_PUSH}${INFO}"
echo "Trunk push         ${WARNING}${TRUNK_PUSH}${INFO}"
echo "Create git tag:    ${WARNING}${CREATE_TAG}${INFO}"

[ "$REPO_PUSH" = "YES" ] && upload && pod repo push appodeal "$SPEC.podspec" --allow-warnings
[ "$TRUNK_PUSH" = "YES" ] && pod trunk push "$SPEC.podspec" --allow-warnings
[ "$CREATE_TAG" = "YES" ] && createRelease