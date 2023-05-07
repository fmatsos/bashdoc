# Bashdoc

Bashdoc is a Bash script that converts comments in a Bash script using JSDoc syntax to documentation. The script can export documentation to Markdown or HTML using JSDoc.

## Prerequisites

You need to have Node.js installed with [jsdoc](https://github.com/jsdoc/jsdoc) and [jsdoc-to-markdown](https://github.com/jsdoc2md/jsdoc-to-markdown) packages installed globally:
```sh
  npm install -g jsdoc jsdoc-to-markdown`
```

Bashdoc will install npm packages for you if necessary. But always required to have Node.js with npm installed.

## Installation

To install Bashdoc, download the script from this repository and save it to a directory in your `$PATH`. For example, to install Bashdoc in `/usr/local/bin`, run:

```sh
  sudo curl -L "https://github.com/fmatsos/bashdoc/raw/main/bashdoc.sh" -o /usr/local/bin/bashdoc && sudo chmod +x /usr/local/bin/bashdoc`
```

```sh
  sudo wget "https://github.com/fmatsos/bashdoc/raw/main/bashdoc.sh" -O /usr/local/bin/bashdoc && sudo chmod +x /usr/local/bin/bashdoc
```

Alternatively, you can download the script and make it executable manually:

```sh
  curl -O "https://github.com/fmatsos/bashdoc/raw/main/bashdoc.sh"
  chmod +x bashdoc.sh
```

```sh
  wget "https://github.com/fmatsos/bashdoc/raw/main/bashdoc.sh"
  chmod +x bashdoc.sh
```

## Usage

To use Bashdoc, run the script with the path to the Bash script you want to document as an argument. For example:

```sh
  bashdoc myscript.sh
```

This will output documentation in HTML format to a file named `myscript.html` in the same directory as the input file.

_Note that `bashdoc` is self documentable if you want to test generation._

### Export to markdown

By default, Bashdoc exports documentation to HTML using JSDoc. To export documentation to Markdown instead, use the `-m` or `--markdown` option:

```sh
  bashdoc -m myscript.sh
```

This will output documentation in Markdown format to a file named `myscript.sh.md` in the same directory as the input file.


### Specify output name

You can specify an output file name using the `-o` or `--output-file` option:

```sh
  bashdoc -m -o documentation.md myscript.sh
```

This will output documentation in Markdown format to a file named `documentation.md` in the same directory as the input file.


### Change comment block indicator

By default, Bashdoc uses the `#/ ` comment block indicator to identify JSDoc-style comment blocks. You can specify a different comment block indicator using the `-c` or `--comment-indicator` option:

```sh
  bashdoc -c "## " myscript.sh
```

This will use the `## ` comment block indicator to identify JSDoc-style comment blocks.

### Show help

For more information on how to use Bashdoc, run:

```sh
  bashdoc --help
```