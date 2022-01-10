
from subprocess import check_output

def get_pass(key):
    return check_output(['pass', key], encoding='utf-8').splitlines()[0]
