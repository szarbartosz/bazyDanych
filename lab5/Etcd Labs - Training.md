---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.4.2
  kernelspec:
    display_name: Python 3.6
    language: python
    name: python3
---

<!-- #region -->
## ETCD LAB 

A distributed, reliable key-value store for the most critical data of a distributed system.  
Homepage: https://etcd.io/

Key features:

- Simple: well-defined, user-facing API (gRPC)
- Secure: automatic TLS with optional client cert authentication
- Fast: benchmarked 10,000 writes/sec
- Reliable: properly distributed using Raft


There are two major use cases: concurrency control in the distributed system and application configuration store. For example, CoreOS Container Linux uses etcd to achieve a global semaphore to avoid that all nodes in the cluster rebooting at the same time. Also, Kubernetes use etcd for their configuration store.

During this lab we will be using etcd3 python client.  
Homepage: https://pypi.org/project/etcd3/
<!-- #endregion -->

Etcd credentials are shared on the slack channel: https://join.slack.com/t/ibm-agh-labs/shared_invite/zt-e8xfjgtd-8IDWmn912qPOflbM1yk6~Q

Please copy & paste them into the cell below:

```python
etcdCreds = {
  "connection": {
    "cli": {
      "arguments": [
        [
          "--cacert=45dc1d70-521a-11e9-8c84-3e25686eb210",
          "--endpoints=https://afc2bd38-f85c-4387-b5fc-f4642c7fcf7b.bc28ac43cf10402584b5f01db462d330.databases.appdomain.cloud:31190",
          "--user=ibm_cloud_f59f3a7b_7578_4cf8_ba20_6df3b352ab46:230064666d4fe6d81f7c53a2c364fb60fa079773e8f9adbc163cb0b2e3c58142"
        ]
      ],
      "bin": "etcdctl",
      "certificate": {
        "certificate_base64": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURIVENDQWdXZ0F3SUJBZ0lVVmlhMWZrWElsTXhGY2lob3lncWg2Yit6N0pNd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0hqRWNNQm9HQTFVRUF3d1RTVUpOSUVOc2IzVmtJRVJoZEdGaVlYTmxjekFlRncweE9ERXdNVEV4TkRRNApOVEZhRncweU9ERXdNRGd4TkRRNE5URmFNQjR4SERBYUJnTlZCQU1NRTBsQ1RTQkRiRzkxWkNCRVlYUmhZbUZ6ClpYTXdnZ0VpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFESkYxMlNjbTJGUmpQb2N1bmYKbmNkUkFMZDhJRlpiWDhpbDM3MDZ4UEV2b3ZpMTRHNGVIRWZuT1JRY2g3VElPR212RWxITVllbUtFT3Z3K0VZUApmOXpqU1IxNFVBOXJYeHVaQmgvZDlRa2pjTkw2YmMvbUNUOXpYbmpzdC9qRzJSbHdmRU1lZnVIQWp1T3c4bkJuCllQeFpiNm1ycVN6T2FtSmpnVVp6c1RMeHRId21yWkxuOGhlZnhITlBrdGFVMUtFZzNQRkJxaWpDMG9uWFpnOGMKanpZVVVXNkpBOWZZcWJBL1YxMkFsT3AvUXhKUVVoZlB5YXozN0FEdGpJRkYybkxVMjBicWdyNWhqTjA4SjZQUwpnUk5hNXc2T1N1RGZiZ2M4V3Z3THZzbDQvM281akFVSHp2OHJMaWF6d2VPYzlTcDBKd3JHdUJuYTFPYm9mbHU5ClM5SS9BZ01CQUFHalV6QlJNQjBHQTFVZERnUVdCQlJGejFFckZFSU1CcmFDNndiQjNNMHpuYm1IMmpBZkJnTlYKSFNNRUdEQVdnQlJGejFFckZFSU1CcmFDNndiQjNNMHpuYm1IMmpBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUEwRwpDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ2t4NVJzbk9PMWg0dFJxRzh3R21ub1EwOHNValpsRXQvc2tmR0pBL2RhClUveEZMMndhNjljTTdNR1VMRitoeXZYSEJScnVOTCtJM1ROSmtVUEFxMnNhakZqWEtCeVdrb0JYYnRyc2ZKckkKQWhjZnlzN29tdjJmb0pHVGxJY0FybnBCL0p1bEZITmM1YXQzVk1rSTlidEh3ZUlYNFE1QmdlVlU5cjdDdlArSgpWRjF0YWxSUVpKandyeVhsWGJvQ0c0MTU2TUtwTDIwMUwyV1dqazBydlBVWnRKcjhmTmd6M24wb0x5MFZ0Zm93Ck1yUFh4THk5TlBqOGlzT3V0ckxEMjlJWTJBMFY0UmxjSXhTMEw3c1ZPeTB6RDZwbXpNTVFNRC81aWZ1SVg2YnEKbEplZzV4akt2TytwbElLTWhPU1F5dTRUME1NeTZmY2t3TVpPK0liR3JDZHIKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=",
        "name": "45dc1d70-521a-11e9-8c84-3e25686eb210"
      },
      "composed": [
        "ETCDCTL_API=3 etcdctl --cacert=45dc1d70-521a-11e9-8c84-3e25686eb210 --endpoints=https://afc2bd38-f85c-4387-b5fc-f4642c7fcf7b.bc28ac43cf10402584b5f01db462d330.databases.appdomain.cloud:31190 --user=ibm_cloud_f59f3a7b_7578_4cf8_ba20_6df3b352ab46:230064666d4fe6d81f7c53a2c364fb60fa079773e8f9adbc163cb0b2e3c58142"
      ],
      "environment": {
        "ETCDCTL_API": "3"
      },
      "type": "cli"
    },
    "grpc": {
      "authentication": {
        "method": "direct",
        "password": "230064666d4fe6d81f7c53a2c364fb60fa079773e8f9adbc163cb0b2e3c58142",
        "username": "ibm_cloud_f59f3a7b_7578_4cf8_ba20_6df3b352ab46"
      },
      "certificate": {
        "certificate_base64": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURIVENDQWdXZ0F3SUJBZ0lVVmlhMWZrWElsTXhGY2lob3lncWg2Yit6N0pNd0RRWUpLb1pJaHZjTkFRRUwKQlFBd0hqRWNNQm9HQTFVRUF3d1RTVUpOSUVOc2IzVmtJRVJoZEdGaVlYTmxjekFlRncweE9ERXdNVEV4TkRRNApOVEZhRncweU9ERXdNRGd4TkRRNE5URmFNQjR4SERBYUJnTlZCQU1NRTBsQ1RTQkRiRzkxWkNCRVlYUmhZbUZ6ClpYTXdnZ0VpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFESkYxMlNjbTJGUmpQb2N1bmYKbmNkUkFMZDhJRlpiWDhpbDM3MDZ4UEV2b3ZpMTRHNGVIRWZuT1JRY2g3VElPR212RWxITVllbUtFT3Z3K0VZUApmOXpqU1IxNFVBOXJYeHVaQmgvZDlRa2pjTkw2YmMvbUNUOXpYbmpzdC9qRzJSbHdmRU1lZnVIQWp1T3c4bkJuCllQeFpiNm1ycVN6T2FtSmpnVVp6c1RMeHRId21yWkxuOGhlZnhITlBrdGFVMUtFZzNQRkJxaWpDMG9uWFpnOGMKanpZVVVXNkpBOWZZcWJBL1YxMkFsT3AvUXhKUVVoZlB5YXozN0FEdGpJRkYybkxVMjBicWdyNWhqTjA4SjZQUwpnUk5hNXc2T1N1RGZiZ2M4V3Z3THZzbDQvM281akFVSHp2OHJMaWF6d2VPYzlTcDBKd3JHdUJuYTFPYm9mbHU5ClM5SS9BZ01CQUFHalV6QlJNQjBHQTFVZERnUVdCQlJGejFFckZFSU1CcmFDNndiQjNNMHpuYm1IMmpBZkJnTlYKSFNNRUdEQVdnQlJGejFFckZFSU1CcmFDNndiQjNNMHpuYm1IMmpBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUEwRwpDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ2t4NVJzbk9PMWg0dFJxRzh3R21ub1EwOHNValpsRXQvc2tmR0pBL2RhClUveEZMMndhNjljTTdNR1VMRitoeXZYSEJScnVOTCtJM1ROSmtVUEFxMnNhakZqWEtCeVdrb0JYYnRyc2ZKckkKQWhjZnlzN29tdjJmb0pHVGxJY0FybnBCL0p1bEZITmM1YXQzVk1rSTlidEh3ZUlYNFE1QmdlVlU5cjdDdlArSgpWRjF0YWxSUVpKandyeVhsWGJvQ0c0MTU2TUtwTDIwMUwyV1dqazBydlBVWnRKcjhmTmd6M24wb0x5MFZ0Zm93Ck1yUFh4THk5TlBqOGlzT3V0ckxEMjlJWTJBMFY0UmxjSXhTMEw3c1ZPeTB6RDZwbXpNTVFNRC81aWZ1SVg2YnEKbEplZzV4akt2TytwbElLTWhPU1F5dTRUME1NeTZmY2t3TVpPK0liR3JDZHIKLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=",
        "name": "45dc1d70-521a-11e9-8c84-3e25686eb210"
      },
      "composed": [
        "https://ibm_cloud_f59f3a7b_7578_4cf8_ba20_6df3b352ab46:230064666d4fe6d81f7c53a2c364fb60fa079773e8f9adbc163cb0b2e3c58142@afc2bd38-f85c-4387-b5fc-f4642c7fcf7b.bc28ac43cf10402584b5f01db462d330.databases.appdomain.cloud:31190"
      ],
      "hosts": [
        {
          "hostname": "afc2bd38-f85c-4387-b5fc-f4642c7fcf7b.bc28ac43cf10402584b5f01db462d330.databases.appdomain.cloud",
          "port": 31190
        }
      ],
      "path": "",
      "query_options": {},
      "scheme": "https",
      "type": "uri"
    }
  },
  "instance_administration_api": {
    "deployment_id": "crn:v1:bluemix:public:databases-for-etcd:eu-de:a/a34b4e9ea7ab66770e048caf83277971:afc2bd38-f85c-4387-b5fc-f4642c7fcf7b::",
    "instance_id": "crn:v1:bluemix:public:databases-for-etcd:eu-de:a/a34b4e9ea7ab66770e048caf83277971:afc2bd38-f85c-4387-b5fc-f4642c7fcf7b::",
    "root": "https://api.eu-de.databases.cloud.ibm.com/v4/ibm"
  }
}
```

