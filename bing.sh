#!/bin/bash
#echo "Shell args's num = $#\n"

# ================================== Define vars ==================================
#platform=`uname -a | awk '{print $1}'`
platform=`uname -s`
dir=/Users/$(whoami)/Pictures/Bing

# ================================== Judging platform ==================================
if [[ $platform =~ "Darwin" ]]; then
  printf "\n\n=================== Your machine is running on MacOS ==================="
  platform=1
elif [[ $platform =~ "Linux" ]]; then
  printf "\n\n=================== Your machine is runing on Linux ==================="
  platform=0;
fi
printf "\n\n"

# ================================== Insure relies ==================================
if [[ ! -e /usr/bin/wget && ! -e /usr/local/bin/wget ]]; then
  printf "\n\nYour machine has not wget, you need to install~ \n\t\t\t\t\t\t\tyes or no?\n"
  read -n 3 -p "Your choice:  " answer; echo
  if [[ "$answer" == "yes" ]]; then
    if [ ! -e /usr/local/bin/brew -o $platform -eq 1 ]; then
      echo Install brew~
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
      brew install wget
    elif [ $platform -eq 0 ]; then
      sudo apt-get install wget
      if [ ! -e /usr/bin/wget -o -e /usr/local/bin/wget ]; then
        echo Install wget failed~
        exit 0
      fi
    else
      echo "Only support for MacOS and Debian series Linux~"
      exit 0
    fi
  else
    echo Sorry to say that you lost courage~
    exit 0
  fi
else
  printf "\n\nThis shell is going to use wget~\n"
fi
# ================================== Bing dir ==================================
if [ $platform -eq 1 ]; then
  dir=/Users/$(whoami)/Pictures/Bing
else
  dir=/home/$(whoami)/Bing
fi
if [ ! -d $dir ]; then mkdir -p $dir; fi
# ================================== Do it! ==================================
if [ $# -ne 0 ]; then
  if [[ !("$1"x == "all"x) ]]; then
    if [ $1 -eq 0 ]; then
      echo "Install necessary relies~"
      sudo easy_install pip
      sudo pip install requests
    elif [ $1 -eq 1 ]; then
      echo "Download jpg you want(daysAgo=$2)~"
      wget -c http://area.sinaapp.com/bingImg?daysAgo=$2
        if [ $2 -ge 0 ]; then
          if [ $platform -eq 1 ]; then
            file_name=$(date -v  -$2\d +"%Y%m%d").jpg
          else
            file_name=$(date +"%Y%m%d" --date=-''$2' day').jpg
          fi
        else
          if [ $platform -eq 1 ]; then nu=$2;mu=-1;let nu=nu*mu;
            file_name=$(date -v  +$nu\d +"%Y%m%d").jpg
          else
            file_name=$(date +"%Y%m%d" --date=''$nu' day').jpg
          fi
        fi
      mv bingImg?daysAgo=$2 $dir/$file_name
    else
      echo "what the fuck?"
    fi
  else
    echo "Download all jpg we can~"
    for day in $(seq -1 6)
    do
      echo
      wget -c http://area.sinaapp.com/bingImg?daysAgo=$day
      day=$((~$(($day-1))))
        if [ $day -ge 0 ]; then
          if [ $platform -eq 1 ]; then
            file_name=$(date -v  +$day\d +"%Y%m%d").jpg
          else
            file_name=$(date +"%Y%m%d" --date=''$day' day').jpg
          fi
        else
          if [ $platform -eq 1 ]; then
            file_name=$(date -v  $day\d +"%Y%m%d").jpg
          else
            file_name=$(date +"%Y%m%d" --date=''$day' day').jpg
          fi
        fi
      day=$(($((~$day))+1))
      mv bingImg?daysAgo=$day $dir/$file_name
    done
  fi
else
  echo "Download jpg today~"
  wget -c http://area.sinaapp.com/bingImg?daysAgo=0
  file_name=$(date +"%Y%m%d").jpg
  mv bingImg?daysAgo=0 $dir/$file_name
fi

# ================================== Show it! ==================================
printf "\nAll image from bing:\n\n"
ls -al $dir/ | grep jpg
printf "\n\t\t\t\t\t\t\t\t Enjoy it~\n"

# ================================== Something bak ==================================
:<<!EOF!
dep_wget=`wget --help`
dep_pip=`pip -h`
dep_curl=`curl --help`
sudo easy_install pip
sudo pip install requests
file_name=$(date +"%Y%m%d").jpg
python ./0-bing.py
mv *.jpg /Users/$(whoami)/Pictures/Bing/
!EOF!
