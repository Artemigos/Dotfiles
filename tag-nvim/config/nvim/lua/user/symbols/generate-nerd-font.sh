#!/bin/bash

# Usage: ./generate-nerd-font.sh [nerd_fonts_repository_path]

NERD_FONTS_REPO=${1:?Path to nerd fonts repository required.}
GLYPHS_FILE=$NERD_FONTS_REPO/bin/scripts/lib/i_all.sh
if ! test -f "$GLYPHS_FILE"; then
    echo "the script $GLYPHS_FILE couldn't be found." >&2
    exit 1
fi

# shellcheck source=/dev/null
source "$GLYPHS_FILE"

set -euo pipefail

generate_entries() {
    for var in "${!i@}"; do
        local GLYPH_CHAR
        local GLYPH_NAME
        GLYPH_NAME=${var#*_}
        GLYPH_NAME=nf-${GLYPH_NAME/_/-}
        GLYPH_CHAR=${!var}
        echo "    ['$GLYPH_NAME'] = '$GLYPH_CHAR',"
    done
}

main() {
    echo "return {"
    generate_entries | LANG=C sort
    echo "}"
}

main
