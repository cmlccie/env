#!/usr/bin/env bash
# Upgrade system (homebrew) and Python packages


cd "$(dirname "$0")"


# Process Script Arguments
all=true
for i in ${@}; do
    case ${i} in
        brew)
        brew=true
        all=
        ;;

        poetry)
        poetry=true
        all=
        ;;

        sys2)
        sys2=true
        all=
        ;;

        sys3)
        sys3=true
        all=
        ;;

        dev2)
        dev2=true
        all=
        ;;

        dev3)
        dev3=true
        all=
        ;;

        conda)
        conda=true
        all=
        ;;
    esac
done


if [[ ${brew} ]] || [[ ${all} ]]; then
    printf "\n==> Upgrading Homebrew Packages\n"
    brew update
    brew doctor
    brew upgrade
    brew cleanup

    # printf "\nDowngrading Fish to v2.7.1; while v3.0 is broken"
    # # To be fixed in Fish v3.1?
    # # https://github.com/fish-shell/fish-shell/issues/5456
    # # https://github.com/pypa/pipenv/issues/3414
    # brew unlink fish
    # brew install https://raw.githubusercontent.com/Homebrew/homebrew-core/2827b020c3366ea93566a344167ba62388c16c7d/Formula/fish.rb
    # brew link fish


    printf "\nUpdating pyenv shims"
    pyenv rehash
fi


if [[ ${poetry} ]] || [[ ${all} ]]; then
    printf "\n==> Intalling/upgrading Python Poetry\n"
    if [[ -z "$(poetry --version 2>/dev/null)" ]]; then
        printf "Updating poetry..."
        poetry self update
    else
        printf "Updating poetry..."
        curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3
    fi
fi


if [[ ${sys2} ]] || [[ ${all} ]]; then
    printf "\n==> Performing a clean install of the Python2 System Packages\n"

    sys2_packages=`mktemp -t sys2_packages`

    printf "\nUninstalling existing Python2 (pip2) System Packages"
    pip2 freeze > ${sys2_packages}
    pip2 uninstall -y -r ${sys2_packages}

    sort -uo python/sys2-requirements.txt python/sys2-requirements.txt

    printf "\nInstalling Python2 (pip2) System Packages from python/sys2-requirements.txt"
    pip2 install --upgrade pip setuptools wheel
    pip2 install --upgrade -r python/sys2-requirements.txt

    rm ${sys2_packages}
fi


if [[ ${sys3} ]] || [[ ${all} ]]; then
    printf "\n==> Upgrading Python3 System Packages\n"

    sys3_packages=`mktemp -t sys3_packages`

    printf "\nUninstalling existing Python3 (pip3) System Packages"
    pip3 freeze > ${sys3_packages}
    pip3 uninstall -y -r ${sys3_packages}

    sort -uo python/sys3-requirements.txt python/sys3-requirements.txt

    printf "\nInstalling Python3 (pip3) System Packages from python/sys3-requirements.txt"
    pip3 install --upgrade pip setuptools wheel
    pip3 install --upgrade -r python/sys3-requirements.txt

    rm ${sys3_packages}
fi


if [[ ${dev2} ]] || [[ ${all} ]]; then
    printf "\n==> Performing a clean build of the Python dev2 Virtual Environment from python/dev2-requirements.txt\n"
    sort -uo python/dev2-requirements.txt python/dev2-requirements.txt
    pew rm dev2
    pew new -d -p python2 -r python/dev2-requirements.txt dev2
fi


if [[ ${dev3} ]] || [[ ${all} ]]; then
    printf "\n==> Performing a clean build of the Python dev3 Virtual Environment from python/dev3-requirements.txt\n"
    sort -o python/dev3-requirements.txt python/dev3-requirements.txt
    pew rm dev3
    pew new -d -p python3 -r python/dev3-requirements.txt dev3
fi


if [[ ${conda} ]] || [[ ${all} ]]; then
    printf "\n==> Updating packages in the Conda base environment\n"
    conda update -n base --all -y
fi