```python
!pip install etcd3
```
```python
Collecting etcd3
  Downloading https://files.pythonhosted.org/packages/9c/eb/6d1ef4d6a3e8b74e45c502cbd3ea6c5c6c786d003829db9369c2530f5e3f/etcd3-0.12.0.tar.gz (63kB)
     |████████████████████████████████| 71kB 20.2MB/s eta 0:00:01
Collecting grpcio>=1.27.1 (from etcd3)
  Downloading https://files.pythonhosted.org/packages/cd/04/2b67f0a3645481235d5547891fd0e45e384f1ae5676788f24a7c8735b4e9/grpcio-1.29.0-cp36-cp36m-manylinux2010_x86_64.whl (3.0MB)
     |████████████████████████████████| 3.0MB 23.4MB/s eta 0:00:01
Requirement already satisfied: protobuf>=3.6.1 in /opt/conda/envs/Python36/lib/python3.6/site-packages (from etcd3) (3.6.1)
Requirement already satisfied: six>=1.12.0 in /opt/conda/envs/Python36/lib/python3.6/site-packages (from etcd3) (1.12.0)
Collecting tenacity>=6.1.0 (from etcd3)
  Downloading https://files.pythonhosted.org/packages/b5/05/ff089032442058bd3386f9cd991cd88ccac81dca1494d78751621ee35e62/tenacity-6.2.0-py2.py3-none-any.whl
Requirement already satisfied: setuptools in /opt/conda/envs/Python36/lib/python3.6/site-packages (from protobuf>=3.6.1->etcd3) (40.8.0)
Building wheels for collected packages: etcd3
  Building wheel for etcd3 (setup.py) ... done
  Stored in directory: /home/dsxuser/.cache/pip/wheels/a8/36/b5/cabe849e7cb6e1c273ca48946b825d6f6f5271017c8497d7ea
Successfully built etcd3
ERROR: tensorflow 1.13.1 requires tensorboard<1.14.0,>=1.13.0, which is not installed.
Installing collected packages: grpcio, tenacity, etcd3
  Found existing installation: grpcio 1.16.1
    Uninstalling grpcio-1.16.1:
      Successfully uninstalled grpcio-1.16.1
Successfully installed etcd3-0.12.0 grpcio-1.29.0 tenacity-6.2.0
```
### How to connect to etcd using certyficate (part 1: prepare file with certificate)

