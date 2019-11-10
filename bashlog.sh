#Get current directory for fun

export bashlog_setup_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

if [ -z "${LOG_EDITOR}" ]
then
  export LOG_EDITOR="vim -S $bashlog_setup_dir/vim_log"
fi

if [ ${LOG_ABSOLUTE:-false} = true ]
then
  if [ -z "${LOG_DIRECTORY}" ]
  then
    export LOG_DIRECTORY="~"
  fi
  echo "Logging to $LOG_DIRECTORY"
else 
  echo "Relative logging (./)"
  export LOG_DIRECTORY="."
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
  if [ ! -f "$LOG_DIRECTORY/$fname" ] && [ -f "$LOG_DIRECTORY/$tmplname" ]; then
      eval "$LOG_EDITOR -c 'cd $LOG_DIRECTORY' -c 'read $LOG_DIRECTORY/$tmplname' $LOG_DIRECTORY/$fname"
  else
    eval "$LOG_EDITOR $LOG_DIRECTORY/$fname"
  fi
}

function log()
{
  local dstring=$(date "$date_format" -d "$*"  )
	local fname="$dstring.md"
  local tmplname="daily.md.tmpl"
  if [ ! -f "$LOG_DIRECTORY/$fname" ] && [ -f "$LOG_DIRECTORY/$tmplname" ]; then
      eval "$LOG_EDITOR -c 'cd $LOG_DIRECTORY' -c 'read $LOG_DIRECTORY/$tmplname' $LOG_DIRECTORY/$fname"
  else
    eval "$LOG_EDITOR $LOG_DIRECTORY/$fname"
  fi
}
