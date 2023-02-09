# Common Platform for Data Science and Machine Learning

Welcome to the base platform for building data science and machine learning projects! This platform provides a consistent environment for building and deploying data science projects, using `conda` to manage the environment and `jupyter` to provide a web-based interface for interacting with the environment.

## Why Use a Common Platform?

I found that time and time again, I spent a lot of time setting up the environment for a new project. I would have to install the same packages and extensions repeatedly, and I would often need to remember to install a package I needed. This was a huge waste of time, and I wanted to find a way to streamline the process.

## Key Features

- A base `conda` environment is built, which can then be used to create other conda environments for individual projects.
- A common set of packages and extensions are available to all projects, including `jupyter` extensions and `conda` packages that are used across multiple projects.
- Provides a streamlined workflow for data science projects, allowing for a unified and consistent environment for all projects.

### Supported Operating Systems

> Note: This process currently does not work on Windows. I am working on a process for windows using powershell.

- OSX
- Linux

## Setting up the Environment

To get started, you will need to install `conda` and `jupyter`. Then, follow these steps to set up the base environment:

- Clone the repository to your local machine.
- Open a terminal and navigate to the repository directory.
- Run the following command to create the base conda environment:

```bash
conda env create -f environment-base.yaml
```

Activate the environment using the following command:

```bash
conda activate base
```

Start the Jupyter Notebook server using the following command:

```bash
jupyter lab
```

You should now have access to the base environment in Jupyter Lab, and can start creating other environments for your projects.

## Creating Project Environments

To create a new environment for a project, you can use the following steps:

- Clone the repository to your local machine.
- Open a terminal and navigate to the repository directory.
- Create a new conda environment based on the base environment using the following command:

```bash
conda create --name project_env --clone base
```

Activate the new environment using the following command:

```bash
conda activate project_env
```

Start the Jupyter Notebook server using the following command:

```bash
jupyter lab
```

You should now have access to a new environment for your project, with all of the packages and extensions from the base environment.

## Conclusion

With this common platform for data science and machine learning, you can now build and deploy projects with ease and consistency. The base environment provides a solid foundation for all projects, and the ability to create new environments for individual projects ensures that each project has the packages and extensions it needs. Happy coding!

### References

- [Cookiecutter Data Science](https://drivendata.github.io/cookiecutter-data-science/)
- [Conda Cheat sheet](https://conda.io/projects/conda/en/latest/user-guide/cheatsheet.html)
- [Jupyter Lab](https://jupyterlab.readthedocs.io/en/stable/)
- [Conda](https://docs.conda.io/en/latest/)
