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
  cmd="grep '\[ \]' * $@ --exclude=*.tmpl"
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
  local tmplname="weekly.md.tmpl"
  if [ ! -f "$fname" ] && [ -f "$tmplname" ]; then
      eval "$LOG_EDITOR -c 'read daily.md.tmpl' $fname"
  else
    eval "$LOG_EDITOR $fname"
  fi
}

function log()
{
  local dstring=$(date "$date_format" -d "$*"  )
	local fname="$dstring.md"
  local tmplname="daily.md.tmpl"
  if [ ! -f "$fname" ] && [ -f "$tmplname" ]; then
      eval "$LOG_EDITOR -c 'read daily.md.tmpl' $fname"
  else
    eval "$LOG_EDITOR $fname"
  fi
}

alias whattodo='lstodo -nl | vim -'
