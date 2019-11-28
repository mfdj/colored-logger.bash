#!/usr/bin/env bats

load 'colored-logger'

levelKeywords=(debug info warn error)

@test 'colored-logger warns without arguments' {
   run colored-logger
   (( status == 0 ))
   (( ${#lines[@]} == 1 ))
   grep '^colored-logger: expecting at least one argument$' <<< "$output"
}

@test 'colored-logger warns when single argument is a level-keyword' {
   for level in "${levelKeywords[@]}"; do
      run colored-logger "$level"
      (( status == 0 ))
      (( ${#lines[@]} == 1 ))
      grep '^colored-logger: expecting a message$' <<< "${lines[0]}"
   done
}

@test 'colored-logger writes a message to stdout for non-debug messages' {
   for level in "${levelKeywords[@]}"; do
      [[ $level = 'debug' ]] && continue

      run colored-logger "$level" 'For the love of House'
      (( status == 0 ))
      grep 'For the love of House' <<< "${lines[0]}"
   done
}

@test 'colored-logger debug is default level and is silent by default' {
   run colored-logger 'I Chase Rivers'
   (( status == 0 ))
   [[ -z $output ]]

   run colored-logger debug 'I Chase Rivers'
   [[ -z $output ]]
}

@test 'colored-logger debug outputs when VERBOSE is true' {
   # shellcheck disable=SC2034
   VERBOSE=true

   run colored-logger 'I Chase Rivers'
   (( status == 0 ))
   [[ $output =~ 'I Chase Rivers' ]]

   run colored-logger debug 'I Chase Rivers'
   [[ $output =~ 'I Chase Rivers' ]]
}

@test 'colored-logger handles barewords' {
   for level in "${levelKeywords[@]}"; do
      # shellcheck disable=SC2034
      VERBOSE=true
      run colored-logger "$level" Something Good Can Work Remix
      (( status == 0 ))
      [[ $output =~ 'Something Good Can Work Remix' ]]
   done
}
