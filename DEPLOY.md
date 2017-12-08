```python3
from distributed import Client
from distributed.security import Security

sec = Security(tls_ca_file='/mnt/mesos/sandbox/.ssl/ca-bundle.crt',
               tls_client_cert='/mnt/mesos/sandbox/.ssl/scheduler.crt',
               tls_client_key='/mnt/mesos/sandbox/.ssl/scheduler.key',
               require_encryption=True)

client = Client('tls://dask-distributed.dask-scheduler.marathon.l4lb.thisdcos.directory:8786',
                security=sec)

def square(x):
    return x ** 2

def neg(x):
    return -x

A = client.map(square, range(10))
B = client.map(neg, A)
total = client.submit(sum, B)
total.result()
```
