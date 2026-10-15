#compdef cht.sh

# generated via `cht.sh :zsh`

compdef _cht.sh cht.sh

_cht.sh()
{
    # generated via `cht.sh :zsh`

    __CHTSH_LANGS=($(curl -s cheat.sh/:list))
    _arguments -C \
    '--help[show this help message and exit]: :->noargs' \
    '--shell[enter shell repl]: :->noargs' \
    '1:Cheat Sheet:->lang' \
    '*::: :->noargs' && return 0

    if [[ CURRENT -ge 1 ]]; then
        case $state in
            noargs)
                _message "nothing to complete";;
            lang)
                compadd -X "Cheat Sheets" "${__CHTSH_LANGS[@]}";;
            *)
                _message "Unknown state, error in autocomplete";;
        esac

        return
    fi
}


# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_cht.sh" ]; then
    _cht.sh
fi
