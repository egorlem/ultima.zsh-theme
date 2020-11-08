#!/bin/sh
# Display base term color scheme
function palettePrinter() {
  local acc=$(($1 - 1))
  local CSI="\x1b["
  local n=$acc
  if [ $acc -ne -1 ]; then
    echo "Term scheme: ${CSI}${2}${n}m ${4}  ${CSI}0m${CSI}${3}${n}m     ${CSI}0m"
    palettePrinter acc $2 $3 $4
  else
    return
  fi
}
palettePrinter 8 3 4 normal
palettePrinter 8 9 10 bright
