# Personal macOS and Linux Development Environments

_Shell configurations_ and _scripts_ to setup my development environments

## Personal Toolchains

- **macOS**

  - [VS Code](https://code.visualstudio.com/) - code editor
  - [PyCharm Professional](https://www.jetbrains.com/pycharm/) - IDE for Python projects
  - [Xcode](https://developer.apple.com/xcode/) - IDE for Swift Projects
  - [iA Writer](https://ia.net/writer) - markdown/docs editor
  - [iTerm2](https://iterm2.com/) - terminal
    - [Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts)
    - Custom [AWS-themed](platforms/macos/apps/iTerm/AWS.itermcolors) terminal colors
  - [Docker Desktop](https://www.docker.com/products/docker-desktop) - local container environment
  - [Postman](https://www.getpostman.com/) - REST API client
  - [Homebrew](https://brew.sh/) - macOS package manager

- **Linux** - Ubuntu, Raspbian, Debian-based

  - [VS Code](https://code.visualstudio.com/) - code editor

- **Shells**

  - [zsh](http://zsh.sourceforge.net/) - primary shell
    - [powerlevel10k](https://github.com/romkatv/powerlevel10k) - theme
  - [bash](https://www.gnu.org/software/bash/) - shell scripts

- **Utilities**

  - [gnupg](https://www.gnupg.org/) - OpenPGP

- **Python**
  - [pyenv](https://github.com/pyenv/pyenv) - python version management
  - [poetry](https://python-poetry.org/) - packaging and dependency management
  - [CPython v3](https://www.python.org/downloads/) - primary interpreter
  - [Anaconda](https://www.anaconda.com/) - notebooks and data science projects
  - [black](https://github.com/psf/black) - code formatting
  - [flake8](https://flake8.pycqa.org/en/latest/) - code linting
  - [pytest](https://docs.pytest.org/) - tests

## Principles and Methods

- Use _this_ git repository to keep common shell configurations and package lists synchronized between development environments.
  - Configurations and scripts should be portable!
    - Don't use absolute path references.
    - Don't assume that a tool is installed; check if it is.
- Don't use the macOS or Homebrew installed Python interpreters. Use `pyenv` manage installed interpreters.
- Keep system-level package installations to a minimum.
- Create project-specific virtual environments for every project. Use `poetry` to manage project dependencies and the associated environment.
- If project artifacts will be deployed in a Docker container, do the project development using the container environment.
- Remember the _wisdom_ in [PEP20](https://www.python.org/dev/peps/pep-0020/) (even when coding in another language).
- _Almost always_ follow [PEP8](https://www.python.org/dev/peps/pep-0008/).
