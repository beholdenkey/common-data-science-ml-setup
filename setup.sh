#!/bin/bash

# Name: setup.sh
# Purpose: This script is intended to install and update the base conda environment packages I use for my projects.

# Define an array of packages to install
declare -a packages=(
	"notebook"
	"nb_conda_kernels"
	"jupyter_contrib_nbextensions"
	"jupyterlab"
	"pip"
	"jupyterlab-git"
	"jupytext"
	"ipywidgets"
	"bqplot"
	"pythreejs"
	"ipyleaflet"
)

# Function to check if a package is already installed
check_installed() {
	local package="$1"
	local package_installed
	package_installed=$(conda list --name base --json | jq -r --arg package "$package" '.installed[] | select(.name == $package)')
	if [ -n "$package_installed" ]; then
		return 0 # true
	else
		return 1 # false
	fi
}

# Function to check if a package is outdated
check_outdated() {
	local package="$1"
	local package_outdated
	package_outdated=$(conda list --name base --json | jq -r --arg package "$package" '.installed[] | select(.name == $package and .version != .installed_version)')
	if [ -n "$package_outdated" ]; then
		return 0 # true
	else
		return 1 # false
	fi
}

# Function to install a package
install_package() {
	local package="$1"
	echo "Installing $package..."
	conda install -y -c conda-forge "$package"
}

# Function to update a package
update_package() {
	local package="$1"
	echo "Updating $package..."
	conda update -y -c conda-forge "$package"
}

# Loop through the packages array
updated_flag=0
for package in "${packages[@]}"; do
	# Check if package is already installed
	check_installed "$package"
	if [ $? -eq 0 ]; then
		# Check if package is outdated
		check_outdated "$package"
		if [ $? -eq 0 ]; then
			update_package "$package"
			updated_flag=1
		else
			echo "$package is already up to date, skipping..."
		fi
	else
		install_package "$package"
		updated_flag=1
	fi
done

# Rebuild JupyterLab if any packages were updated
if [ $updated_flag -eq 1 ]; then
	echo "Rebuilding JupyterLab..."
	jupyter lab build
fi

# Display success message
echo "All packages have been installed and updated successfully!"
