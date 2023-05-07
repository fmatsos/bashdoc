#!/usr/bin/env bash

#/ @file Converts comments from a Bash script using JSDoc to documentation.
#/ 
#/ @author Franck MATSOS
#/ @licence GPL-3.0-or-later
#/ @version 1.0
#/
#/ @example ./bashdoc.sh bashdoc.sh

declare -r YELLOW='\033[1;33m'
declare -r GREEN='\033[1;32m'
declare -r RED='\033[1;31m'
declare -r RESET='\033[0m'

# Variables
declare -r temp_dir="$(mktemp -d)"
declare html=true
declare markdown=false
declare indicator="#/ "
declare file=""
declare output_file=""
declare buffer=""
declare output_name=""

#/ Output colored text
#/ @param {string} color The color to use
#/ @param {string} text The text to output
ctext() {
  local color="$1"
  echo -e "${color}$2${RESET}"
}

#/ Output text in yellow
#/ @param {string} text The text to output
yellow() {
  ctext "$YELLOW" "$1"
}

#/ Output text in green
#/ @param {string} text The text to output
green() {
  ctext "$GREEN" "$1"
}

#/ Output text in red
#/ @param {string} text The text to output
red() {
  ctext "$RED" "$1"
}

#/ Write a string to a file
#/ @param {string} text The string to write
#/ @param {string} file The file to write to
write() {
  echo "$1" >> "$2"
}

#/ Write a newline to a file
#/ @param {string} file The file to write to
writeln() {
  echo "" >> "$1"
}

#/ Write a function header comment block to a file
#/ @param {string} file The file to write to
#/ @param {string} comment The comment block to write
write_comment_block() {
  if [ "$2" != "" ]; then
    echo "/**" >> "$1"
    # Exclude lines that match one of the following patterns:
    # - Start with zero or more spaces followed by zero or one asterisks followed by two or more dashes and zero or more spaces
    # - Start with zero or more spaces followed by zero or one asterisks and zero or more spaces
    # Then, remove any lines that contain only spaces or asterisks
    # Finally, remove any leading spaces
    echo -e "$2" | grep -vE '^\s*\*?\s*-{2,}\s*$' | sed -e '/^ *$/!b' -e '/^ *\*/!d' -e 's/^[[:blank:]]*//' >> "$1"
    echo " */" >> "$1"
  fi
}

#/ Clean up the temporary directory using trap
cleand () {  
  trap 'rm -rf "\${temp_dir}"' EXIT ${1:-0}
}

#/ Install a package if it is not installed
#/ @param {string} packageName The package to install
#/ @param {string} command The command of package
install_package() {
  if ! command -v $2 &> /dev/null; then
    yellow "$1 not found. Installing..."
    if ! command -v npm &> /dev/null; then
      red "npm not found. Please install Node.js and npm first."
      cleand 1
    fi
    npm install -g $1
    green "$1 installed successfully."
  else  
    green "$1 is already installed. Continue..."
  fi
}

# Parse command line options
while [[ $# -gt 0 ]]; do
  case $1 in
    -m|--markdown) # Export documentation to Markdown
      markdown=true
      html=false
      shift
      ;;
    -h|--html) # Export documentation to HTML with JSDoc
      markdown=false
      html=true
      shift
      ;;
    -c|--comment-indicator) # Specify comment block indicator in input file
      indicator="$2"
      shift 2
      ;;
    -o|--output-file) # Specify output filename for Markdown export
      output_name="$2"
      shift 2
      ;;
    -*) # Invalid option
      red "Invalid option: $1" >&2
      red "Try 'bashdoc --help' for more information." >&2
      cleand 1
      ;;
    *) # Input file provided
      file="$1"
      break
      ;;
  esac
done

# Check if the input file exists
if [ ! -f "$file" ]; then
  red "Input file not found: $1"
  cleand 1
fi

# Initialize output file
output_file="${temp_dir}/${file}.js"
: > "$output_file"

green "Converting comments to documentation..."

# Extract comments and function signatures from the script file
while IFS= read -r line; do
  if [[ $line =~ ^#\/ ]]; then
    # Add the comment line to the buffer
    buffer+=" * ${line:2}\n"
  elif [[ $line =~ ^[[:alnum:]_-]+[[:space:]]*\(\) ]]; then
    # If the line matches the pattern for a function signature, write the comment block and function signature to the output file
    write_comment_block "$output_file" "$buffer"
    write "function ${line%%\{*} {}" "$output_file"
    writeln "$output_file"
    buffer=""
  fi
done < "$file"

if [ "$html" = true ]; then
  install_package "jsdoc" "jsdoc"
  jsdoc -r "${temp_dir}" -c <(echo '{
    "templates": {
      "default": {
        "outputSourceFiles": false
      }
    }
  }')
fi

if [ "$markdown" = true ]; then
  install_package "jsdoc-to-markdown" "jsdoc2md"
  
  if [ "$output_name" = "" ]; then
    jsdoc2md "${output_file}" > "${file}.md"
  else
    jsdoc2md "${output_file}" > "$output_name"
  fi
fi

green "Documentation converted successfully."

cleand