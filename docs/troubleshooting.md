# Troubleshooting

## Profiling ZSH

In the `./.zshrc` file, there are calls to `zprof` which can be used to output performance related data on load.
Uncomment the two lines (at the beginning and end) and open a shell session to get performance profile data.
Comment them out again when you no longer need the data.

Additionally, you can run the following command to get the same profile data with a stack list of all loaded files in load order.

```shell
zsh -l --sourcetrace
```

Finally, if you want to quickly test changes without opening and closing new shell sessions / terminal windows, you can run this command:

```shell
time zsh -i -c exit
```

This command will initialize a zsh shell session within the current session and exit on load.
Whether or not you have zprof enabled this command will provide time / performance overview numbers.

### "Native" Zsh Config Load Order

1. `.zshenv`
2. `.zprofile` (if login)
3. `.zshrc` (if interactive)
4. `.zlogin` (if login)
5. `.zlogout`

Be careful when setting things on `.zshenv` since it can be overridden by subsequent scripts.
:warning: Only `.zshrc` should be used for things like prompt colors and user scripts.