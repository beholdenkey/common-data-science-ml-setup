# Name: setup.ps1
# Purpose: This script is intended to install and update the base conda environment packages I use for my projects.

$channels = conda config --get channels
if (!$channels.Contains("conda-forge")) {
    conda config --add channels conda-forge
}

# If you don't want a specific package to be installed or updated, comment it out in the packages array.
$packages = @(
    "nb_conda_kernels",
    "jupyter_contrib_nbextensions",
    "pip",
    "jupytext",
    "ipywidgets",
    "bqplot",
    "pythreejs",
    "ipyleaflet",
    "numpy",
    "seaborn",
    "pandas",
    "matplotlib",
    "scipy",
    "scikit-learn",
    "libarchive",
    "ipykernel",
    "pytz",
    "cookiecutter"
)

# If you don't want a specific pip package to be installed or updated, comment it out in the pip_packages array.
$pip_packages = @(
    "jupyterlab",
    "notebook",
    "jupyterlab-git",
    "jupyter_scheduler",
    "voila",
    "diagrams",
    "powerbiclient"
)

# Function to check if a package is already installed
function check_installed {
    param($package)
    $package_installed = (conda list --name base --explicit | Select-String $package).Line
    if ($package_installed) {
        return $true
    }
    else {
        return $false
    }
}

# Function to check if a conda package is outdated
function check_outdated {
    param($package)
    $package_installed = (conda list --name base --explicit | Select-String $package).Line -split " "
    if ($package_installed) {
        if (!(conda search --info $package | Select-String "Version:")) {
            Write-Output "Error: Unable to find information for package $package"
            return $false
        }
        $current_version = (conda search --info $package | Select-String "Version:").Line.Split(": ")[1]
        $installed_version = $package_installed[1]
        if ($current_version -ne $installed_version) {
            return $true
        }
        else {
            return $false
        }
    }
    else {
        return $false
    }
}


# Function to check if a pip package is already installed
function check_pip_installed {
    param($package)
    try {
        pip show $package
        return $true
    }
    catch {
        return $false
    }
}

# Function to check if a pip package is outdated
function check_pip_outdated {
    param($package)
    $current_version = (pip show $package | Select-String "Version:").Line.Split(": ")[1]
    $installed_version = (pip show $package | Select-String "Version:").Line.Split(": ")[1]
    if ($current_version -ne $installed_version) {
        return $true
    }
    else {
        return
        $false
    }
}

# Function to install a package
function install_package {
    param($package)
    Write-Output "Installing $package..."
    conda install -y -c conda-forge $package
}

# Function to update a package
function update_package {
    param($package)
    Write-Output "Updating $package..."
    conda update -y -c conda-forge $package
}

# Loop through the packages array
$updated_flag = 0
foreach ($package in $packages) {
    # Check if package is already installed
    if (check_installed $package) {
        # Check if package is outdated
        if (check_outdated $package) {
            update_package $package
            $updated_flag = 1
        }
        else {
            Write-Output "$package is already up to date, skipping..."
        }
    }
    else {
        install_package $package
        $updated_flag = 1
    }
}

foreach ($pip_package in $pip_packages) {
    # Check if pip package is already installed
    if (check_pip_installed $pip_package) {
        # Check if pip package is outdated
        if (check_pip_outdated $pip_package) {
            Write-Output "Updating $pip_package..."
            pip install --upgrade $pip_package
        }
        else {
            Write-Output "$pip_package is already up to date, skipping..."
        }
    }
    else {
        Write-Output "Installing $pip_package..."
        pip install $pip_package
    }
}

jupyter contrib nbextension install --user

# Configure npm to not use SSL
conda config --set ssl_verify False

if ($updated_flag -eq 1) {
    Write-Output "Rebuilding JupyterLab..."
    jupyter lab build
}
else {
    Write-Output "No packages were updated, skipping JupyterLab rebuild."
}

# Export the base environment to a file
Write-Output "Exporting the base environment to environment-base.yaml..."
try {
    conda env export --name base > environment-base.yaml
    Write-Output "Successfully exported the base environment to environment-base.yaml."
}
catch {
    Write-Output "Failed to export the base environment. environment-base.yaml was not overwritten."
}

# Display success message
Write-Output "All packages have been installed and updated successfully!"
