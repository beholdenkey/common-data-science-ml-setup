#!/bin/bash
# Name: setup.sh
# Purpose: This script is intended to install and update the base conda environment packages I use for my projects.

# If you dont want a specific package to be installed or updated, comment it out in the packages array.
declare -a packages=(
	"notebook"
	"nb_conda_kernels"
	"jupyter_contrib_nbextensions"
	"jupyterlab"
	"pip"
	"jupytext"
	"ipywidgets"
	"bqplot"
	"pythreejs"
	"ipyleaflet"
	"jupyter-book"
)

# If you dont want a specific pip package to be installed or updated, comment it out in the pip_packages array.
declare -a pip_packages=(
	"jupyterlab-git"
	"diagrams"
)

# Function to check if a package is already installed
check_installed() {
	local package="$1"
	local package_installed
	package_installed=$(conda list --name base | grep -E "^$package ")
	if [ -n "$package_installed" ]; then
		return 0 # true
	else
		return 1 # false
	fi
}

# Function to check if a conda package is outdated
check_outdated() {
	local package="$1"
	local package_installed
	local current_version
	local installed_version
	package_installed=$(conda list --name base | grep -E "^$package ")
	if [ -n "$package_installed" ]; then
		current_version=$(conda search --info "$package" | awk '/^Version:/ { print $2 }')
		installed_version=$(echo "$package_installed" | awk '{ print $2 }')
		if [ "$current_version" != "$installed_version" ]; then
			return 0 # true
		else
			return 1 # false
		fi
	else
		return 1 # false
	fi
}

# Function to check if a pip package is already installed
check_pip_installed() {
	local package="$1"
	local package_installed
	package_installed=$(pip show "$package" 2>/dev/null)
	if [ $? -eq 0 ]; then
		return 0 # true
	else
		return 1 # false
	fi
}

# Function to check if a pip package is outdated
check_pip_outdated() {
	local package="$1"
	local current_version
	local installed_version
	current_version=$(pip show "$package" | awk '/^Version:/ { print $2 }')
	installed_version=$(pip list --format=columns | awk -v package="$package" '$1 == package { print $2 }')
	if [ "$current_version" != "$installed_version" ]; then
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

# Loop through the pip packages array
for pip_package in "${pip_packages[@]}"; do
	# Check if pip package is already installed
	check_pip_installed "$pip_package"
	if [ $? -eq 0 ]; then
		# Check if pip package is outdated
		check_pip_outdated "$pip_package"
		if [ $? -eq 0 ]; then
			echo "Updating $pip_package..."
			pip install --upgrade "$pip_package"
		else
			echo "$pip_package is already up to date, skipping..."
		fi
	else
		echo "Installing $pip_package..."
		pip install "$pip_package"
	fi
done

# Rebuild JupyterLab if any packages were updated
if [ $updated_flag -eq 1 ]; then
	echo "Rebuilding JupyterLab..."
	jupyter lab build
else
	echo "No packages were updated, skipping JupyterLab rebuild."
fi

# Export the base environment to a file
echo "Exporting the base environment to environment-base.yaml..."
if conda env export --name base >environment-base.yaml; then
	echo "Successfully exported the base environment to environment-base.yaml."
else
	echo "Failed to export the base environment. environment-base.yaml was not overwritten."
fi

# Display success message
echo "All packages have been installed and updated successfully!"
