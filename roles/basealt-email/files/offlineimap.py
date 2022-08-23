
import sys
from subprocess import check_output


def get_pass(key):
    if sys.version_info.major == 3:
        return check_output(['pass', key], encoding='utf-8').splitlines()[0]
    elif sys.version_info.major == 2:
        return check_output(['pass', key]).splitlines()[0]
    else:
        raise RuntimeError("unsupported python version")
