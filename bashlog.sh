export LOG_EDITOR='vim'
export LOG_DIRECTORY='~'
export date_format="+%Y-%m-%d"

alias tomorrow='$LOG_EDITOR $(date -d tomorrow "$date_format").md'
alias today='$LOG_EDITOR $(date "$date_format").md'
alias yesterday='$LOG_EDITOR $(date -d yesterday "$date_format").md'
alias weekly='$LOG_EDITOR $(date +%G-week-%V).md'
alias monthly='$LOG_EDITOR $(date +%G-month-%m).md'
alias daily='$LOG_EDITOR $(date "$date_format").md'

function lstodo()
{
  cmd="grep '\[ \]' * $@ --exclude=*.tmpl"
  echo "$cmd"
  eval $cmd
}

function week()
{
  if [ $# -gt 0 ]; then
    if [[ $1 == +* ]]; then
      local dstring=$(date +%G-week-%V -d "$1 weeks")
    elif [[ $1 == -* ]]; then
      local dstring=$(date +%G-week-%V -d "$1 weeks")
    else
      local dstring="$(date +%G-week)-$1"
    fi
  else
    local dstring=$(date +%G-week-%V)
  fi
	local fname="$dstring.md"
  if [ ! -f "$fname" ]; then
    echo "new entry"
    local tmplname="weekly.md.tmpl"
    if [ -f "$tmplname" ]; then
      echo "found templ"
      cat $tmplname >> $fname
    fi
  fi
  $LOG_EDITOR "$LOG_DIRECTORY/$fname"
}

function log()
{
  local dstring=$(date "$date_format" -d "$*"  )
	local fname="$dstring.md"
  if [ ! -f "$fname" ]; then
    echo "new entry"
    local tmplname="daily.md.tmpl"
    if [ -f "$tmplname" ]; then
      echo "found templ"
      cat $tmplname >> $fname
    fi
  fi
  $LOG_EDITOR "$LOG_DIRECTORY/$fname"
}
