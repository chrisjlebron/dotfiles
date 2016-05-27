# uncomment to profile prompt startup with zprof
# zmodload zsh/zprof

# history
HISTFILE=~/.zsh_history
SAVEHIST=100000

# vim bindings (comment out for usage of option+arrows)
# bindkey -v


fpath=( "$HOME/.zfunctions" $fpath )


######################################################################
### env vars for config (themes, autosuggest)
# Defined at the top b/c Pure wasn't handling prompt symbol correctly

# export SPACESHIP_PROMPT_SYMBOL='✧'
export PURE_PROMPT_SYMBOL='✧'
export PURE_NVM_SHOW=true

# reduce visibility of autosuggestion
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=0'

###
################################################################################



# antigen time!
source ~/code/antigen/antigen.zsh


######################################################################
### install some antigen bundles

local b="antigen-bundle"


# oh-my-zsh's library is slow, but needed for spaceship theme.
# Remove if you switch themes.
# antigen use oh-my-zsh

# Guess what to install when running an unknown command.
$b command-not-found

# Helper for extracting different types of archives.
$b extract

# atom editor (uncomment for shortcuts...)
# $b atom

# homebrew  - autocomplete on `brew install`
$b brew
$b brew-cask

# add npm completion
$b npm

# npm script completion
# $b akoenig/npm-run.plugin.zsh

# Tracks your most used directories, based on 'frecency'.
$b robbyrussell/oh-my-zsh plugins/z

# oh-my-zsh's git plugin, for all them good aliases
$b robbyrussell/oh-my-zsh plugins/git

# oh-my-zsh's git-flow plugin, for all them good aliases
$b robbyrussell/oh-my-zsh plugins/git-flow

# Syntax highlighting on the readline
$b zsh-users/zsh-syntax-highlighting

# colors for all files!
$b trapd00r/zsh-syntax-highlighting-filetypes

# suggestion as you type
$b tarruda/zsh-autosuggestions

# nicoulaj's moar completion files for zsh
# $b zsh-users/zsh-completions src

# dont set a theme, because Pure does it all
$b mafredri/zsh-async
# $b sindresorhus/pure
$b /Users/chrisjlebron/dev/zsh/pure pure.zsh --no-local-clone

# history search
$b zsh-users/zsh-history-substring-search ./zsh-history-substring-search.zsh

# Theme: spaceship
# REF: https://github.com/denysdovhan/spaceship-zsh-theme
# Have to reference spaceship.zsh and bundle rather than call theme
# cuz it was renamed from spaceship.zsh-theme
# OLD:
# antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship
# NEW:
# $b https://github.com/denysdovhan/spaceship-zsh-theme spaceship.zsh
# $b /Users/chrisjlebron/dev/zsh/spaceship-zsh-theme spaceship.zsh --no-local-clone

# Not a bad theme, but i'm more into spaceship at the moment
# antigen theme https://github.com/davydovanton/excess.zsh-theme excess

# Tell antigen that you're done.
antigen apply

###
################################################################################




# Enable autosuggestions automatically.
# zle-line-init() {
#     zle autosuggest-start
# }
# zle -N zle-line-init


# bind UP and DOWN arrow keys for history search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey "$terminfo[cuu1]" history-substring-search-up
bindkey "$terminfo[cud1]" history-substring-search-down

# export PURE_GIT_UNTRACKED_DIRTY=0

# Automatically list directory contents on `cd`.
auto-ls () {
	emulate -L zsh;
	# explicit sexy ls'ing as aliases arent honored in here.
	hash gls >/dev/null 2>&1 && CLICOLOR_FORCE=1 gls -aFh --color --group-directories-first || ls
}
chpwd_functions=( auto-ls $chpwd_functions )

# history mgmt
# http://www.refining-linux.org/archives/49/ZSH-Gem-15-Shared-history/
setopt inc_append_history
setopt share_history
setopt HIST_IGNORE_ALL_DUPS

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# uncomment to finish profiling
# zprof

# Load default dotfiles
source ~/.bash_profile

# Use node version specified in .nvmrc (if one exists)
# **MUST** be after nvm initialization
# REF: https://github.com/creationix/nvm#zsh
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  elif [[ $(nvm version) != $(nvm version default)  ]]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# For debugging PATH
# echo "PATH after zshrc: \n${PATH}"