```python
import base64
import tempfile

etcdHost = etcdCreds["connection"]["grpc"]["hosts"][0]["hostname"]
etcdPort = etcdCreds["connection"]["grpc"]["hosts"][0]["port"]
etcdUser = etcdCreds["connection"]["grpc"]["authentication"]["username"]
etcdPasswd = etcdCreds["connection"]["grpc"]["authentication"]["password"]
etcdCertBase64 = etcdCreds["connection"]["grpc"]["certificate"]["certificate_base64"]
                           
etcdCertDecoded = base64.b64decode(etcdCertBase64)
etcdCertPath = "{}/{}.cert".format(tempfile.gettempdir(), etcdUser)
                           
with open(etcdCertPath, 'wb') as f:
    f.write(etcdCertDecoded)

print(etcdCertPath)
```

### Short Lab description

During the lab we will simulate system that keeps track of logged users
- All users will be stored under parent key (path): /logged_users
- Each user will be represented by key value pair
    - key /logged_users/name_of_the_user
    - value hostname of the machine (e.g. name_of_the_user-hostname)


### How to connect to etcd using certyficate (part 2: create client)

```python
import etcd3

etcd = etcd3.client(
    host=etcdHost,
    port=etcdPort,
    user=etcdUser,
    password=etcdPasswd,
    ca_cert=etcdCertPath
)

cfgRoot='/logged_users'
```

