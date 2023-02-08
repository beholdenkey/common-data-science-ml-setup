# Conda Cheat Sheet

A cheat sheet for conda, a package manager for Python. This is meant to provide the reader a quick answer to a question, not a comprehensive guide to conda.

## Conda Basics

| ------------------------ | ------------------------------------------------------ |
| `conda info` | Display information about current conda install |
| `conda list` | List installed packages in current environment |
| `conda list -n <env>` | List installed packages in named environment |
| `conda search <package>` | Search for packages and display associated information |
| `conda create -n <env>` | Create a new environment |
| `conda activate <env>` | Activate an environment |
| `conda deactivate <env>` | Deactivate an environment |
| `conda remove -n <env>` | Remove an environment |
| `conda install <pkg>` | Install a package in active env |
| `conda install -n <env>` | Install a package in named environment |
| `conda update <pkg>` | Update a package in active environment |
| `conda update -n <env>` | Update a package in named environment |
| `conda remove <pkg>` | Remove a package in active environment |
| `conda list --export >` | Export list of packages in active env |
| `conda env export --name <env> > environment.yml` | Export list of packages in named environment |
| `conda env create -f environment.yml` | Create an environment from an environment.yml file |
