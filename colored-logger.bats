#!/usr/bin/env bats

load 'colored-logger'

levelKeywords=(debug info warn error)

@test 'log warns without arguments' {
   run colored_logger
   (( status == 0 ))
   (( ${#lines[@]} == 1 ))
   grep '^colored_logger: expecting at least one argument$' <<< "$output"
}

@test 'log warns when single argument is a level-keyword' {
   for level in "${levelKeywords[@]}"; do
      run colored_logger "$level"
      (( status == 0 ))
      (( ${#lines[@]} == 1 ))
      grep '^colored_logger: expecting a message$' <<< "${lines[0]}"
   done
}

@test 'log writes a message to stdout for non-debug messages' {
   for level in "${levelKeywords[@]}"; do
      [[ $level = 'debug' ]] && continue

      run colored_logger "$level" 'For the love of House'
      (( status == 0 ))
      grep 'For the love of House' <<< "${lines[0]}"
   done
}

@test 'log debug is default level and is silent by default' {
   run colored_logger 'I Chase Rivers'
   (( status == 0 ))
   [[ -z $output ]]

   run colored_logger debug 'I Chase Rivers'
   [[ -z $output ]]
}

@test 'log debug outputs when VERBOSE is true' {
   # shellcheck disable=SC2034
   VERBOSE=true

   run colored_logger 'I Chase Rivers'
   (( status == 0 ))
   [[ $output =~ 'I Chase Rivers' ]]

   run colored_logger debug 'I Chase Rivers'
   [[ $output =~ 'I Chase Rivers' ]]
}

@test 'log handles barewords' {
   for level in "${levelKeywords[@]}"; do
      # shellcheck disable=SC2034
      VERBOSE=true
      run colored_logger "$level" Something Good Can Work Remix
      (( status == 0 ))
      [[ $output =~ 'Something Good Can Work Remix' ]]
   done
}
