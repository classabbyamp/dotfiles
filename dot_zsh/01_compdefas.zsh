compdefas () {
  if (($+_comps[$1])); then
    compdef $_comps[$1] ${^@[2,-1]}=$1
  fi
}