### Task 1 : Fetch username and hostname

define two variables
- username name of the logged user (tip: use getpass library)
- hostname hostname of your mcomputer (tip: use socket library)

```python
import getpass
import socket

# username = getpass.getuser()# You can put your name here, while this code is run in the container and user name would be same for all students
username = 'szarbartosz'
hostname = socket.gethostname()

userKey='{}/{}'.format(cfgRoot, username)
userKey, '->', hostname
```

### Task 2 : Register number of users 

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

for all names in table fixedUsers register the appropriate key value pairs

```python
fixedUsers = [
    'Adam',
    'Borys',
    'Cezary',
    'Damian',
    'Emil',
    'Filip',
    'Gustaw',
    'Henryk',
    'Ignacy',
    'Jacek',
    'Kamil',
    'Leon',
    'Marek',
    'Norbert',
    'Oskar',
    'Patryk',
    'Rafał',
    'Stefan',
    'Tadeusz'
]

for user in fixedUsers:
    etcd.put(f'{cfgRoot}/{username}/{user}', f'{hostname}')
    
# i = 1
# for user in fixedUsers:
#     etcd.put(f'{cfgRoot}/{username}/{i}', f'{user}')
#     i += 1

for user in fixedUsers:
    value, metadata = etcd.get(f'{cfgRoot}/{username}/{user}')
    print(metadata.key.decode('utf-8'))
#     print(value.decode('utf-8'), '\n')

```

