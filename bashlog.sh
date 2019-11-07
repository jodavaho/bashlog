#Get current directory for fun

export bashlog_setup_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

if [ -z "${LOG_EDITOR}" ]
then
  export LOG_EDITOR="vim -S $bashlog_setup_dir/vim_log"
fi

if [ -z "${LOG_DIRECTORY}" ]
then
  export LOG_DIRECTORY="~"
fi

export date_format="+%Y-%m-%d"

function lstodo()
{
  cmd="grep '\[ \]' $LOG_DIRECTORY/* $@ --exclude=*.tmpl"
  echo "$cmd"
  eval $cmd
}

function newish()
{
  find $logdir -mtime -10 -type f -not -path '*.git/*'
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
  eval $LOG_EDITOR "$LOG_DIRECTORY/$fname"
}

function log()
{
  local dstring=$(date "$date_format" -d "$*"  )
  local week=$(date -d "$*" +%Y-week-%V.md)
	local fname="$dstring.md"
  if [ ! -f "$fname" ]; then
    echo "new entry"
    local tmplname="daily.md.tmpl"
    if [ -f "$tmplname" ]; then
      echo "found templ"
      cat $tmplname >> $fname
    fi
  fi
  eval $LOG_EDITOR "$LOG_DIRECTORY/$fname" "$LOG_DIRECTORY/$week"
}

alias tomorrow='$LOG_EDITOR $(date -d tomorrow "$date_format").md'
alias today='$LOG_EDITOR $(date "$date_format").md'
alias yesterday='$LOG_EDITOR $(date -d yesterday "$date_format").md'
alias whattodo='lstodo -nl | vim -'
