# Docker PS prettifier
# revision 6
# https://gist.github.com/GottZ/4a6c2af314d73cd8b71d

dps()  {
  docker ps $@ --format "table{{ .Image }}\\t{{ .Names }}\\t{{ .Status }}\\t{{ .Ports }}" | awk '
    NR % 2 == 0 {
      printf "\033[0m";
    }
    NR % 2 == 1 {
      printf "\033[1m";
    }

    NR == 1 {
      PORTSPOS = index($0, "PORTS");
      PORTS = "PORTS";
      PORTSPADDING = "\n";
      for(n = 1; n < PORTSPOS; n++)
        PORTSPADDING = PORTSPADDING " ";
    }
    NR > 1 {
      PORTS = substr($0, PORTSPOS);
      gsub(/, /, PORTSPADDING, PORTS);
    }

    {
      printf "%s%s\n", substr($0, 0, PORTSPOS - 1), PORTS;
    }

    END {
      printf "\033[0m";
    }
  '
}
dpsa() { dps -a $@; }