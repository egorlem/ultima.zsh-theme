#!/bin/sh
# Display base term color scheme
function termPalettePrinter() {
  local acc=$(($1 - 1))
  local CSI="\x1b["
  local n=$acc
  if [ $acc -ne -1 ]; then
    echo "Term scheme: ${CSI}${2}${n}m ${4}  ${CSI}0m${CSI}${3}${n}m     ${CSI}0m"
    termPalettePrinter acc $2 $3 $4
  else
    return
  fi
}
termPalettePrinter 8 3 4 normal
termPalettePrinter 8 9 10 bright

function fullPalettePrinter() {
  local acc=$(($1 - 1))
  local CSI="\x1b["
  local n=$acc
  if [ $acc -ne -1 ]; then
    echo "256 colors: ${CSI}${2}${n}m ${n} ${CSI}0m${CSI}${3}${n}m     ${CSI}0m"
    fullPalettePrinter acc $2 $3 $4
  else
    return
  fi
}
fullPalettePrinter 256 "38;05;" "48;05;"
