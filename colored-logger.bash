#!/usr/bin/env bash

colored_logger() {
   local level
   local color
   local use_color
   local color_off='\x1B[0m'
   local context="(${0##*/})"
   local grey='\x1B[0;37m'

   (( $# == 0 )) && {
      echo 'colored_logger: expecting at least one argument' >&2
      return
   }

   [[ -t 1 ]] && use_color=1 # not in-a-pipe or file-redireciton

   case $1 in
      debug) level=0;;
       info) level=1;;
       warn) level=2;;
      error) level=3;;
   esac

   [[ -z $VERBOSE ]] && context=''

   [[ $level ]] && shift || level=0

   [[ $# -gt 0 ]] || {
      echo 'colored_logger: expecting a message' >&2
      return
   }

   case $level in
      0) color_off=;;
      1) color='\x1B[0;32m';; # Green
      2) color='\x1B[0;33m';; # Yellow
      3) color='\x1B[0;31m';; # Red
   esac

   [[ $level -gt 0 || $VERBOSE ]] && {
      [[ $use_color ]] && echo -e "${color}${*?}${color_off} ${grey}${context}${color_off}"
      [[ $use_color ]] || echo "${*?} ${context}"
   }

   return 0
}
export -f colored_logger

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  colored_logger "${@}"
fi
