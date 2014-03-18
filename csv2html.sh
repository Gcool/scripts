#!/bin/bash

NUMFIELDS=0
OUT=()
TLC=0

to_html() {
  local lc=0

  while IFS=',' read -r -a items; do
    (( ++lc ))
    OUT+=("\t<tr>\n")

    (( ${#items[@]} == 0 )) && continue

    (( NUMFIELDS == 0 )) && NUMFIELDS=${#items[@]}
    if (( NUMFIELDS != ${#items[@]} )); then
echo "error: Malformed CSV ($file: line $LC). Expected $NUMFIELDS fields, found ${#items[@]}." >&2
      exit 1
    fi

    for item in "${items[@]}"; do
OUT+=("\t\t<td>${item/==NULL==/}</td>\n")
    done

OUT+=("\t</tr>\n")

    (( TLC += lc ))

  done < <(sed 's/^,/==NULL==,/;
s/,,/,==NULL==,/g;
s/,$/,==NULL==/' <&6)
}

OUT+=("<table>\n")

if (( $# == 0 )); then
exec 6<&0
  to_html
else
for file; do
exec 6< "$file"
    to_html
    exec 6<&-
  done
fi

(( TLC > 0 )) && OUT+=("</table>\n")
