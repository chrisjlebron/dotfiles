# chezmoi

<https://www.chezmoi.io/>

## chezmoiignore

List any files or directories that you don't want chezmoi to run or copy to $HOME
See [.chezmoiignore](/.chezmoiignore)

## Useful commands

See all chezmoi commands: <https://www.chezmoi.io/reference/commands/verify/>

```shell
# alias for `chezmoi`
cm

# print out all chezmoi data, including inputs from templates
cm data

# see what has changed and how it will change (https://www.chezmoi.io/reference/commands/status/)
cm status

# see a diff of source & $HOME
cm diff

# edit chezmoi config (this governs the template values, e.g. .gitconfig GH PAT)
cm edit-config

# general warnings & advice
cm doctor

# see which files in $HOME are not tracked by chezmoi
cm unmanaged

# add file from $HOME to source dir
cm add ~/FILE

# apply any changes in source to home dir
cm apply
```
