import os
import sys
import subprocess

if len(sys.argv) < 4:
    print('wrong number of arguments.')
    sys.exit()

sln_name = sys.argv[1]
file_path = sys.argv[2]
line = sys.argv[3]

pipe_name = r'\\.\pipe\nvim-qt-' + sln_name
if os.path.exists(pipe_name):
    cmd = 'nvr --servername {} -c "call GuiForeground()" -c :{} {}'.format(pipe_name, line, file_path)
    subprocess.Popen(cmd, shell=True)

else:
    cmd = 'nvim-qt -- --listen {} -c :{} {}'.format(pipe_name, line, file_path)
    subprocess.Popen(cmd, shell=True)
