#!/bin/bash
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

if [ -n "$used_pct" ]; then
  used_int=$(printf "%.0f" "$used_pct")
  bar_width=20
  filled=$(( used_int * bar_width / 100 ))
  empty=$(( bar_width - filled ))
  bar=""
  for ((i=0; i<filled; i++)); do bar="${bar}█"; done
  for ((i=0; i<empty; i++)); do bar="${bar}░"; done
  if [ "$used_int" -lt 50 ]; then color="\033[32m"
  elif [ "$used_int" -lt 75 ]; then color="\033[33m"
  else color="\033[31m"; fi
  printf "${color}%s\033[0m [%s] %d%%" "$model" "$bar" "$used_int"
else
  printf "%s" "$model"
fi
