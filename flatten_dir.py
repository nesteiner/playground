# DONE how to move file to current directory `shutil.move("oldpos","newpos")`
# DONE how to walk the directory 
# DONE how to judge is a directory

import os, shutil
def move_file(filepath: str, dstdir: str):
    filename = os.path.basename(filepath)
    dstpath = os.path.join(dstdir, filename)

    shutil.move(filepath, dstpath)

def copy_file(filepath: str, dstdir: str):
    filename = os.path.basename(filepath)
    dstpath = os.path.join(dstdir, filename)

    shutil.copyfile(filepath, dstpath)


def flatten_dir(path: str, dstdir: str, proc=copy_file):
    for dirpath, dirnames, filenames in os.walk(path):
        for filename in filenames:
            filepath =  os.path.join(dirpath, filename)
            proc(filepath, dstdir)

        for dirname in dirnames:
            _dirpath = os.path.join(dirpath, dirname)
            flatten_dir(_dirpath, dstdir, proc)


# DONE import getopt, and the usage is `flatten --from dirname --to dirname --method copy/move`
import getopt, sys
def main():
    opts, args = getopt.getopt(sys.argv[1:], '', ['from=', 'to=', 'method='])

    filepath = opts[0][1]
    dstdir    = opts[1][1]
    method = opts[2][1]
    
    # DEBUG 
    if not os.path.exists(filepath):
        raise Exception("no such path: {}".format(filepath))
    if not os.path.exists(dstdir):
        raise Exception("no such path: {}".format(dstdir))

    if method is None or method == '':
        method = copy_file
    elif method == 'copy':
        method = copy_file
    elif method == 'move':
        method = move_file
    else:
        raise Exception("no such method: {}".format(method))
    # STUB
    flatten_dir(filepath, dstdir, proc=method)
    print('Done.')

try:
    main()
except Exception as e:
    sys.exit(str(e))