### Task 3: List all users

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

List all registered user (tip: use common prefix)

```python
results = etcd.get_prefix(f'{cfgRoot}')
{metadata.key.decode('utf-8'): value.decode('utf-8') for value, metadata in results}
```

### Task 4 : Same as Task2, but use transaction

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

for all names in table fixedUsers register the appropriate key value pairs, use transaction to make it a single request  
(Have you noticed any difference in execution time?)

```python
etcd.transaction(
    compare=[],
    success=[etcd.transactions.put(f'{cfgRoot}/{username}/{user}', f'{user}') for user in fixedUsers],
    failure=[]
)

results = etcd.get_prefix(f'{cfgRoot}/{username}/')
{metadata.key.decode('utf-8') : value.decode('utf-8') for value, metadata in results}
```

### Task 5 : Get single key (e.g. status of transaction)

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

Check the key you are modifying in on-failure handler in previous task

```python
for i in etcd.get_prefix('/tmp/failure'):
    print(i)
```

### Task 6 : Get range of Keys (Emil -> Oskar) 

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

- Get range of keys
- Is it inclusive / exclusive?
- Sort the resposne descending
- Sort the resposne descending by value not by key

```python
results = etcd.get_range(f'{cfgRoot}/{username}/Emil', f'{cfgRoot}/{username}/Oskar', sort_order='descend')
for result in results:
    print(result[1].key.decode('utf-8') + ' - ' + result[0].decode('utf-8'))
```

### Task 7: Atomic Replace

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

Do it a few times, check if value has been replaced depending on condition

```python
etcd.transaction(
        compare=[],
        success=[etcd.transactions.put('{}/{}'.format(cfgRoot, user), 'user-2-{}'.format(user)) for user in fixedUsers],
        failure=[]
    )

for user in fixedUsers:
    result = etcd.replace('{}/{}'.format(cfgRoot, user), 'user-2-{}'.format(user), 'user-3-{}'.format(user))
    print(f'{user}: {result}')

for user in fixedUsers:
    result = etcd.replace('{}/{}'.format(cfgRoot, user), 'user-2-{}'.format(user), 'user-3-{}'.format(user))
    print(f'{user}: {result}')
```

### Task 8 : Create lease - use it to create expiring key

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

You can create a key that will be for limited time
add user that will expire after a few seconds

Tip: Use lease


```python
import time

lease = etcd.lease(4)
etcd.put(f'{cfgRoot}/{username}/USER', 'something', lease=lease)
value, meta = etcd.get(f'{cfgRoot}/{username}/USER')
print(meta.key.decode('utf-8') + " : " + value.decode('utf-8'))
print('leased key: ', str(etcd.get(f'{cfgRoot}/{username}/USER')))
time.sleep(6)
print('leased key: ', str(etcd.get(f'{cfgRoot}/{username}/USER')))
```

### Task 9 : Create key that will expire after you close the connection to etcd

Tip: use threading library to refresh your lease

```python
import threading

lease = etcd.lease(ttl=5)

def refresh_lease():
    while True:
        lease.refresh()
        time.sleep(1)

key=f'{cfgRoot}/{username}/to-refresh'
val=f'value'


etcd.put(key, val, lease=lease)

t = threading.Thread(target=refresh_lease)
t.start()

print(etcd.get(key))
time.sleep(16)
print(etcd.get(key))
```

### Task 10: Use lock to protect section of code

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

```python
with etcd.lock('lock-2', ttl=10) as lock:
    print('a')
    print(f'Is acquaired? {lock.is_acquired()}')
    lock.acquire()
    print('b')
    time.sleep(3)
    print('c')
    lock.release()
```

### Task 11: Watch key

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

This cell will lock this notebook on waiting  
After running it create a new notebook and try to add new user

```python
def etcd_call(cb):
    print(cb)

etcd.put('/test/test', 'test')
etcd.add_watch_callback(key='/test/test', callback=etcd_call)
```

```python

```
