import os
import subprocess
from subprocess import PIPE

def run_command(command):
    subprocess.call(command, shell=True)

def get_repo_root():
    return subprocess.check_output('git rev-parse --show-toplevel'.split()).decode('utf-8').strip()

def get_uid():
    return os.getuid()

def get_user():
    return os.getlogin()

def create_directory(directory):
    run_command("mkdir -p {}".format(directory))
    run_command("sudo chown {0}:{0} {1}".format(get_user(), directory))
