#!/usr/bin/env bash
BATCHSIZE=500
# ---------------------------------------------
# Pac‑Man‑Style Progress Bar
# ---------------------------------------------
set -u

help() {
  local GREEN=$'\e[0;32;40m'
  local BLUE=$'\e[0;34;40m'
  local NC=$'\e[0m'   # reset color

  echo
  echo -en " Usage: progressbar.sh ${GREEN}-b ${BLUE}[positive integer]${NC}  - How many files should be processed at a time\n"
  echo
  exit 1
}

progress-bar() {
  local current=$1
  local len=$2
  local COLUMNS=$(tput cols)
  local LINES=$(tput lines)

  local GREEN=$'\e[0;32;40m'
  local BROWN=$'\e[0;33;40m'
  local YELLOW=$'\e[1;33;40m'
  local RED=$'\e[0;31;40m'
  local NC=$'\e[0m'   # reset color

  local pm_char1="${YELLOW}C${NC}"    # this is one of two characters for the animation
  local pm_char2="${YELLOW}c${NC}"    # this is the second character for the animation
  local bar_char1="${BROWN}.${NC}"    # this character apears behind Pac-Man
  local bar_char2="${GREEN}o${NC}"    # this character is eaten by Pac-Man
#  local bar_char2="${GREEN}$·${NC}"    # you can also try middle-dot
#  local bar_char2="${GREEN}$( printf $'\u00B7' )${NC}"    # with UTF-8 code -> ·

  local perc_done=$((current * 100 / len))

  local suffix
        suffix=$(printf ' %d / %d (%d%%)' "$current" "$len" "$perc_done")
  local length=$(( COLUMNS - 2 - ${#suffix} ))
     (( length < 0 )) && length=0

  local num_bars=$(( perc_done * length / 100 ))

  local pos=$((num_bars - 1))
     (( pos < 0 )) && pos=0

  local perc_color
    if (( perc_done < 34 )); then
          perc_color=${RED}
    elif (( perc_done < 67 )); then
          perc_color=${YELLOW}
    else
          perc_color=${GREEN}
    fi
# progress bar
    local i bar='['
    for ((i = 0; i < length; i++)); do
      if (( i < pos )); then
          bar+=$bar_char1 # behind Pac-Man
      elif (( i == pos && perc_done < 100 )); then
      # Pac-Man
          (( i % 3 == 0 )) && bar+=$pm_char1 || bar+=$pm_char2
      else
          bar+=$bar_char2 # in front of Pac-Man
      fi
    done
  bar+=']'
    printf '\e[s'                    # save cursor
      printf '\e[%d;1H' "$LINES"       # -> bottom row, first column  (1-based!)
        printf '%s %s/%s %s%s%%%s' "$bar" "$current" "$len" "$perc_color" "$perc_done" "$NC"
      printf '\e[K'                    # clear the line
    printf '\e[u'                    # set cursor back
}

# we define a function because we do not want to break existing color definitions
batchsize () {
    local GREEN=$'\e[0;32;40m'
    local RED=$'\e[0;31;40m'
    local NC=$'\e[0m'

    if
      [[ $BATCHSIZE -lt 1 ]] ; then
        printf '\n%s%s%s\n%s\n\n' "BATCHSIZE must be greater than "${RED} ${BATCHSIZE} ${NC}"." "BATCHSIZE is set to 1." && BATCHSIZE=1 && printf '%s%s\n\n' "Processing "${GREEN}${BATCHSIZE}${NC}" file at a time"
      elif
        [[ $BATCHSIZE == 1 ]] ; then printf '%s%s\n\n' "Processing "${GREEN}${BATCHSIZE}${NC}" file at a time"
      else
        printf '\n%s\n\n' "Processing batch of "${GREEN}${BATCHSIZE}${NC}" files"
    fi
}

process-files() {
    local files=("$@")

    local file
    for file in "${files[@]}"; do
#   you can add your code here, i.e., 'cp $file /dev/null'
        printf '%s\n' "-> $file"
    done
#	sleep .1
}

# initialise terminal
init-term() {
    local COLUMNS=$(tput cols)
    local LINES=$(tput lines)

    printf '\n' # ensure we have space for the progress bar
      printf '\e[s' # save the cursor location
        printf '\e[%d;%dr' 1 "$((LINES -1))" # set the scrollable region (margin)
      printf '\e[u' #  restore the cursor location
    printf '\e[1A' # move cursor up
    tput civis # make the cursor invisible
}

deinit-term() {
    local COLUMNS=$(tput cols)
    local LINES=$(tput lines)

    printf '\e[s' # save the cursor location
      printf '\e[%d;%dr' 1 "$LINES" # reset the scrollable region (margin)
      printf '\e[%d;%dH' "$LINES" 1 # move cursor to bottom line
      printf '\e[0K' #  clear the line
    printf '\e[u' #  reset the cursor location
    tput cnorm # make the cursor visible
}

main() {
    local OPTARG OPTIND opt
    while getopts 'b:' opt; do
          case "$opt" in
                  b) BATCHSIZE=$OPTARG;;
                  *) help;;
          esac
    done

    shopt -s globstar nullglob # (add 'dotglob' if you want to include dot-files)

    local COLUMNS=$(tput cols) # determine the number of columns of the terminal window
    local LINES=$(tput lines)  # determine the number of lines of the terminal window

    trap deinit-term EXIT
    trap init-term winch
    init-term

    printf '\nSearching files…'
      local files=(./**/*.*)                 # Array with all regular files, change this to (./**/*) to include really all files (be careful what you do!)
    local len=${#files[@]}
      printf '\rFound '$len' files\n'

    batchsize
    local i
    for ((i=0; i < len; i += BATCHSIZE)); do
      progress-bar "$((i+1))" "$len"
      process-files "${files[@]:i:BATCHSIZE}"
    done

    # Completing the progress bar regardless of the size of the BATCHSIZE variable
    progress-bar "$len" "$len"

}

main "$@"
GREEN=$'\e[0;32;40m'
NC=$'\e[0m'
printf '%s\n' ${GREEN}"Done!"${NC} && GREEN= && NC=
