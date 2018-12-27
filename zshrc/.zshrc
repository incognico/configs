# ~/.zshrc
# nico -> #/dev/null -> irc.rizon.net

# Optional but very pleasant:
# https://github.com/trapd00r/zsh-syntax-highlighting-filetypes 
# https://github.com/trapd00r/LS_COLORS

# Bugs:
# In this config is a very rare completion bug (stalling prompt, can be killed with ^C after a short timeout)
# most likely related to matcher-list but I have not bothered to investigate for years now as it is so rare 🤷

#zsh_load_start_time=$(perl -MTime::HiRes -e 'print int(1000 * Time::HiRes::gettimeofday),"\n"')

# {{{ modules and zle
autoload -U compinit history-search-end url-quote-magic
compinit -d ~/.zsh_compdump
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
zle -N self-insert url-quote-magic
# }}}

# {{{ colors
#local BLACK="%{"$'\033[01;30m'"%}"
local GREEN="%{"$'\033[01;32m'"%}"
local RED="%{"$'\033[01;31m'"%}"
#local YELLOW="%{"$'\033[01;33m'"%}"
local BLUE="%{"$'\033[01;34m'"%}"
#local CYAN="%{"$'\033[01;36m'"%}"
#local BOLD="%{"$'\033[01;39m'"%}"
local NONE="%{"$'\033[00m'"%}"
local RESET="%{"$'\033[G'"%}"
#}}}

# {{{ prompt
local EXITVAL="%(?,%{${GREEN}%},[%{${RED}%}%?%{${NONE}%}]%{${RED}%})"
RPROMPT="${EXITVAL} %T${NONE} "

if [[ $UID -eq 0 ]]; then
   PROMPT="${RESET}${RED}%n@%m${NONE}:${BLUE}%~${NONE} ${BLUE}%#${NONE} "
else
   PROMPT="${RESET}${GREEN}%n@%m${NONE}:${BLUE}%~${NONE} ${BLUE}%#${NONE} "
fi
# }}}

# {{{ term title (after prompt)
case $TERM in
   xterm*|rxvt*|screen*)
      precmd() { print -Pn "\e]0;%n@%m - %~\a" }
      preexec() { print -Pn "\e]0;%n@%m - $1\a" }
      ;;
esac
# }}}

# {{{ dir colors
if [[ -x $(which dircolors) ]]; then
   if [[ -f "$HOME/.zsh/LS_COLORS" ]]; then
      eval $(dircolors -b "$HOME/.zsh/LS_COLORS")
   elif [[ -f "/etc/DIR_COLORS" ]]; then
      eval $(dircolors -b /etc/DIR_COLORS)
   else
      eval $(dircolors -b)
   fi
fi

if [[ -f "$HOME/.zsh/zsh-syntax-highlighting-filetypes.zsh" ]]; then
   source "$HOME/.zsh/zsh-syntax-highlighting-filetypes.zsh"
fi
# }}}

# {{{ ~/bin
if [[ -n "${PATH/*$HOME\/bin:*}" ]]; then
   export PATH="${PATH}:${HOME}/bin"
fi
# }}}

# {{{ history
DIRSTACKSIZE="30"
HISTFILE="${HOME}/.zsh_history"
HISTSIZE="32768"
SAVEHIST="${HISTSIZE}"
# }}}

# {{{ locales
export LANG="en_US.UTF-8"
export GDM_LANG="en_US.UTF-8"
#export LC_ALL="en_US.UTF-8"
export LC_CTYPE="de_DE.UTF-8"
export LC_NUMERIC="de_DE.UTF-8"
export LC_TIME="de_DE.UTF-8"
export LC_COLLATE="C"
export LC_MONETARY="de_DE.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="de_DE.UTF-8"
export LC_NAME="de_DE.UTF-8"
export LC_ADDRESS="de_DE.UTF-8"
export LC_TELEPHONE="de_DE.UTF-8"
export LC_MEASUREMENT="de_DE.UTF-8"
export LC_IDENTIFICATION="de_DE.UTF-8"
export LESSCHARSET="utf-8"
# }}}

# {{{ misc settings
cuname=$(uname)
if [[ -x $(which vim) ]]; then
   export VISUAL="vim"
   export EDITOR=$VISUAL
fi
[[ -x $(which less) ]] && export PAGER="less"
export READNULLCMD="cat"
limit coredumpsize 0 2>/dev/null
typeset -U path cdpath fpath manpath
stty -ixon -ixoff 2>/dev/null
# }}}

