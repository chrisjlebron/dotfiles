# mise-en-place

tool / version manager (replaces asdf, rbenv, pyenv, etc.)

## Common Commands

```shell
# update mise
mise self-update

# install tool at a specific version
mise install {TOOL@VERSION}

# use tool/version in current project
mise use {TOOL@VERSION}

# use tool/version globally
mise use -g {TOOL@VERSION}

# upgrade tools to latest desired versions (if specified in config)
mise upgrade

# check tools for outdated
mise outdated
```

## Troubleshooting Commands

```shell
# health check
mise doctor

# clear cache
mise cache clear

# delete unused versions (interactive)
mise prune

# list & ensure there are no undesired plugins installed
mise plugins
```

## IDE Support

It's best to set up [shims](https://mise.jdx.dev/ide-integration.html#adding-shims-to-path-default-shell)

Could also try [the VS Code extension](https://mise.jdx.dev/ide-integration.html#vscode)
