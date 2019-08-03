#!/usr/bin/env python3
"""Setup my home directory.

Usage: setup-home [file_paths...]
"""


import sys

from datetime import datetime
from pathlib import Path
from shutil import copy, move
from typing import List, Optional


HOME_DIRECTORY_MODE = 0o770


user_home = Path.home()

repo_root = Path(__file__).parent.resolve()
repo_home = repo_root/"home"


# Helper Functions
def translate_home_path(home_path: Path) -> Path:
    """Translate a path from repo_home to user_home or vice versa."""
    if repo_home in home_path.parents:
        relative_path = home_path.relative_to(repo_home)
        return user_home.joinpath(relative_path)

    elif user_home in home_path.parents:
        relative_path = home_path.relative_to(user_home)
        return repo_home.joinpath(relative_path)

    else:
        raise ValueError(
            f"`{home_path}` is not a child directory of `{repo_home}` or "
            f"`{user_home}`"
        )


def backup_file(file_path: Path):
    """Make a backup copy of the file at file_path; suffixing the timestamp."""
    src = str(file_path)
    dst = f"{file_path}.backup.{datetime.now().isoformat()}"

    print(f"Backing Up: {src} -> {dst}")
    copy(src, dst)


# Main Functions
def create_home_directories():
    """Create repo_home sub-directories in the user_home directory."""
    # Directories to create
    directories = (
        translate_home_path(path)
        for path in repo_home.rglob("*")
        if path.is_dir() and not path.is_symlink()
    )

    for directory in directories:
        if directory.exists():
            # Don't touch it
            continue
        else:
            # Create it
            directory.mkdir(mode=HOME_DIRECTORY_MODE, parents=True)


def create_home_directory_symbolic_links():
    """Create symlinks in user_home to all files in repo_home."""
    file_paths = (
        path
        for path in repo_home.rglob("*")
        if path.is_file() and not path.is_symlink()
    )

    for file_path in file_paths:
        sym_link_path = translate_home_path(file_path)

        if sym_link_path.is_file():
            backup_file(sym_link_path)
            sym_link_path.unlink()

        if sym_link_path.is_symlink():
            sym_link_path.unlink()

        print(f"Creating Symbolic Link: {sym_link_path} -> {file_path}")
        sym_link_path.symlink_to(file_path)


def move_and_symlink_file(file_path: Path):
    """Move a file from user_home to repo_home; replace it with a symlink."""
    assert file_path.is_file() and not file_path.is_symlink() \
           and user_home in file_path.parents

    original_path = file_path
    new_path = translate_home_path(original_path)

    print(f"Moving: {original_path} -> {new_path}")
    if not new_path.parent.exists():
        new_path.parent.mkdir(mode=HOME_DIRECTORY_MODE, parents=True)
    move(str(original_path), str(new_path))

    print(f"Creating Symlink: {original_path} -> {new_path}")
    original_path.symlink_to(new_path)


def main(file_paths: Optional[List[Path]] = None):
    """Script's main function.

    If no arguments are supplied when calling the script, mirror the directory
    structure from ${repo_root}/home to the user's home directory and create
    symlinks to the files in the ${repo_root}/home directory and
    subdirectories.

    If arguments are supplied, they should be paths to regular files located
    underneath the user's home directory.  Move the files to their relative
    locations in ${repo_root}/home directory and create symlinks in their
    original locations that point to their new homes.

    Args:
        file_paths: A list of file paths to be moved and symbolically linked.
    """
    if file_paths:
        for file_path in file_paths:
            move_and_symlink_file(file_path)

    else:
        create_home_directories()
        create_home_directory_symbolic_links()


if __name__ == '__main__':
    if len(sys.argv) > 1:
        _, *file_paths = sys.argv
        file_paths = [Path(p).expanduser() for p in file_paths]

        main(file_paths)

    else:
        main()
