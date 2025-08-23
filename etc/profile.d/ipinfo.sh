ipinfo() {
  if [[ ! -f ~/.secrets/ipinfo ]]; then
    echo "you need to add your access token to ~/.secrets/ipinfo"
    return
  fi
  local ip="$1"
  if [[ -z "$ip" ]]; then
    echo "you need to specify an ip"
    return
  fi
  curl -s "https://api.ipinfo.io/lite/${ip}?token=$(cat ~/.secrets/ipinfo)" | jq .
}
