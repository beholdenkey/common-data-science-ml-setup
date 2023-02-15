#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Installs and updates packages for the base environment.
.DESCRIPTION
    This script installs and updates packages for the base environment.
.NOTES
    File Name: setup.ps1
    Compatible Operating Systems: Windows
    Prerequisites: Anaconda or Miniconda
#>

# Define commonly used parameters
$conda_channel_name = "conda-forge"
$conda_ssl_verify_flag = $false

# Set strict channel priority
conda config --set channel_priority strict

# Add conda-forge channel if it is not already present
try {
    $channels = conda config --get channels
    if (!$channels.Contains($conda_channel_name)) {
        conda config --add channels $conda_channel_name
    }
}
catch {
    Write-Error "Error: Unable to configure conda channels: $_"
    exit 1
}

# Packages to install and update
$packages = @(
    "nb_conda_kernels",
    "jupyter_contrib_nbextensions",
    "pip",
    "jupytext",
    "ipywidgets",
    "ipykernel"
)

# Pip packages to install and update
$pip_packages = @(
    "jupyterlab",
    "notebook",
    "jupyterlab-git",
    "jupyter_scheduler"
)

# Check if a conda package is installed
function check_conda_installed {
    param($package)
    try {
        $package_installed = (conda list --name base --explicit | Select-String $package -Quiet)
        return $package_installed
    }
    catch {
        Write-Error "Error: Unable to check if package $package is installed: $_"
        return $false
    }
}

# Check if a pip package is installed
function check_pip_installed {
    param($package)
    try {
        $package_installed = (pip show $package -ErrorAction Stop)
        return $package_installed
    }
    catch {
        return $false
    }
}

# Install or update packages as needed
$updated_flag = 0
foreach ($package in $packages) {
    # Check if package is already installed
    if (check_conda_installed $package) {
        conda update -y -c $conda_channel_name $package -n base
        $updated_flag = 1
    }
    else {
        conda install -y -c $conda_channel_name $package -n base
        $updated_flag = 1
    }
}

foreach ($pip_package in $pip_packages) {
    if (check_pip_installed $pip_package) {
        Write-Output "Updating $pip_package..."
        pip install --upgrade $pip_package
        $updated_flag = 1
    }
    else {
        Write-Output "Installing $pip_package..."
        pip install $pip_package
        $updated_flag = 1
    }
}

# Install Jupyter Notebook extensions
jupyter contrib nbextension install --user

# Disable SSL verification if necessary    
$ssl_verify = conda config --get ssl_verify
if ($ssl_verify -ne $conda_ssl_verify_flag) {
    conda config --set ssl_verify $conda_ssl_verify_flag
}

# Rebuild JupyterLab if any packages were updated
if ($updated_flag -eq 1) {
    Write-Output "Rebuilding JupyterLab..."
    jupyter lab build
}
else {
    Write-Output "No packages were updated, skipping JupyterLab rebuild."
}

# Export the base environment to a file
$env_file = "environment.yaml"
Write-Output "Exporting the base environment to $env_file"
conda env export --name base --no-builds --file $env_file

# Display success message
Write-Output "All packages have been installed and updated"