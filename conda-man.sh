#!/bin/bash

# Check if whiptail is available
if ! command -v whiptail &> /dev/null; then
    echo "whiptail is not installed. Please install it to use this enhanced version of conda-man."
    exit 1
fi

# ---- Conda Installation Checks and Utilities Functions ----

check_conda_installed() {
    if ! command -v conda &> /dev/null; then
        whiptail --msgbox "Conda is not installed. Please install it to use this feature." 8 78
        return 1
    else
        whiptail --msgbox "Conda is installed!" 8 40
    fi
}

check_conda_version() {
    local version
    version=$(conda --version)
    whiptail --msgbox "Conda Version: $version" 8 40
}

update_conda() {
    conda update -n base conda
    whiptail --msgbox "Conda updated successfully!" 8 40
}

conda_utilities_menu() {
    while true; do
        UTILITY_OPTION=$(whiptail --title "Conda Installation Checks and Utilities" --menu "Choose an option" 15 60 5 \
            "1" "Check if Conda is Installed" \
            "2" "Check Conda Version" \
            "3" "Update Conda" \
            "4" "Return to Main Menu" 3>&1 1>&2 2>&3)

        exit_status=$?
        if [ $exit_status = 0 ]; then
            case $UTILITY_OPTION in
                1) check_conda_installed ;;
                2) check_conda_version ;;
                3) update_conda ;;
                4) break ;;
            esac
        else
            break
        fi
    done
}

# ---- Environment Management Functions ----

list_environments() {
    local envs
    envs=$(conda env list)
    whiptail --msgbox "Conda Environments:\n$envs" 20 60
}

create_environment() {
    local env_name
    env_name=$(whiptail --inputbox "Enter the name of the new environment:" 8 78 3>&1 1>&2 2>&3)
    exit_status=$?
    if [ $exit_status = 0 ]; then
        conda create --name "$env_name"
        whiptail --msgbox "Environment '$env_name' created successfully!" 8 78
    fi
}

# ... Add more environment management functions here ...

environment_management_menu() {
    while true; do
        ENV_OPTION=$(whiptail --title "Environment Management" --menu "Choose an option" 20 60 9 \
            "1" "List Conda Environments" \
            "2" "Create New Conda Environment" \
            "3" "Return to Main Menu" 3>&1 1>&2 2>&3)  # This menu is shortened for brevity
        
        exit_status=$?
        if [ $exit_status = 0 ]; then
            case $ENV_OPTION in
                1) list_environments ;;
                2) create_environment ;;
                3) break ;;
            esac
        else
            break
        fi
    done
}

# ---- Package Management Functions ----

# ... Add package management functions here ...

package_management_menu() {
    while true; do
        PKG_OPTION=$(whiptail --title "Package Management" --menu "Choose an option" 20 60 8 \
            "1" "Return to Main Menu" 3>&1 1>&2 2>&3)  # This menu is shortened for brevity
        
        exit_status=$?
        if [ $exit_status = 0 ]; then
            case $PKG_OPTION in
                1) break ;;
            esac
        else
            break
        fi
    done
}

install_package() {
    local env_name pkg_name
    env_name=$(whiptail --inputbox "Enter the name of the environment:" 8 78 3>&1 1>&2 2>&3)
    exit_status=$?
    if [ $exit_status = 0 ]; then
        pkg_name=$(whiptail --inputbox "Enter the name of the package to install:" 8 78 3>&1 1>&2 2>&3)
        conda install --name "$env_name" "$pkg_name"
        whiptail --msgbox "Package '$pkg_name' installed successfully in environment '$env_name'!" 8 78
    fi
}

list_packages() {
    local env_name packages
    env_name=$(whiptail --inputbox "Enter the name of the environment:" 8 78 3>&1 1>&2 2>&3)
    exit_status=$?
    if [ $exit_status = 0 ]; then
        packages=$(conda list --name "$env_name")
        whiptail --msgbox "Installed Packages in $env_name:\n$packages" 20 78
    fi
}

# ... Add other package management functions here ...

package_management_menu() {
    while true; do
        PKG_OPTION=$(whiptail --title "Package Management" --menu "Choose an option" 20 60 8 \
            "1" "Install a Package" \
            "2" "List Installed Packages" \
            "3" "Return to Main Menu" 3>&1 1>&2 2>&3)  # This menu is shortened for brevity
        
        exit_status=$?
        if [ $exit_status = 0 ]; then
            case $PKG_OPTION in
                1) install_package ;;
                2) list_packages ;;
                3) break ;;
            esac
        else
            break
        fi
    done
}

# ---- Main menu function using whiptail ----

main_menu() {
    while true; do
        OPTION=$(whiptail --title "Conda-Man CLI" --menu "Choose an option" 15 60 4 \
            "1" "Conda Installation Checks and Utilities" \
            "2" "Environment Management" \
            "3" "Package Management" \
            "4" "Exit" 3>&1 1>&2 2>&3)

        exit_status=$?
        if [ $exit_status = 0 ]; then
            case $OPTION in
                1) conda_utilities_menu ;;
                2) environment_management_menu ;;
                3) package_management_menu ;;
                4) exit 0 ;;
            esac
        else
            exit 0
        fi
    done
}

# Run the main menu
main_menu

