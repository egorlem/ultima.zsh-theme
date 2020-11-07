#!/bin/sh
# Display base term color scheme
function palettePrinter() {
  local acc=$(($1 - 1))
  local CSI="\x1b["
  local RST="${CSI}0m"
  local n=$acc
  local prefix="Term scheme:"

  if [ $acc -ne -1 ]; then
    echo "$prefix ${CSI}1;3${n}mnormal  ${RST}${CSI}4${n}m     ${RST}"
    echo "$prefix ${CSI}1;9${n}mbright  ${RST}${CSI}10${n}m     ${RST}"
    palettePrinter acc
  else
    return
  fi
}

palettePrinter 8
