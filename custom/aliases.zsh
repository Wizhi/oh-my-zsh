# Enhanced WHOIS lookups
alias whois="whois -h whois-servers.net"

# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# Old habbits are hard to kill
alias cls=clear

alias fuck='sudo $(fc -ln -1)'

alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip'

alias ssh='eval "$(keychain --eval --agents ssh -Q --quiet id_rsa)" && unalias ssh && ssh'
