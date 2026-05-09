#!/usr/bin/env bash

if [ -n "$1" ]; then
    hex="$1"
else
    COLOR_FILE="$HOME/.config/matugen/files/files.txt"
    hex=$(cat "$COLOR_FILE" 2>/dev/null || echo "#89B4FA")
fi

declare -A colors=(
  [cat-mocha-blue]="#89B4FA"
  [cat-mocha-flamingo]="#F2CDCD"
  [cat-mocha-green]="#A6E3A1"
  [cat-mocha-lavender]="#B4BEFE"
  [cat-mocha-maroon]="#EBA0AC"
  [cat-mocha-mauve]="#CBA6F7"
  [cat-mocha-peach]="#FAB387"
  [cat-mocha-pink]="#F5C2E7"
  [cat-mocha-red]="#F38BA8"
  [cat-mocha-rosewater]="#F5E0DC"
  [cat-mocha-sapphire]="#74C7EC"
  [cat-mocha-sky]="#89DCEB"
  [cat-mocha-teal]="#94E2D5"
  [cat-mocha-yellow]="#F9E2AF"
)

hex_to_rgb() {
  local h=${1#"#"}
  echo $((16#${h:0:2})) $((16#${h:2:2})) $((16#${h:4:2}))
}

read r1 g1 b1 <<< "$(hex_to_rgb "$hex")"

min_distance=1000000
closest_color=""

for name in "${!colors[@]}"; do
  read r2 g2 b2 <<< "$(hex_to_rgb "${colors[$name]}")"
  distance=$(( (r1 - r2)**2 + (g1 - g2)**2 + (b1 - b2)**2 ))
  if (( distance < min_distance )); then
    min_distance=$distance
    closest_color=$name
  fi
done

case "$closest_color" in
    "cat-mocha-lavender"|"cat-mocha-mauve"|"cat-mocha-pink") p_color="violet" ;;
    "cat-mocha-blue"|"cat-mocha-sapphire"|"cat-mocha-sky") p_color="blue" ;;
    "cat-mocha-teal") p_color="teal" ;;
    "cat-mocha-green") p_color="green" ;;
    "cat-mocha-yellow") p_color="yellow" ;;
    "cat-mocha-peach"|"cat-mocha-maroon") p_color="orange" ;;
    "cat-mocha-red") p_color="red" ;;
    "cat-mocha-flamingo"|"cat-mocha-rosewater") p_color="grey" ;;
    *) p_color="blue" ;;
esac

papirus-folders -t Papirus-Dark -C "$p_color" --once
