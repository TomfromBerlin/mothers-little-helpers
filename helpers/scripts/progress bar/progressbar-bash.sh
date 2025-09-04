#!/usr/bin/env bash
BATCHSIZE=2
# ---------------------------------------------
# Pac‑Man‑Style Progress Bar
# ---------------------------------------------
set -u
# -------------------------------------------------
# progress-bar <current> <len>
# -------------------------------------------------
fatal() {
    echo '[FATAL]' "$@" >&2
    exit 1
}

progress-bar() {
  local current=$1
  local len=$2
  local GREEN=$'\e[0;32;40m'
  local BROWN=$'\e[0;33;40m'
  local YELLOW=$'\e[1;33;40m'
  local RED=$'\e[0;31;40m'
  local NC=$'\e[0m'                # reset color
  local pm_char1="${YELLOW}C${NC}"
  local pm_char2="${YELLOW}c${NC}"
  local bar_char1="${BROWN}..${NC}"
  local bar_char2="${GREEN}o ${NC}"    # · $'\u00B7'
  local bar_char3=' '
  local length=25
  local perc_done=$((current * 100 / len))
  local num_bars=$((perc_done * length / 100))
  local pos=$((num_bars - 1))
  (( pos < 0 )) && pos=0

  local perc_color
    if (( perc_done < 31 )); then
        perc_color=${RED}
    elif (( perc_done < 61 )); then
        perc_color=${YELLOW}
    else
        perc_color=${GREEN}
    fi
# progress bar
    local i bar='['
    for ((i=0; i<length; i++)); do
      if (( i < pos )); then
          bar+=$bar_char1 # behind Pac-Man
      elif (( i == pos && perc_done < 100 )); then
      # Pac-Man
          (( i % 2 == 0 )) && bar+=$pm_char1 || bar+=$pm_char2
      else
          bar+=$bar_char2 # && $bar_char3 # in front of Pac-Man
      fi
    done
  bar+=']'

      printf '\e[s' # save the cursor position
        printf '\e[%d;%dH' "$LINES" 0 # move cursor to bottom line
          printf '\r%s\t%s/%s\t%s%s%%%s' "$bar" "$current" "$len" "$perc_color" "$perc_done" "$NC"
        printf '\e[K' #  clear the line
      printf '\e[u' #  restores the cursor to the last saved position
}

# we define a function because we do not want to break existing color definitions
batchsize () {
  local GREEN=$'\e[0;32;40m'
  local RED=$'\e[0;31;40m'
  local NC=$'\e[0m'

  if
    [[ $BATCHSIZE -lt 1 ]] ; then
      printf '\n%s%s%s\n%s\n\n' "BATCHSIZE must be greater than "${RED} ${BATCHSIZE} ${NC}"." "BATCHSIZE is set to 1." && BATCHSIZE=1 && printf '%s%s\n\n' "Processing "${GREEN}${BATCHSIZE}${NC}" file at a time"
    elif [[ $BATCHSIZE == 1 ]] ; then printf '%s%s\n\n' "Processing "${GREEN}${BATCHSIZE}${NC}" file at a time"
    else
      printf '\n%s\n\n' "Processing batch of "${GREEN}${BATCHSIZE}${NC}" files"
  fi
}
# initialise terminal
init-term() {
    printf '\n' # ensure we have space for the progress bar
      printf '\e[s' # save the cursor location
        printf '\e[%d;%dr' 0 "$((LINES -1))" # set the scrollable region (margin)
      printf '\e[u' #  restore the cursor location
    printf '\e[1A' # move cursor up
    tput civis
}

deinit-term() {
    printf '\e[s' # save the cursor location
      printf '\e[%d;%dr' 0 "$LINES" # reset the scrollable region (margin)
      printf '\e[%d;%dH' "$LINES" 0 # move cursor to bottom line
      printf '\e[0K' #  clear the line
    printf '\e[u' #  reset the cursor location
    tput cnorm
}
# ---------------------------------------------
main() {
# ---------------------------------------------
    local OPTARG OPTIND opt
    while getopts 'b:' opt; do
          case "$opt" in
                  b) BATCHSIZE=$OPTARG;;
                  *) fatal 'bad option';;
          esac
    done

    shopt -s globstar nullglob checkwinsize
    (:) # this line is to ensure LINES and COLUMNS ar set

    trap deinit-term exit
    init-term

    printf '\nSearching files…'
    local files=(./**/*.*)                 # Array with all files
    local len=${#files[@]}
    printf '\rFound '$len' files\n'

    batchsize

    for ((i=0; i < len; i += BATCHSIZE)); do
      progress-bar "$((i+1))" "$len"
    done

    # Completing the progress bar regardless of the size of the BATCHSIZE variable
    progress-bar "$len" "$len"

}

main "$@"
printf '\n\nDone!\n'
