# Common Platform for Data Science and Machine Learning

Welcome to the base platform for building data science and machine learning projects! This platform provides a consistent environment for building and deploying data science projects, using conda to manage the environment and Jupyter to provide a web-based interface for interacting with the environment.

## Key Features

- A base conda environment is built, which can then be used as a template for creating other conda environments for individual projects.
- A common set of packages and extensions are available to all projects, including Jupyter extensions and conda packages that are used across multiple projects.
- Provides a streamlined workflow for data science projects, allowing for a unified and consistent environment for all projects.
- Supports OSX and Linux operating systems.

## Setting up the Environment

To get started, you need to have conda and Jupyter installed on your machine. Follow these steps to set up the base environment:

1. Clone the repository to your local machine.
2. Open a terminal and navigate to the repository directory.
3. Run the following command to create the base conda environment: `conda env create -f environment-base.yaml`
4. Activate the environment using the following command: `conda activate base`
5. Start the Jupyter Notebook server using the following command: `jupyter lab`

You now have access to the base environment in Jupyter Lab and can start creating other environments for your projects.

## Creating Project Environments

To create a new environment for a project, follow these steps:

1. Clone the repository to your local machine.
2. Open a terminal and navigate to the repository directory.
3. Create a new conda environment based on the base environment using the following command: `conda create --name project_env --clone base`
4. Activate the new environment using the following command: `conda activate project_env`
5. Start the Jupyter Notebook server using the following command: `jupyter lab`

You now have a new environment for your project, with all of the packages and extensions from the base environment.

## Conclusion

With this common platform for data science and machine learning, you can build and deploy projects with ease and consistency. The base environment provides a solid foundation for all projects and the ability to create new environments for individual projects ensures that each project has the packages and extensions it needs. Happy coding!

## References

- [Cookiecutter Data Science](https://github.com/drivendata/cookiecutter-data-science)
- [Conda Cheat sheet](https://conda.io/docs/_downloads/conda-cheatsheet.pdf)
- [Jupyter Lab](https://jupyterlab.readthedocs.io/en/stable/)
- [Conda](https://conda.io/)
