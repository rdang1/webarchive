#!/usr/bin/env fish

set -l URL $argv[1]
set -l DIR (pwd)/saved

set -l SCRIPT_DIR (dirname (realpath (status --current-filename)))
set -l SCRUB_SCRIPT_PATH "$SCRIPT_DIR/scrub.py"

set -g TEMP_DIR (mktemp -d)

function cleanup --on-event fish_exit
  rm -rf $TEMP_DIR
end

cd $TEMP_DIR

set -l TEMP_HTML (wget -p -k -E --no-parent --reject="*.js" $URL 2>&1 | awk -F"['‘']|['’']" '/Saving to:/ {print $2}' | head -n 1)
set -l TEMP_HTML_PATH "$TEMP_DIR/$TEMP_HTML"

python3 "$SCRUB_SCRIPT_PATH" "$TEMP_HTML_PATH"

if test -z "$argv[2]"
    set -g FILENAME (
      echo "$TEMP_HTML" | string replace -r '^(https?://)' '' |
      string replace -a '/' '_' |
      string replace -r '[\\?*:\"<>|&]' '-' |
      string replace -r '[-_]{2,}' '-'
    )
else
    set -g FILENAME "$argv[2]"
end

monolith "$TEMP_HTML_PATH" > "$DIR/$FILENAME" 2> /dev/null
