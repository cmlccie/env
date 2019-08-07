# Personal Mac & Linux Development Environment

*Shell Configurations and Scripts to Setup my Personal Development Environment*


## Personal Toolchains

- **macOS**
    - [PyCharm Professional](https://www.jetbrains.com/pycharm/) - Primary IDE for Python projects
    - [Xcode](https://developer.apple.com/xcode/) - Primary IDE for Swift Projects
    - [VS Code](https://code.visualstudio.com/) - Secondary IDE / Quick Editor
    - [iA Writer](https://ia.net/writer) - Markdown/Docs Editor
    - [iTerm2](https://iterm2.com/) - Terminal
        - [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts)
        - Custom [Cisco-themed](platforms/macos/apps/iTerm/Cisco.itermcolors) terminal colors
    - [Docker Desktop](https://www.docker.com/products/docker-desktop) - Container Development Environment
    - [Postman](https://www.getpostman.com/) - REST API Client
    - [Homebrew](https://brew.sh/) - Package Manager
- **Linux** | Ubuntu, Raspbian, Debian-based
    - [VS Code](https://code.visualstudio.com/) - Primary IDE
- **Shells**
    - [fish](https://fishshell.com) - Primary OS/Development Shell
        - [oh-my-fish/theme-bobthefish](https://github.com/oh-my-fish/theme-bobthefish)
        - [fisherman/z](https://github.com/jethrokuan/z)
        - [fisherman/pipenv](https://github.com/sentriz/fish-pipenv)
    - [zsh](http://zsh.sourceforge.net/) - Experimenting
    - [bash](https://www.gnu.org/software/bash/) - Portable and Faithful
- **Python**
    - [CPython v3+](https://www.python.org/downloads/) - Primary Interpreter
        - Use [Homebrew](https://brew.sh/) to install and upgrade my *default* interpreter
        - Use [pyenv](https://github.com/pyenv/pyenv) to install additional distributions and versions needed by projects
        - [pew]() to manage my general-purpose virtual environments
        - [pipenv](https://pipenv.readthedocs.io) for per-project dependency and environment management
    - [Anaconda](https://www.anaconda.com/) - Secondary Interpreter | Increasingly using for Data Science Projects

## Principles & Methods

- Use *this* git repository to keep common shell configurations and package lists synchronized between development environments.
    - Configurations and scripts should be portable!
        - Don't use absolute path references.
        - Don't assume that a tool is installed; check if it is.
- Keep system-level package installations to a minimum.
- Don't use the macOS installed Python environment; use Homebrew to install the latest stable Python2 and Python3 CPython interpreters.
- Create general purpose (`dev2`, `dev3`, and `conda`) virtual environments for use with one-off scripts, data processing, system administration tasks, and generic testing.
- Create project-specific virtual environments for every project - use `pipenv` to manage the project dependencies and the associated environment.
- If the project's artifacts will be deployed in a Docker container environment, do the project development inside an identical (or very similar) container image.
- *Always* follow [PEP20](https://www.python.org/dev/peps/pep-0020/) (even when coding in another language).
- *Almost always* follow [PEP8](https://www.python.org/dev/peps/pep-0008/).
