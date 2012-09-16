# ~/.zshrc
# nico -> #/dev/null -> irc.rizon.net

#zsh_load_start_time=$(perl -MTime::HiRes -e 'print int(1000 * Time::HiRes::gettimeofday),"\n"')

# {{{ modules and zle
autoload -U compinit promptinit history-search-end url-quote-magic
compinit -d ~/.zsh_compdump; promptinit
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
   *term|rxvt*|screen*)
      precmd() { print -Pn "\e]0;%n@%m - %~\a" }
      preexec() { print -Pn "\e]0;%n@%m - $1\a" }
      ;;
esac
# }}}

# {{{ dir colors
if [[ -f "/etc/DIR_COLORS" && -x $(which dircolors) ]]; then
   eval $(dircolors -b /etc/DIR_COLORS)
elif [[ -x $(which dircolors) ]]; then
   eval $(dircolors -b)
fi
# }}}

# {{{ ~/{bin,tmp}
if [[ -n "${PATH/*$HOME\/bin:*}" ]]; then
   export PATH="${PATH}:${HOME}/bin"
fi

if [[ -d "${HOME}/tmp" ]]; then
   export TMPDIR="${HOME}/tmp"
fi
# }}}

# {{{ history
HISTFILE="${HOME}/.zsh_history"
HISTSIZE="8192"
SAVEHIST="${HISTSIZE}"
# }}}

# {{{ locales
export LANG="en_US.UTF-8"
export GDM_LANG="en_US.UTF-8"
#export LC_ALL="en_US.UTF-8"
export LC_CTYPE="de_DE.UTF-8"
export LC_NUMERIC="de_DE.UTF-8"
export LC_TIME="de_DE.UTF-8"
export LC_COLLATE="de_DE.UTF-8"
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
export VISUAL="vim"
export EDITOR="$VISUAL"
export PAGER="less"
export READNULLCMD="cat"
#export COLORTERM="yes"
limit coredumpsize 0
#unset MAILCHECK mailpath
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
NO_PUSHD_MINUS \
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
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*:match:*' original only
#zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/2))numeric)'
zstyle ':completion:*' expand yes
# lower to upper but not vice versa:
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' squeeze-shlashes yes

# descriptions
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%Bno matches for: %d%b'

# ignores
zstyle ':completion:*:(diff|ls|rm|scp):*' ignore-line yes
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found' '(*/)#CVS'
zstyle ':completion:*:(all-|)files' ignored-patterns '(*/)#lost+found' '(|*/)CVS'
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'
zstyle ':completion:*:functions' ignored-patterns '_*'
# kill menu
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:processes' insert-ids
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

case $(uname) in
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
compctl -g '*.ebuild' ebuild
compctl -g '*.torrent' hrktorrent
compdef _hosts unkey_host
#compdef _nothing etc-update dispatch-conf fixpackages
# }}}

# {{{ bindings
bindkey -e
bindkey ' ' magic-space
bindkey '\e[3~' delete-char
bindkey '\e[5~' up-history
bindkey '\e[6~' down-history
bindkey '\e[A'  history-beginning-search-backward-end
bindkey '\e[B'  history-beginning-search-forward-end

case $TERM in
   xterm*|rxvt*|screen*)
      #bindkey '\e[7~' beginning-of-line
      #bindkey '\e[8~' end-of-line
      bindkey "^[[1~" beginning-of-line
      bindkey "^[[4~" end-of-line
      ;;
   linux)
      bindkey '\e[1~' beginning-of-line
      bindkey '\e[4~' end-of-line
      ;;
   *)
      bindkey '\e[H~' beginning-of-line
      bindkey '\e[F~' end-of-line
      ;;
esac
# }}}

# {{{ aliases
alias -g G='|grep'
alias -g H='|head'
alias -g L='|less'
alias -g M='|more'
alias -g N='&>/dev/null'
alias -g P='|curl -F "sprunge=<-" http://sprunge.us'
alias -g S='|sort'
alias -g T='|tail'
alias -g W='|wc -l'
alias -g X='|xargs'
alias ...='../..'
alias ....='../../..'
alias .....='cd ../../../..'
alias grep='grep --color=auto'
alias l='ls'
alias la='ls -A'
alias ll='ls -l'
alias lla='ls -Al'

case $(uname) in
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
alias df='df -h'
alias du='du -hc'
alias cl='clear'
alias confcat='grep -vE "^#|^$"'
alias ih='fc -RI'
alias j='jobs -l'
alias su='su -'
alias vi='vim'
alias vivi='vim ~/.vimrc'
alias vixd='vim ~/.Xdefaults'
alias vixi='vim ~/.xinitrc'
alias viz='vim ~/.zshrc'
alias wcat='wget -q -O -'
alias wipe='screen -wipe'
alias x='cd;clear'
alias zreload='source ~/.zshrc'
# }}}

# {{{ functions
#cp2c() { scp $* c: }
#cp2tmp() { scp $* c:public_html/tmp }
mkcd() { mkdir -p "$*"; cd "$*" }
propstrings() { xprop | grep -E '^(WM_NAME)|(WM_WINDOW_ROLE)|(WM_CLASS)' }
unkey_host() { [[ ! $# -eq 1 ]] && echo "Usage: unkey_host <hostname>" || sed -i -e "/$1/d" $HOME/.ssh/known_hosts }
# }}}

# {{{ host specific aliases and functions
case $HOST in
   devnull)
      alias mscreen='screen -aADRS irssi irssi'
      if [[ ! -z $(screen -list | grep irssi | grep Detached) ]]; then
         screen -aADRS irssi
      fi
      ;;
#   perficio)
#      if [[ $UID -eq 0 ]]; then
#         export PATH="/usr/local/libexec/ccache:$PATH"
#         export CCACHE_PATH="/usr/bin:/usr/local/bin"
#         export CCACHE_DIR="/var/tmp/ccache"
#         export CCACHE_LOGFILE="/var/log/ccache.log"
#      fi
#      ;;
#   uptempo)
#      if [[ $UID -eq 0 ]]; then
#         alias kmake='make -j3 && make install && make modules_install'
#         alias python-updater='python-updater -P paludis'
#         alias srcenv='env-update && source /etc/zsh/zprofile && source ~/.zshrc'
#         alias uninstall-unused='paludis --uninstall-unused && reconcilio'
#         alias vipk='vim /etc/paludis/keywords.conf'
#         alias vipo='vim /etc/paludis/use.conf'
#         alias vipu='vim /etc/paludis/package_unmask.conf'
#         alias vipm='vim /etc/paludis/package_mask.conf'
#         alias vipb='vim /etc/paludis/bashrc'
#      fi
#      ;;
esac
# }}}

# {{{ $? fix
true
# }}}

#zsh_load_end_time=$(perl -MTime::HiRes -e 'print int(1000 * Time::HiRes::gettimeofday),"\n"')
#zsh_load_time=$(expr $zsh_load_end_time - $zsh_load_start_time)
#echo "zsh load time: ${zsh_load_time}ms"

# vim: set foldmethod=marker :