# {{{ options
setopt \
ALWAYS_TO_END \
AUTO_CD \
AUTO_PARAM_SLASH \
AUTO_PUSHD \
NO_BEEP \
NO_BG_NICE \
CHASE_LINKS \
COMPLETE_IN_WORD \
CORRECT \
EXTENDED_GLOB \
NO_FLOW_CONTROL \
NO_GLOBDOTS \
HIST_IGNORE_ALL_DUPS \
HIST_REDUCE_BLANKS \
INC_APPEND_HISTORY \
LIST_PACKED \
LIST_ROWS_FIRST \
LOGIN \
LONG_LIST_JOBS \
MULTIOS \
NOTIFY \
NO_RECEXACT \
PROMPT_CR \
PUSHD_IGNORE_DUPS \
PUSHD_MINUS \
PUSHD_SILENT \
PUSHD_TO_HOME \
NO_RECEXACT \
TRANSIENT_RPROMPT
# }}}

# {{{ completion
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completer _complete _match _approximate
#zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*:match:*' original only
#zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/2))numeric)'
zstyle ':completion:*' expand yes
# lower to upper but not vice versa:
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' squeeze-shlashes yes
# descriptions
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%Bno matches for: %d%b'
# ignores
zstyle ':completion:*:(diff|ls|rm|scp):*' ignore-line yes
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
zstyle ':completion:*:functions' ignored-patterns '_*'
# kill menu
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:processes' insert-ids
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

case $cuname in
   Linux)
      if [[ $UID -eq 0 ]]; then
         zstyle ':completion:*:processes' command 'ps axf -o pid,%cpu,%mem,tty,cputime,cmd | sed /ps/d | grep -vE "sed|grep"'
      else
         zstyle ':completion:*:processes' command 'ps f -u $USER -o pid,%cpu,%mem,tty,cputime,cmd | sed /ps/d | grep -vE "sed|grep"'
      fi
      ;;
esac

# misc completion settings
compctl -g '*(-/)' + -g '.*(-/)' -v cd pushd
# }}}

# {{{ bindings
bindkey -e
bindkey '^R' history-incremental-pattern-search-backward 
bindkey '\e[3~' delete-char
bindkey '\e[5~' up-history
bindkey '\e[6~' down-history
bindkey '\e[A' history-beginning-search-backward-end
bindkey '\e[B' history-beginning-search-forward-end
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[7~' beginning-of-line
bindkey '\e[8~' end-of-line
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line
# }}}

# {{{ aliases
alias -g G='|grep'
alias -g H='|head'
alias -g L='|less'
alias -g M='|more'
alias -g N='&>/dev/null'
[[ -x $(which curl) ]] && alias -g P='|curl -F "sprunge=<-" http://sprunge.us'
alias -g S='|sort'
alias -g T='|tail'
alias -g W='|wc -l'
alias -g X='|xargs'
alias ...='../..'
alias ....='../../..'
alias grep='grep --color=auto'
alias l='ls'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -Al'

case $cuname in
   # iOS is Darwin but uses gnuls
   Linux|Darwin)
      alias ls='ls -CFhsv --color=auto'
      ;;
   FreeBSD)
      if [[ -x $(which gnuls) ]]; then
         alias ls='gnuls -CFhsv --color=auto'
      else
         alias ls='ls -FGIh'
      fi
      ;;
esac

alias cp='nocorrect cp -v'
alias mv='nocorrect mv -v'
alias rm='nocorrect rm -v'
alias mkdir='nocorrect mkdir -p'
alias cl='clear'
alias confcat='grep -vE "^#|^$"'
alias df='df -h'
alias du='du -hc'
alias ih='fc -RI'
alias j='jobs -l'
[[ -x $(which vim) ]] && alias vi='vim'
alias vivi='vim ~/.vimrc'
alias vixd='vim ~/.Xdefaults'
alias vixi='vim ~/.xinitrc'
alias viz='vim ~/.zshrc'
if [[ -x $(which wget) ]]; then
   alias wcat='wget -q -O -'
   alias wgetn='wget --no-check-certificate'
fi
alias x='cd;clear'
alias zreload='source ~/.zshrc'
# }}}

# {{{ functions
mkcd() { mkdir -p "$*"; cd "$*" }
propstrings() { xprop | grep -E '^(WM_NAME)|(WM_WINDOW_ROLE)|(WM_CLASS)' }
# }}}

# {{{ host specific aliases and functions
case $HOST in
   997.lifeisabug.com)
      alias msess='tmux attach-session -d -t main || tmux new-session -s main irssi'
      alias geoiplookup='geoiplookup -d /usr/local/share/GeoIP_k'
      alias geoiplookup6='geoiplookup6 -d /usr/local/share/GeoIP_k'
      ;;
esac
# }}}

# {{{ $? fix
true
# }}}

#zsh_load_end_time=$(perl -MTime::HiRes -e 'print int(1000 * Time::HiRes::gettimeofday),"\n"')
#zsh_load_time=$(expr $zsh_load_end_time - $zsh_load_start_time)
#echo "zsh load time: ${zsh_load_time}ms"

# vim: set foldmethod=marker :
