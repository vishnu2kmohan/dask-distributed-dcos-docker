from jupyter_core.paths import jupyter_data_dir
import subprocess
import os
import errno
import stat

PEM_FILE = os.path.join(jupyter_data_dir(), 'notebook.pem')

# Setup the Notebook to listen on all interfaces on port 8888 by default
c.NotebookApp.ip = '*'
c.NotebookApp.port = 8888

# To use Docker Host Networking under Marathon, provided PORT_8888 is not set:
if 'PORT_8888' not in os.environ:
    if 'PORT0' in os.environ:
        c.NotebookApp.port = int(os.environ['PORT0'])

c.NotebookApp.open_browser = False
c.NotebookApp.server_extensions.append('ipyparallel.nbextension')

# Set a certificate if USE_HTTPS is set to any value
if 'USE_HTTPS' in os.environ:
    if not os.path.isfile(PEM_FILE):
        # Ensure PEM_FILE directory exists
        dir_name = os.path.dirname(PEM_FILE)
        try:
            os.makedirs(dir_name)
        except OSError as exc: # Python >2.5
            if exc.errno == errno.EEXIST and os.path.isdir(dir_name):
                pass
            else: raise
        # Generate a certificate if one doesn't exist on disk
        subprocess.check_call(['openssl', 'req', '-new', 
            '-newkey', 'rsa:2048', '-days', '365', '-nodes', '-x509',
            '-subj', '/C=XX/ST=XX/L=XX/O=generated/CN=generated',
            '-keyout', PEM_FILE, '-out', PEM_FILE])
        # Restrict access to PEM_FILE
        os.chmod(PEM_FILE, stat.S_IRUSR | stat.S_IWUSR)
    c.NotebookApp.certfile = PEM_FILE

# Set a password if PASSWORD is set
if 'PASSWORD' in os.environ:
    # Hashed password to use for web authentication.
    # To generate, type in a python/IPython shell:
    #   from notebook.auth import passwd; passwd()
    # The string should be of the form type:salt:hashed-password.
    c.NotebookApp.password = os.environ['PASSWORD']
    del os.environ['PASSWORD']
