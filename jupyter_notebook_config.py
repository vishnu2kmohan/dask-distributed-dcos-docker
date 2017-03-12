from jupyter_core.paths import jupyter_data_dir
from notebook.auth import passwd
import subprocess
import os
import errno
import stat


# Setup the Notebook to listen on all interfaces on port 8888 by default
c.NotebookApp.ip = '*'
c.NotebookApp.port = 8888
c.NotebookApp.open_browser = False

# Configure Networking while running under Marathon:
if 'MARATHON_APP_ID' in os.environ:
    if 'PORT0' in os.environ:
        c.NotebookApp.port = int(os.environ['PORT0'])

    # Allow CORS and TLS from behind Marathon-LB/HAProxy
    if all(key in os.environ for key in ('HAPROXY_GROUP',
                                         'HAPROXY_0_VHOST',
                                         'HAPROXY_0_PATH',
                                         'HAPROXY_0_HTTP_BACKEND_PROXYPASS_PATH')):
        # Whether to trust or not X-Scheme/X-Forwarded-Proto and X-Real-Ip/X-Forwarded-
        # For headers sent by the upstream reverse proxy. Necessary if the proxy handles SSL
        c.NotebookApp.trust_xheaders = True
        # Set the Access-Control-Allow-Origin header
        c.NotebookApp.allow_origin = '*'

    # Default the Jupyter Notebook password to the Marathon app prefix
    marathon_app_prefix = ''.join(os.environ['MARATHON_APP_ID'].split('/')[:-1])
    c.NotebookApp.password = passwd(marathon_app_prefix)

# Set a certificate if USE_HTTPS is set to any value
PEM_FILE = os.path.join(jupyter_data_dir(), 'notebook.pem')
if 'USE_HTTPS' in os.environ:
    if not os.path.isfile(PEM_FILE):
        # Ensure PEM_FILE directory exists
        dir_name = os.path.dirname(PEM_FILE)
        try:
            os.makedirs(dir_name)
        except OSError as exc:  # Python >2.5
            if exc.errno == errno.EEXIST and os.path.isdir(dir_name):
                pass
            else:
                raise
        # Generate a certificate if one doesn't exist on disk
        subprocess.check_call(['openssl', 'req', '-new',
                               '-newkey', 'rsa:2048', '-days', '365', '-nodes', '-x509',
                               '-subj', '/C=XX/ST=XX/L=XX/O=generated/CN=generated',
                               '-keyout', PEM_FILE, '-out', PEM_FILE])
        # Restrict access to PEM_FILE
        os.chmod(PEM_FILE, stat.S_IRUSR | stat.S_IWUSR)
    c.NotebookApp.certfile = PEM_FILE

# Set a password if JUPYTER_PASSWORD is set
if 'JUPYTER_PASSWORD' in os.environ:
    c.NotebookApp.password = passwd(os.environ['JUPYTER_PASSWORD'])
    del os.environ['JUPYTER_PASSWORD']
