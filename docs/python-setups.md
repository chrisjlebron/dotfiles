Python Setups
=============

Python Version Management
-------------------------

mise

After python version installation, mise will install packages specified in [`~/.default-python-packages`](/create_dot_default-python-packages).
For more info, see [mise docs](https://mise.jdx.dev/lang/python.html#default-python-packages).

Env/Dependency Management
-------------------------

pipenv

Debugging in VS Code
--------------------

### With pipenv

If you've initiated a pipenv (e.g. there is a Pipfile) in the directory/workspace, opening the code from the terminal (`code .`) should start you off with the correct interpreter. Otherwise, you can `cmd+p` -> "Python: Select Interpreter" and you should be presented with the option to use the python version associated with that virtualenv (e.g. something like `/Users/it-me/.local/share/virtualenvs/project-name-24tijre_weofin/bin/python`), which will add it to `settings.json` in `.vscode/` in the project root.

Now linting, dependency resolution, etc. should be available/possible.

#### Debugger launch configurations

_CURRENTLY_: in order for debugging to work correctly, you need to also set `python.terminal.activateEnvironment` to `false`

Example `.vscode/settings.json`:

```json
{
  "python.pythonPath": "/Users/clebron/.local/share/virtualenvs/is-programmatic-backfill-opG_phFt/bin/python",
  "python.terminal.activateEnvironment": false
}
```

You may also need to specify `pythonPath` in the launch config:

```json
// ...
"configurations": [
    {
      "name": "Python: Current File",
      "type": "python",
      "request": "launch",
      "program": "${file}",
      "console": "integratedTerminal"
    },
    {
      "name": "Python: some-script.py",
      "type": "python",
      "request": "launch",
      "program": "${workspaceFolder}/some-script.py",
      "pythonPath": "${config:python.pythonPath}", // This line
      "console": "integratedTerminal"
    }
  ]
// ...
```
