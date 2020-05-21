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

```python
/home/dsxuser/.tmp/ibm_cloud_f59f3a7b_7578_4cf8_ba20_6df3b352ab46.cert
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

```python
('/logged_users/szarbartosz',
 '->',
 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf')
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

```python
/logged_users/szarbartosz/Adam
/logged_users/szarbartosz/Borys
/logged_users/szarbartosz/Cezary
/logged_users/szarbartosz/Damian
/logged_users/szarbartosz/Emil
/logged_users/szarbartosz/Filip
/logged_users/szarbartosz/Gustaw
/logged_users/szarbartosz/Henryk
/logged_users/szarbartosz/Ignacy
/logged_users/szarbartosz/Jacek
/logged_users/szarbartosz/Kamil
/logged_users/szarbartosz/Leon
/logged_users/szarbartosz/Marek
/logged_users/szarbartosz/Norbert
/logged_users/szarbartosz/Oskar
/logged_users/szarbartosz/Patryk
/logged_users/szarbartosz/Rafał
/logged_users/szarbartosz/Stefan
/logged_users/szarbartosz/Tadeusz
```

### Task 3: List all users

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

List all registered user (tip: use common prefix)

```python
results = etcd.get_prefix(f'{cfgRoot}')
{metadata.key.decode('utf-8'): value.decode('utf-8') for value, metadata in results}
```

```python
{'/logged_users': '/logged_users/Tadeusz - Registered',
 '/logged_users//logged_users': 'notebook-438cad81f4974877a0c254a6d6ff0145-58f95b7948-zfpxd',
 '/logged_users/0': 'Adam',
 '/logged_users/1': 'Borys',
 '/logged_users/10': 'Kamil',
 '/logged_users/11': 'Leon',
 '/logged_users/12': 'Marek',
 '/logged_users/13': 'Norbert',
 '/logged_users/14': 'Oskar',
 '/logged_users/15': 'Patryk',
 '/logged_users/16': 'Rafał',
 '/logged_users/17': 'Stefan',
 '/logged_users/18': 'Tadeusz',
 '/logged_users/2': 'Cezary',
 '/logged_users/3': 'Damian',
 '/logged_users/4': 'Emil',
 '/logged_users/5': 'Filip',
 '/logged_users/6': 'Gustaw',
 '/logged_users/7': 'Henryk',
 '/logged_users/8': 'Ignacy',
 '/logged_users/9': 'Jacek',
 '/logged_users/Adam': 'user-Adam',
 '/logged_users/Adam_Adam': 'Adam-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Borys': 'Borys-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Cezary': 'Cezary-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Damian': 'Damian-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Emil': 'Emil-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Filip': 'Filip-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Gustaw': 'Gustaw-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Henryk': 'Henryk-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Ignacy': 'Ignacy-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Jacek': 'Jacek-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Kamil': 'Kamil-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Leon': 'Leon-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Marek': 'Marek-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Norbert': 'Norbert-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Oskar': 'Oskar-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Patryk': 'Patryk-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Rafał': 'Rafał-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Stefan': 'Stefan-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Adam_Tadeusz': 'Tadeusz-notebook-809faba2080d4f76866c72d4e333de78-5d89c844b6-77d6k',
 '/logged_users/Agata Cyra': 'notebook-b817ce8c6ae5412a9750676d8ba98fd6-6499896847-xmtv8',
 '/logged_users/Andrii': 'notebook-75760867122b4b86a5bbcd2f5ccc321b-66fd799d96-dc62c',
 '/logged_users/Borys': 'user-Borys',
 '/logged_users/Cezary': 'user-Cezary',
 '/logged_users/Damian': 'user-Damian',
 '/logged_users/Dawid': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Adam': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Andrzej': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Borys': 'updated_value',
 '/logged_users/Dawid/Cezary': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Damian': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Emil': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Filip': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Gustaw': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Henryk': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Ignacy': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Jacek': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Jaroslaw': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Kamil': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Leon': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Marek': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Norbert': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Oskar': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Patryk': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Rafał': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Stefan': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Tadeusz': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Adam': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Borys': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Cezary': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Damian': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Emil': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Filip': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Gustaw': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Henryk': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Ignacy': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Jacek': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Kamil': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Leon': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Marek': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Norbert': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Oskar': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Patryk': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Rafał': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Stefan': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Trans/Tadeusz': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Wieslaw': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Dawid/Zbyszek': 'notebook-a44d382faeed459cb058c7e5432b8e8c-c5c54fd59-bxlrd',
 '/logged_users/Emil': 'user-Emil',
 '/logged_users/Filip': 'user-Filip',
 '/logged_users/Filip2': 'testmessage3',
 '/logged_users/Gaben/Adam': 'test_9',
 '/logged_users/Gaben/Borys': 'Borys-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Cezary': 'Cezary-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Damian': 'Damian-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Emil': 'Emil-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Filip': 'Filip-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Gustaw': 'Gustaw-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Henryk': 'Henryk-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Ignacy': 'Ignacy-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Jacek': 'Jacek-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Kamil': 'Kamil-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Leon': 'Leon-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Marek': 'Marek-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Norbert': 'Norbert-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Oskar': 'Oskar-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Patryk': 'Patryk-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Rafał': 'Rafał-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Stefan': 'Stefan-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/Tadeusz': 'Tadeusz-notebook-condafree1py3621c9aec184684c4586519a69becb7bf2-785r4k8',
 '/logged_users/Gaben/errors': 'condition failed',
 '/logged_users/Gaben/mama': 'kochana',
 '/logged_users/GargasJan': 'notebook-a7823551d9b84fd3b085958036c5f597-d469f8875-ltf7p',
 '/logged_users/Gustaw': 'user-Gustaw',
 '/logged_users/Henryk': 'user-Henryk',
 '/logged_users/Hubert/Adam': 'Adamnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Borys': 'Borysnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Cezary': 'Cezarynotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Damian': 'Damiannotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Emil': 'Emilnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Filip': 'Filipnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Gustaw': 'Gustawnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Henryk': 'Henryknotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Ignacy': 'Ignacynotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Jacek': 'Jaceknotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Kamil': 'Kamilnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Leon': 'Leonnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Marek': 'new_hostname',
 '/logged_users/Hubert/Norbert': 'Norbertnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Oskar': 'Oskarnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Patryk': 'Patryknotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Rafał': 'Rafałnotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Stefan': 'Stefannotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Hubert/Tadeusz': 'Tadeusznotebook-66c43e4471114fa295d284b8afdefbb0-58bc66c8d6-9bxrd',
 '/logged_users/Ignacy': 'user-Ignacy',
 '/logged_users/Jacek': 'user-Jacek',
 '/logged_users/Jakub Mysliwiec': 'notebook-condafree1py3690879dede28a40ed88e530f26cab9341-6cpwqdw',
 '/logged_users/JakubPerzylo/0': 'Adam',
 '/logged_users/JakubPerzylo/1': 'Borys',
 '/logged_users/JakubPerzylo/10': 'Kamil',
 '/logged_users/JakubPerzylo/11': 'Leon',
 '/logged_users/JakubPerzylo/12': 'Marek',
 '/logged_users/JakubPerzylo/13': 'Norbert',
 '/logged_users/JakubPerzylo/14': 'Oskar',
 '/logged_users/JakubPerzylo/15': 'Patryk',
 '/logged_users/JakubPerzylo/16': 'Rafał',
 '/logged_users/JakubPerzylo/17': 'Stefan',
 '/logged_users/JakubPerzylo/18': 'Tadeusz',
 '/logged_users/JakubPerzylo/2': 'Cezary',
 '/logged_users/JakubPerzylo/3': 'Damian',
 '/logged_users/JakubPerzylo/4': 'Emil',
 '/logged_users/JakubPerzylo/5': 'Filip',
 '/logged_users/JakubPerzylo/6': 'Gustaw',
 '/logged_users/JakubPerzylo/7': 'Henryk',
 '/logged_users/JakubPerzylo/8': 'Ignacy',
 '/logged_users/JakubPerzylo/9': 'Jacek',
 '/logged_users/JakubPerzylo/Adam': 'Adam',
 '/logged_users/JakubPerzylo/Borys': 'Borys',
 '/logged_users/JakubPerzylo/Cezary': 'Cezary',
 '/logged_users/JakubPerzylo/Damian': 'Damian',
 '/logged_users/JakubPerzylo/Emil': 'Emil',
 '/logged_users/JakubPerzylo/Filip': 'Filip',
 '/logged_users/JakubPerzylo/Gustaw': 'Gustaw',
 '/logged_users/JakubPerzylo/Henryk': 'Henryk godlike',
 '/logged_users/JakubPerzylo/Ignacy': 'Ignacy',
 '/logged_users/JakubPerzylo/Jacek': 'Jacek',
 '/logged_users/JakubPerzylo/Kamil': 'Kamil',
 '/logged_users/JakubPerzylo/Leon': 'Leon',
 '/logged_users/JakubPerzylo/Marek': 'Marek',
 '/logged_users/JakubPerzylo/Norbert': 'Norbert',
 '/logged_users/JakubPerzylo/Oskar': 'Oskar',
 '/logged_users/JakubPerzylo/Patryk': 'Patryk',
 '/logged_users/JakubPerzylo/Rafał': 'Rafał',
 '/logged_users/JakubPerzylo/Stefan': 'Stefan',
 '/logged_users/JakubPerzylo/Tadeusz': 'Tadeusz',
 '/logged_users/JakubPerzylo/transaction': 'condition failed',
 '/logged_users/JakubPerzylo/transaction/0': 'Adam',
 '/logged_users/JakubPerzylo/transaction/1': 'Borys',
 '/logged_users/JakubPerzylo/transaction/10': 'Kamil',
 '/logged_users/JakubPerzylo/transaction/11': 'Leon',
 '/logged_users/JakubPerzylo/transaction/12': 'Marek',
 '/logged_users/JakubPerzylo/transaction/13': 'Norbert',
 '/logged_users/JakubPerzylo/transaction/14': 'Oskar',
 '/logged_users/JakubPerzylo/transaction/15': 'Patryk',
 '/logged_users/JakubPerzylo/transaction/16': 'Rafał',
 '/logged_users/JakubPerzylo/transaction/17': 'Stefan',
 '/logged_users/JakubPerzylo/transaction/18': 'Tadeusz',
 '/logged_users/JakubPerzylo/transaction/2': 'Cezary',
 '/logged_users/JakubPerzylo/transaction/3': 'Damian',
 '/logged_users/JakubPerzylo/transaction/4': 'Emil',
 '/logged_users/JakubPerzylo/transaction/5': 'Filip',
 '/logged_users/JakubPerzylo/transaction/6': 'Gustaw',
 '/logged_users/JakubPerzylo/transaction/7': 'Henryk',
 '/logged_users/JakubPerzylo/transaction/8': 'Ignacy',
 '/logged_users/JakubPerzylo/transaction/9': 'Jacek',
 '/logged_users/Kamil': 'user-Kamil',
 '/logged_users/KamilKoczera': 'KamilKoczera-hostname',
 '/logged_users/KamilKoczera/Adam': 'Adam',
 '/logged_users/KamilKoczera/Borys': 'Borys',
 '/logged_users/KamilKoczera/Cezary': 'Cezary',
 '/logged_users/KamilKoczera/Damian': 'Damian',
 '/logged_users/KamilKoczera/Emil': 'Emil',
 '/logged_users/KamilKoczera/Filip': 'Filip',
 '/logged_users/KamilKoczera/Gustaw': 'Gustaw',
 '/logged_users/KamilKoczera/Henryk': 'Henryk',
 '/logged_users/KamilKoczera/Ignacy': 'Ignacy',
 '/logged_users/KamilKoczera/Jacek': 'Jacek',
 '/logged_users/KamilKoczera/Kamil': 'Kamil',
 '/logged_users/KamilKoczera/Leon': 'Leon',
 '/logged_users/KamilKoczera/Marek': 'Marek',
 '/logged_users/KamilKoczera/Norbert': 'Norbert',
 '/logged_users/KamilKoczera/Oskar': 'Oskar',
 '/logged_users/KamilKoczera/Patryk': 'Patryk',
 '/logged_users/KamilKoczera/Rafał': 'Rafał',
 '/logged_users/KamilKoczera/Stefan': 'Stefan',
 '/logged_users/KamilKoczera/Tadeusz': 'Tadeusz',
 '/logged_users/KamilKoczera/data': 'KamilKoczera-hostname',
 '/logged_users/KamilKoczera/key_m_0': 'Adam_transaction',
 '/logged_users/KamilKoczera/key_m_1': 'Borys_transaction',
 '/logged_users/KamilKoczera/key_m_10': 'Kamil_transaction',
 '/logged_users/KamilKoczera/key_m_11': 'Leon_transaction',
 '/logged_users/KamilKoczera/key_m_12': 'Marek_transaction',
 '/logged_users/KamilKoczera/key_m_13': 'Norbert_transaction',
 '/logged_users/KamilKoczera/key_m_14': 'Oskar_transaction',
 '/logged_users/KamilKoczera/key_m_15': 'Patryk_transaction',
 '/logged_users/KamilKoczera/key_m_16': 'Rafał_transaction',
 '/logged_users/KamilKoczera/key_m_17': 'Stefan_transaction',
 '/logged_users/KamilKoczera/key_m_18': 'Tadeusz_transaction',
 '/logged_users/KamilKoczera/key_m_2': 'Cezary_transaction',
 '/logged_users/KamilKoczera/key_m_3': 'Damian_transaction',
 '/logged_users/KamilKoczera/key_m_4': 'Emil_transaction',
 '/logged_users/KamilKoczera/key_m_5': 'Filip_transaction',
 '/logged_users/KamilKoczera/key_m_6': 'Gustaw_transaction',
 '/logged_users/KamilKoczera/key_m_7': 'Henryk_transaction',
 '/logged_users/KamilKoczera/key_m_8': 'Ignacy_transaction',
 '/logged_users/KamilKoczera/key_m_9': 'Jacek_transaction',
 '/logged_users/KamilKoczera/names/': 'test',
 '/logged_users/KamilKoczera/names/Adam': 'Adam',
 '/logged_users/KamilKoczera/names/Borys': 'Borys',
 '/logged_users/KamilKoczera/names/Cezary': 'Cezary',
 '/logged_users/KamilKoczera/names/Damian': 'Damian',
 '/logged_users/KamilKoczera/names/Emil': 'Emil_atomic',
 '/logged_users/KamilKoczera/names/Filip': 'Filip',
 '/logged_users/KamilKoczera/names/Gustaw': 'Gustaw',
 '/logged_users/KamilKoczera/names/Henryk': 'Henryk',
 '/logged_users/KamilKoczera/names/Ignacy': 'Ignacy',
 '/logged_users/KamilKoczera/names/Jacek': 'Jacek',
 '/logged_users/KamilKoczera/names/Kamil': 'Kamil',
 '/logged_users/KamilKoczera/names/Leon': 'Leon',
 '/logged_users/KamilKoczera/names/Marek': 'Marek',
 '/logged_users/KamilKoczera/names/Norbert': 'Norbert',
 '/logged_users/KamilKoczera/names/Oskar': 'Oskar',
 '/logged_users/KamilKoczera/names/Patryk': 'Patryk',
 '/logged_users/KamilKoczera/names/Rafał': 'Rafał',
 '/logged_users/KamilKoczera/names/Stefan': 'Stefan',
 '/logged_users/KamilKoczera/names/Tadeusz': 'Tadeusz',
 '/logged_users/KamilKoczeraAdam': 'Adam',
 '/logged_users/KamilKoczeraBorys': 'Borys',
 '/logged_users/KamilKoczeraCezary': 'Cezary',
 '/logged_users/KamilKoczeraDamian': 'Damian',
 '/logged_users/KamilKoczeraEmil': 'Emil',
 '/logged_users/KamilKoczeraFilip': 'Filip',
 '/logged_users/KamilKoczeraGustaw': 'Gustaw',
 '/logged_users/KamilKoczeraHenryk': 'Henryk',
 '/logged_users/KamilKoczeraIgnacy': 'Ignacy',
 '/logged_users/KamilKoczeraJacek': 'Jacek',
 '/logged_users/KamilKoczeraKamil': 'Kamil',
 '/logged_users/KamilKoczeraLeon': 'Leon',
 '/logged_users/KamilKoczeraMarek': 'Marek',
 '/logged_users/KamilKoczeraNorbert': 'Norbert',
 '/logged_users/KamilKoczeraOskar': 'Oskar',
 '/logged_users/KamilKoczeraPatryk': 'Patryk',
 '/logged_users/KamilKoczeraRafał': 'Rafał',
 '/logged_users/KamilKoczeraStefan': 'Stefan',
 '/logged_users/KamilKoczeraTadeusz': 'Tadeusz',
 '/logged_users/KamilKoczeranames': 'Tadeusz',
 '/logged_users/Kocimski/Adam': 'Adam',
 '/logged_users/Kocimski/Borys': 'Borys',
 '/logged_users/Kocimski/Cezary': 'Cezary',
 '/logged_users/Kocimski/Damian': 'Damian',
 '/logged_users/Kocimski/Emil': 'Emil',
 '/logged_users/Kocimski/Filip': 'Filip',
 '/logged_users/Kocimski/Gustaw': 'Gustaw',
 '/logged_users/Kocimski/Henryk': 'Henryk',
 '/logged_users/Kocimski/Ignacy': 'Ignacy',
 '/logged_users/Kocimski/Jacek': 'Kazimierz',
 '/logged_users/Kocimski/Kamil': 'Kamil',
 '/logged_users/Kocimski/Leon': 'Leon',
 '/logged_users/Kocimski/Marek': 'Marek',
 '/logged_users/Kocimski/Norbert': 'Norbert',
 '/logged_users/Kocimski/Oskar': 'Oskar',
 '/logged_users/Kocimski/Patryk': 'Patryk',
 '/logged_users/Kocimski/Rafał': 'Rafał',
 '/logged_users/Kocimski/Stefan': 'Stefan',
 '/logged_users/Kocimski/Tadeusz': 'Tadeusz',
 '/logged_users/Krzysztof-Hardek/Adam': 'Adam',
 '/logged_users/Krzysztof-Hardek/Borys': 'Borys',
 '/logged_users/Krzysztof-Hardek/Cezary': 'Cezary',
 '/logged_users/Krzysztof-Hardek/Damian': 'Damian',
 '/logged_users/Krzysztof-Hardek/Emil': 'Emil',
 '/logged_users/Krzysztof-Hardek/Filip': 'Filip',
 '/logged_users/Krzysztof-Hardek/Gustaw': 'Gustaw',
 '/logged_users/Krzysztof-Hardek/Henryk': 'Henryk',
 '/logged_users/Krzysztof-Hardek/Ignacy': 'Ignacy',
 '/logged_users/Krzysztof-Hardek/Jacek': 'Jacek',
 '/logged_users/Krzysztof-Hardek/Kamil': 'Kamil',
 '/logged_users/Krzysztof-Hardek/Leon': 'Leon',
 '/logged_users/Krzysztof-Hardek/Marek': 'Marek',
 '/logged_users/Krzysztof-Hardek/Norbert': 'Norbert',
 '/logged_users/Krzysztof-Hardek/Oskar': 'Oskar',
 '/logged_users/Krzysztof-Hardek/Patryk': 'Patryk',
 '/logged_users/Krzysztof-Hardek/Rafał': 'Rafał',
 '/logged_users/Krzysztof-Hardek/Stefan': 'Stefan',
 '/logged_users/Krzysztof-Hardek/Tadeusz': 'Tadeusz',
 '/logged_users/Kurleto/Adam': 'Adam-hostname',
 '/logged_users/Kurleto/Borys': 'Borys-hostname',
 '/logged_users/Kurleto/Cezary': 'Cezary-hostname',
 '/logged_users/Kurleto/Damian': 'Damian-hostname',
 '/logged_users/Kurleto/Emil': 'Emil-hostname',
 '/logged_users/Kurleto/Filip': 'Filip-hostname',
 '/logged_users/Kurleto/Gustaw': 'Gustaw-hostname',
 '/logged_users/Kurleto/Henryk': 'Henryk-hostname',
 '/logged_users/Kurleto/Ignacy': 'Ignacy-hostname',
 '/logged_users/Kurleto/Jacek': 'Jacek-hostname',
 '/logged_users/Kurleto/Kamil': 'Kamil-hostname',
 '/logged_users/Kurleto/Leon': 'Leon-hostname',
 '/logged_users/Kurleto/Marek': 'Marek-hostname',
 '/logged_users/Kurleto/Norbert': 'Norbert-hostname',
 '/logged_users/Kurleto/Oskar': 'Oskar-hostname',
 '/logged_users/Kurleto/Patryk': 'Patryk-hostname',
 '/logged_users/Kurleto/Rafał': 'Rafał-hostname',
 '/logged_users/Kurleto/Stefan': 'Stefan-hostname',
 '/logged_users/Kurleto/Tadeusz': 'Tadeusz-hostname',
 '/logged_users/Lechowicz': 'notebook-condafree1py3681d3d2d480474a18b8276572c8600ae7-68hmpxx',
 '/logged_users/Leon': 'user-Leon',
 '/logged_users/MKurleto//Adam': 'Adam-hostname',
 '/logged_users/MKurleto//Borys': 'Borys-hostname',
 '/logged_users/MKurleto//Cezary': 'Cezary-hostname',
 '/logged_users/MKurleto//Damian': 'Damian-hostname',
 '/logged_users/MKurleto//Emil': 'Emil-hostname',
 '/logged_users/MKurleto//Filip': 'Filip-hostname',
 '/logged_users/MKurleto//Gustaw': 'Gustaw-hostname',
 '/logged_users/MKurleto//Henryk': 'Henryk-hostname',
 '/logged_users/MKurleto//Ignacy': 'Ignacy-hostname',
 '/logged_users/MKurleto//Jacek': 'Jacek-hostname',
 '/logged_users/MKurleto//Kamil': 'Kamil-hostname',
 '/logged_users/MKurleto//Leon': 'Leon-hostname',
 '/logged_users/MKurleto//Marek': 'Marek-hostname',
 '/logged_users/MKurleto//Norbert': 'Norbert-hostname',
 '/logged_users/MKurleto//Oskar': 'Oskar-hostname',
 '/logged_users/MKurleto//Patryk': 'Patryk-hostname',
 '/logged_users/MKurleto//Rafał': 'Rafał-hostname',
 '/logged_users/MKurleto//Stefan': 'Stefan-hostname',
 '/logged_users/MKurleto//Tadeusz': 'Tadeusz-hostname',
 '/logged_users/MKurleto/Adam': 'Adam-hostname',
 '/logged_users/MKurleto/Borys': 'Borys-hostname',
 '/logged_users/MKurleto/Cezary': 'Cezary-hostname',
 '/logged_users/MKurleto/Damian': 'Damian-hostname',
 '/logged_users/MKurleto/Emil': 'Emil-hostname',
 '/logged_users/MKurleto/Filip': 'Filip-hostname',
 '/logged_users/MKurleto/Gustaw': 'Gustaw-hostname',
 '/logged_users/MKurleto/Henryk': 'Henryk-hostname',
 '/logged_users/MKurleto/Ignacy': 'Ignacy-hostname',
 '/logged_users/MKurleto/Jacek': 'Jacek-hostname',
 '/logged_users/MKurleto/Kamil': 'Kamil-hostname',
 '/logged_users/MKurleto/Leon': 'Leon-hostname',
 '/logged_users/MKurleto/Marek': 'Marek-hostname',
 '/logged_users/MKurleto/Norbert': 'Norbert-hostname',
 '/logged_users/MKurleto/Oskar': 'Oskar-hostname',
 '/logged_users/MKurleto/Patryk': 'Patryk-hostname',
 '/logged_users/MKurleto/Rafał': 'Rafał-hostname',
 '/logged_users/MKurleto/Stefan': 'Stefan-hostname',
 '/logged_users/MKurleto/Tadeusz': 'Tadeusz-hostname',
 '/logged_users/MKurletoAdam': 'Adam-hostname',
 '/logged_users/MKurletoBorys': 'Borys-hostname',
 '/logged_users/MKurletoCezary': 'Cezary-hostname',
 '/logged_users/MKurletoDamian': 'Damian-hostname',
 '/logged_users/MKurletoEmil': 'Emil-hostname',
 '/logged_users/MKurletoFilip': 'Filip-hostname',
 '/logged_users/MKurletoGustaw': 'Gustaw-hostname',
 '/logged_users/MKurletoHenryk': 'Henryk-hostname',
 '/logged_users/MKurletoIgnacy': 'Ignacy-hostname',
 '/logged_users/MKurletoJacek': 'Jacek-hostname',
 '/logged_users/MKurletoKamil': 'Kamil-hostname',
 '/logged_users/MKurletoLeon': 'Leon-hostname',
 '/logged_users/MKurletoMarek': 'Marek-hostname',
 '/logged_users/MKurletoNorbert': 'Norbert-hostname',
 '/logged_users/MKurletoOskar': 'Oskar-hostname',
 '/logged_users/MKurletoPatryk': 'Patryk-hostname',
 '/logged_users/MKurletoRafał': 'Rafał-hostname',
 '/logged_users/MKurletoStefan': 'Stefan-hostname',
 '/logged_users/MKurletoTadeusz': 'Tadeusz-hostname',
 '/logged_users/Marek': 'user-Marek',
 '/logged_users/Maria/Adam': 'Adam',
 '/logged_users/Maria/Borys': 'Borys',
 '/logged_users/Maria/Cezary': 'Cezary',
 '/logged_users/Maria/Damian': 'Damian',
 '/logged_users/Maria/Emil': 'Emil',
 '/logged_users/Maria/Filip': 'Filip',
 '/logged_users/Maria/Gustaw': 'Gustaw',
 '/logged_users/Maria/Henryk': 'Henryk',
 '/logged_users/Maria/Ignacy': 'Ignacy',
 '/logged_users/Maria/Jacek': 'Jacek',
 '/logged_users/Maria/Kamil': 'Kamil',
 '/logged_users/Maria/Leon': 'Leon',
 '/logged_users/Maria/Marek': 'Marek',
 '/logged_users/Maria/Norbert': 'Norbert',
 '/logged_users/Maria/Oskar': 'Oskar',
 '/logged_users/Maria/Patryk': 'Patryk',
 '/logged_users/Maria/Rafał': 'Rafał',
 '/logged_users/Maria/Stefan': 'Stefan',
 '/logged_users/Maria/Tadeusz': 'Tadeusz',
 '/logged_users/Maria/status/failure': 'condtion failed',
 '/logged_users/MichalW/users': 'Tadeusz',
 '/logged_users/MichalW/users/Adam': 'Adam-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Borys': 'Borys-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Cezary': 'Cezary-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Damian': 'Damian-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Emil': 'Emil-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Filip': 'Filip-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Gustaw': 'Gustaw-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Henryk': 'Henryk-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Ignacy': 'Ignacy-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Jacek': 'Jacek-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Kamil': 'Kamil-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Leon': 'Leon-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Marek': 'Marek-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Michau': 'Michau-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Norbert': 'Norbert-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Oskar': 'Oskar-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Patryk': 'Patryk-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Rafał': 'Rafał-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Stefan': 'Stefan-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/MichalW/users/Tadeusz': 'Tadeusz-notebook-3dd95954209d46018d78a714da459b6a-545894974-srlx9',
 '/logged_users/Name_with_lease_thread': 'LEASE_REF',
 '/logged_users/NewUser': 'value_NewUser_from_another_notebook',
 '/logged_users/Niechaj': 'Tadeusz',
 '/logged_users/Niechaj/key_n_0': 'Adam',
 '/logged_users/Niechaj/key_n_1': 'Borys',
 '/logged_users/Niechaj/key_n_10': 'Kamil',
 '/logged_users/Niechaj/key_n_11': 'Leon',
 '/logged_users/Niechaj/key_n_12': 'Marek',
 '/logged_users/Niechaj/key_n_13': 'Norbert',
 '/logged_users/Niechaj/key_n_14': 'Oskar',
 '/logged_users/Niechaj/key_n_15': 'Patryk',
 '/logged_users/Niechaj/key_n_16': 'Rafał',
 '/logged_users/Niechaj/key_n_17': 'Stefan',
 '/logged_users/Niechaj/key_n_18': 'Tadeusz',
 '/logged_users/Niechaj/key_n_2': 'Cezary',
 '/logged_users/Niechaj/key_n_3': 'Damian',
 '/logged_users/Niechaj/key_n_4': 'Emil',
 '/logged_users/Niechaj/key_n_5': 'Filip',
 '/logged_users/Niechaj/key_n_6': 'Gustaw',
 '/logged_users/Niechaj/key_n_7': 'Henryk',
 '/logged_users/Niechaj/key_n_8': 'Ignacy',
 '/logged_users/Niechaj/key_n_9': 'Jacek',
 '/logged_users/Norbert': 'user-Norbert',
 '/logged_users/NotWatchedKey': 'value first',
 '/logged_users/Oskar': 'user-Oskar',
 '/logged_users/Patryk': 'user-Patryk',
 '/logged_users/Patryk/key': 'value',
 '/logged_users/PatrykSkupien/Adam': 'value_Adam',
 '/logged_users/PatrykSkupien/Borys': 'value_Borys',
 '/logged_users/PatrykSkupien/Cezary': 'value_Cezary',
 '/logged_users/PatrykSkupien/Damian': 'value_Damian',
 '/logged_users/PatrykSkupien/Emil': 'value_Emil',
 '/logged_users/PatrykSkupien/Filip': 'value_Filip',
 '/logged_users/PatrykSkupien/Gustaw': 'value_Gustaw',
 '/logged_users/PatrykSkupien/Henryk': 'value_Henryk',
 '/logged_users/PatrykSkupien/Ignacy': 'value_Ignacy',
 '/logged_users/PatrykSkupien/Jacek': 'value_Jacek',
 '/logged_users/PatrykSkupien/Kamil': 'value_Kamil',
 '/logged_users/PatrykSkupien/Leon': 'value_Leon',
 '/logged_users/PatrykSkupien/Marek': 'value_Marek',
 '/logged_users/PatrykSkupien/NewUser': 'value_NewUser_from_another_notebook',
 '/logged_users/PatrykSkupien/Norbert': 'value_Norbert',
 '/logged_users/PatrykSkupien/Oskar': 'value_Oskar',
 '/logged_users/PatrykSkupien/Oskar_sustained': 'value_Oskar_sustained',
 '/logged_users/PatrykSkupien/Patryk': 'value_Patryk',
 '/logged_users/PatrykSkupien/Rafał': 'value_Rafał',
 '/logged_users/PatrykSkupien/Stefan': 'value_Stefan',
 '/logged_users/PatrykSkupien/Tadeusz': 'value_Tadeusz',
 '/logged_users/Paweł Pławecki': 'notebook-3ab835e76fd842e79b5c4a0d4084ffd0-6778f69958-x4rqx',
 '/logged_users/Piotr Swiderski': 'notebook-b1d4673d48614999b889c4f27a801961-755d7bbffb-rb7gt',
 '/logged_users/Przewloka/Adam': 'user-3-Adam',
 '/logged_users/Przewloka/Borys': 'user-3-Borys',
 '/logged_users/Przewloka/Cezary': 'user-3-Cezary',
 '/logged_users/Przewloka/Damian': 'user-3-Damian',
 '/logged_users/Przewloka/Emil': 'user-3-Emil',
 '/logged_users/Przewloka/Filip': 'user-3-Filip',
 '/logged_users/Przewloka/Gustaw': 'user-3-Gustaw',
 '/logged_users/Przewloka/Henryk': 'user-3-Henryk',
 '/logged_users/Przewloka/Ignacy': 'user-3-Ignacy',
 '/logged_users/Przewloka/Jacek': 'user-3-Jacek',
 '/logged_users/Przewloka/Kamil': 'user-3-Kamil',
 '/logged_users/Przewloka/Leon': 'user-3-Leon',
 '/logged_users/Przewloka/Marek': 'user-3-Marek',
 '/logged_users/Przewloka/Norbert': 'user-3-Norbert',
 '/logged_users/Przewloka/Oskar': 'user-3-Oskar',
 '/logged_users/Przewloka/Patryk': 'user-3-Patryk',
 '/logged_users/Przewloka/Rafał': 'user-3-Rafał',
 '/logged_users/Przewloka/Stefan': 'user-3-Stefan',
 '/logged_users/Przewloka/Tadeusz': 'user-3-Tadeusz',
 '/logged_users/Przewloka/lease': 'Leased',
 '/logged_users/Przewloka/to_watch': 'token',
 '/logged_users/Rafał': 'user-Rafał',
 '/logged_users/SSwierk': 'notebook-condafree1py36ca7d2d12048646249d87c4564e316d78-78lfp26',
 '/logged_users/SZYMON': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/Stefan': 'user-Stefan',
 '/logged_users/SuperEmil': 'normalEmil',
 '/logged_users/Tadeusz': 'user-Tadeusz',
 '/logged_users/UTumilovich': 'notebook-cb0ffef2f3e240b4b8a72f0a17ed8bba-d57ff64d8-sj7qq',
 '/logged_users/Uladzislau': 'newUladzislau',
 '/logged_users/User1': 'val3',
 '/logged_users/WatchedKey': 'value second',
 '/logged_users/Wolski': 'Wolski-Notebook',
 '/logged_users/Wolski//logged_users/Adam': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Borys': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Cezary': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Damian': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Emil': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Filip': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Gustaw': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Henryk': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Ignacy': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Jacek': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Kamil': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Leon': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Marek': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Norbert': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Oskar': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Patryk': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Rafał': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Stefan': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Wolski//logged_users/Tadeusz': 'notebook-premium2py36f501191650b745849cf3df420b3c3644-79c52zpk9',
 '/logged_users/Xert/Adam': 'Adam-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Borys': 'Borys-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Cezary': 'Cezary-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Damian': 'Damian-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Emil': 'Emil-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Filip': 'Filip-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Gustaw': 'Gustaw-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Henryk': 'Henryk-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Ignacy': 'Ignacy-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Jacek': 'Jacek-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Kamil': 'Kamil-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Leon': 'Leon-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Marek': 'Marek-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Norbert': 'Norbert-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Oskar': 'Oskar-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Patryk': 'Patryk-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Rafał': 'Rafał-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Stefan': 'Stefan-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/Tadeusz': 'Tadeusz-notebook-condafree1py365026a77c8dbf4b5392587b5447eabe87-6bcglbn',
 '/logged_users/Xert/failure': 'true',
 '/logged_users/acwikla/Adam': 'Adam-acwikla-hostname',
 '/logged_users/acwikla/Borys': 'Borys-acwikla-hostname',
 '/logged_users/acwikla/Cezary': 'Cezary-acwikla-hostname',
 '/logged_users/acwikla/Damian': 'Damian-acwikla-hostname',
 '/logged_users/acwikla/Emil': 'Emil-acwikla-hostname',
 '/logged_users/acwikla/Filip': 'Filip-acwikla-hostname_new',
 '/logged_users/acwikla/Gustaw': 'Gustaw-acwikla-hostname',
 '/logged_users/acwikla/Henryk': 'Henryk-acwikla-hostname',
 '/logged_users/acwikla/Ignacy': 'Ignacy-acwikla-hostname',
 '/logged_users/acwikla/Jacek': 'Jacek-acwikla-hostname',
 '/logged_users/acwikla/Kamil': 'Kamil-acwikla-hostname',
 '/logged_users/acwikla/Leon': 'Leon-acwikla-hostname',
 '/logged_users/acwikla/Marek': 'Marek-acwikla-hostname',
 '/logged_users/acwikla/Norbert': 'Norbert-acwikla-hostname',
 '/logged_users/acwikla/Oskar': 'Oskar-acwikla-hostname',
 '/logged_users/acwikla/Patryk': 'Patryk-acwikla-hostname',
 '/logged_users/acwikla/Rafał': 'Rafał-acwikla-hostname',
 '/logged_users/acwikla/Stefan': 'Stefan-acwikla-hostname',
 '/logged_users/acwikla/Tadeusz': 'Tadeusz-acwikla-hostname',
 '/logged_users/acwikla/temporary': 'temporary-acwikla-hostname',
 '/logged_users/agierlach': 'Tadeusz-super-host',
 '/logged_users/agierlach/Adam': 'Adam-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Borys': 'Borys-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Cezary': 'Cezary-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Damian': 'Damian-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Emil': 'Emil-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Filip': 'Filip-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Gustaw': 'Gustaw-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Ignacy': 'Ignacy-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Jacek': 'Jacek-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Kamil': 'Kamil-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Leon': 'asdf',
 '/logged_users/agierlach/Marek': 'Marek-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Norbert': 'Norbert-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Oskar': 'Oskar-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Patryk': 'Patryk-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Rafał': 'Rafał-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Stefan': 'Stefan-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/Tadeusz': 'Tadeusz-notebook-condafree1py369fe46cb22f384d5d9bb015906bdbdbbf-6fcgqcp',
 '/logged_users/agierlach/to_watch': '1333',
 '/logged_users/anything': 'value',
 '/logged_users/being_watched': 'value',
 '/logged_users/beneckimateusz': '139',
 '/logged_users/callback_user': '{callback_user}-hostname',
 '/logged_users/dsxuser': 'notebook-0c0cad54e272445a8729f2a377a6def7-546c4b7d5f-ddgbp',
 '/logged_users/errors': 'condition failed',
 '/logged_users/errors_n_0': 'condition failed',
 '/logged_users/errors_n_1': 'condition failed',
 '/logged_users/errors_n_10': 'condition failed',
 '/logged_users/errors_n_11': 'condition failed',
 '/logged_users/errors_n_12': 'condition failed',
 '/logged_users/errors_n_13': 'condition failed',
 '/logged_users/errors_n_14': 'condition failed',
 '/logged_users/errors_n_15': 'condition failed',
 '/logged_users/errors_n_16': 'condition failed',
 '/logged_users/errors_n_17': 'condition failed',
 '/logged_users/errors_n_18': 'condition failed',
 '/logged_users/errors_n_2': 'condition failed',
 '/logged_users/errors_n_3': 'condition failed',
 '/logged_users/errors_n_4': 'condition failed',
 '/logged_users/errors_n_5': 'condition failed',
 '/logged_users/errors_n_6': 'condition failed',
 '/logged_users/errors_n_7': 'condition failed',
 '/logged_users/errors_n_8': 'condition failed',
 '/logged_users/errors_n_9': 'condition failed',
 '/logged_users/grzegorz/Adam': 'Adam-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Borys': 'Borys-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Cezary': 'Cezary-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Damian': 'Damian-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Emil': 'Emil-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Filip': 'Filip-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Gustaw': 'Gustaw-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Henryk': 'Henryk-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Ignacy': 'Ignacy-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Jacek': 'Jacek-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Kamil': 'Kamil-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Leon': 'Leon-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Marek': 'Marek-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Norbert': 'Norbert-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Oskar': 'Oskar-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Patryk': 'Patryk-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Rafał': 'Rafał-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Stefan': 'Stefan-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/grzegorz/Tadeusz': 'Tadeusz-notebook-condafree1py36a83819e79c3e4b399e4058c062729361-566n72k',
 '/logged_users/kaminski': 'notebook-condafree1py36316d9510130e4ef2aa895ec34c3f8c96-5dpp5sp',
 '/logged_users/kania//Adam': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Borys': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Cezary': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Damian': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Emil': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Filip': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Gustaw': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Henryk': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Ignacy': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Jacek': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Kamil': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Leon': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Marek': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Norbert': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Oskar': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Patryk': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Rafał': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Stefan': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania//Tadeusz': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Adam': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Borys': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Cezary': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Damian': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Emil': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Filip': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Gustaw': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Henryk': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Ignacy': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Jacek': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Kamil': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Leon': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Marek': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Norbert': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Oskar': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Patryk': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Rafał': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/SZYMON': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Stefan': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kania/Tadeusz': 'notebook-condafree1py369aa1e8cdc0ff47c7be259009f850542a-75xqfbc',
 '/logged_users/kawalec': 'DESKTOP-UIJMA2K',
 '/logged_users/kawalec/Adam': 'Adam-transaction',
 '/logged_users/kawalec/Borys': 'Borys-transaction',
 '/logged_users/kawalec/Cezary': 'Cezary-transaction',
 '/logged_users/kawalec/Damian': 'Damian-transaction',
 '/logged_users/kawalec/Emil': 'Emil-transaction',
 '/logged_users/kawalec/Filip': 'Filip-transaction',
 '/logged_users/kawalec/Gustaw': 'Gustaw Atomic Replace',
 '/logged_users/kawalec/Henryk': 'Henryk-transaction',
 '/logged_users/kawalec/Ignacy': 'Ignacy-transaction',
 '/logged_users/kawalec/Jacek': 'Jacek-transaction',
 '/logged_users/kawalec/Kamil': 'Kamil-transaction',
 '/logged_users/kawalec/Leon': 'Leon-transaction',
 '/logged_users/kawalec/Marek': 'Marek-transaction',
 '/logged_users/kawalec/Norbert': 'Norbert-transaction',
 '/logged_users/kawalec/Oskar': 'Oskar-transaction',
 '/logged_users/kawalec/Patryk': 'Patryk-transaction',
 '/logged_users/kawalec/Rafał': 'Rafał-transaction',
 '/logged_users/kawalec/Stefan': 'Stefan-transaction',
 '/logged_users/kawalec/Tadeusz': 'Tadeusz-transaction',
 '/logged_users/key': 'Tadeusz',
 '/logged_users/key_0': 'Adam',
 '/logged_users/key_1': 'Borys',
 '/logged_users/key_10': 'Kamil',
 '/logged_users/key_11': 'Leon',
 '/logged_users/key_12': 'Marek',
 '/logged_users/key_13': 'Norbert',
 '/logged_users/key_14': 'Oskar',
 '/logged_users/key_15': 'Patryk',
 '/logged_users/key_16': 'Rafał',
 '/logged_users/key_17': 'Stefan',
 '/logged_users/key_18': 'Tadeusz',
 '/logged_users/key_2': 'Cezary',
 '/logged_users/key_3': 'Damian',
 '/logged_users/key_4': 'Emil',
 '/logged_users/key_5': 'Filip',
 '/logged_users/key_6': 'Gustaw',
 '/logged_users/key_7': 'Henryk',
 '/logged_users/key_8': 'Ignacy',
 '/logged_users/key_9': 'Jacek',
 '/logged_users/key_n_0': 'Adam',
 '/logged_users/key_n_1': 'Borys',
 '/logged_users/key_n_10': 'Kamil',
 '/logged_users/key_n_11': 'Leon',
 '/logged_users/key_n_12': 'Marek',
 '/logged_users/key_n_13': 'Norbert',
 '/logged_users/key_n_14': 'Oskar',
 '/logged_users/key_n_15': 'Patryk',
 '/logged_users/key_n_16': 'Rafał',
 '/logged_users/key_n_17': 'Stefan',
 '/logged_users/key_n_18': 'Tadeusz',
 '/logged_users/key_n_19': 'Albert',
 '/logged_users/key_n_2': 'Cezary',
 '/logged_users/key_n_3': 'Damian',
 '/logged_users/key_n_4': 'Emil',
 '/logged_users/key_n_5': 'Filip',
 '/logged_users/key_n_6': 'Gustaw',
 '/logged_users/key_n_7': 'Henryk',
 '/logged_users/key_n_8': 'Ignacy',
 '/logged_users/key_n_9': 'Jacek',
 '/logged_users/konrad': 'konrad-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Adam': 'Adam-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Borys': 'Borys-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Cezary': 'Cezary-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Damian': 'Damian-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Emil': 'new_value',
 '/logged_users/konrad/Filip': 'Filip-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Gustaw': 'Gustaw-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Henryk': 'Henryk-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Ignacy': 'Ignacy-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Jacek': 'Jacek-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Kamil': 'Kamil-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Leon': 'Leon-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Marek': 'Marek-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Norbert': 'Norbert-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Oskar': 'Oskar-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Patryk': 'Patryk-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Rafał': 'Rafał-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Stefan': 'Stefan-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/Tadeusz': 'Tadeusz-notebook-condafree1py369ae2dd2798eb42529d327e7e89b639a8-672lvkb',
 '/logged_users/konrad/hello_watch': 'watch',
 '/logged_users/kustra': 'notebook-0b34268899e14795b60b6d36d0883ae1-576b4b5d8d-w62xc',
 '/logged_users/lock': 'value',
 '/logged_users/log': 'value was there',
 '/logged_users/mKurleto/Adam': 'Adam-hostname',
 '/logged_users/mKurleto/Borys': 'Borys-hostname',
 '/logged_users/mKurleto/Cezary': 'Cezary-hostname',
 '/logged_users/mKurleto/Damian': 'Damian-hostname',
 '/logged_users/mKurleto/Emil': 'Emil-hostname123123',
 '/logged_users/mKurleto/Filip': 'Filip-hostname',
 '/logged_users/mKurleto/Gustaw': 'Gustaw-hostname',
 '/logged_users/mKurleto/Henryk': 'Henryk-hostname',
 '/logged_users/mKurleto/Ignacy': 'Ignacy-hostname',
 '/logged_users/mKurleto/Jacek': 'Jacek-hostname',
 '/logged_users/mKurleto/Kamil': 'Kamil-hostname',
 '/logged_users/mKurleto/Leon': 'Leon-hostname',
 '/logged_users/mKurleto/Marek': 'Marek-hostname',
 '/logged_users/mKurleto/Norbert': 'Norbert-hostname',
 '/logged_users/mKurleto/Oskar': 'Oskar-hostname',
 '/logged_users/mKurleto/Patryk': 'Patryk-hostname',
 '/logged_users/mKurleto/Rafał': 'Rafał-hostname',
 '/logged_users/mKurleto/Stefan': 'Stefan-hostname',
 '/logged_users/mKurleto/Tadeusz': 'Tadeusz-hostname',
 '/logged_users/maciejKozub': 'notebook-condafree1py36df71c07b4e3b4ebe8de418e54ed7b1b8-cbcxtkz',
 '/logged_users/maciejKozub/Adam': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Borys': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Cezary': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Damian': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Emil': '22',
 '/logged_users/maciejKozub/Filip': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Gustaw': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Henryk': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Ignacy': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Jacek': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Kamil': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Leon': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Marek': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Norbert': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Oskar': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Patryk': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Rafał': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Stefan': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/Tadeusz': 'notebook-conda2py36df71c07b4e3b4ebe8de418e54ed7b1b8-8487f9626v8',
 '/logged_users/maciejKozub/test': 'lock_test',
 '/logged_users/magdalena': 'notebook-condafree1py365bb341db1c18409987fd62af4cdf6777-68sw9z2',
 '/logged_users/milosz': 'notebook-438cad81f4974877a0c254a6d6ff0145-58f95b7948-zfpxd',
 '/logged_users/mysliwiec/Adam': 'Adam-hostname2',
 '/logged_users/mysliwiec/Borys': 'Borys-hostname2',
 '/logged_users/mysliwiec/Cezary': 'Cezary-hostname2',
 '/logged_users/mysliwiec/Damian': 'Damian-hostname2',
 '/logged_users/mysliwiec/Emil': 'Emil-hostname2',
 '/logged_users/mysliwiec/Filip': 'Filip-hostname2',
 '/logged_users/mysliwiec/Gustaw': 'Gustaw-hostname2',
 '/logged_users/mysliwiec/Henryk': 'Henryk-hostname2',
 '/logged_users/mysliwiec/Ignacy': 'Ignacy-hostname2',
 '/logged_users/mysliwiec/Jacek': 'Jacek-hostname2',
 '/logged_users/mysliwiec/Jakub Mysliwiec': 'notebook-condafree1py3690879dede28a40ed88e530f26cab9341-6cpwqdw',
 '/logged_users/mysliwiec/Kamil': 'Kamil-hostname2',
 '/logged_users/mysliwiec/Leon': 'Leon-hostname2',
 '/logged_users/mysliwiec/Marek': 'Marek-hostname2',
 '/logged_users/mysliwiec/Norbert': 'Norbert-hostname2',
 '/logged_users/mysliwiec/Oskar': 'Oskar-hostname2',
 '/logged_users/mysliwiec/Patryk': 'Patryk-hostname2',
 '/logged_users/mysliwiec/Rafał': 'Rafał-hostname2',
 '/logged_users/mysliwiec/Stefan': 'Stefan-hostname2',
 '/logged_users/mysliwiec/Tadeusz': 'Tadeusz-hostname2',
 '/logged_users/mysliwiec/callback': '{callback}-hostname',
 '/logged_users/mysliwiec/refresh_user': '{callback}-hostname',
 '/logged_users/nalepa': 'notebook-db4dad02cab04ea3be358367155cc493-5cb65bd564-dgqgr',
 '/logged_users/pkopel/Adam': 'Adam-hostname',
 '/logged_users/pkopel/Borys': 'Borys-hostname',
 '/logged_users/pkopel/Cezary': 'Cezary-hostname',
 '/logged_users/pkopel/Damian': 'Damian-hostname',
 '/logged_users/pkopel/Dr. Manhattan': 'Dr. Manhattan',
 '/logged_users/pkopel/DrManhattan': 'Dr. Manhattan',
 '/logged_users/pkopel/Emil': 'Emil-hostname',
 '/logged_users/pkopel/Filip': 'Filip-hostname',
 '/logged_users/pkopel/Gustaw': 'Gustaf-hostname',
 '/logged_users/pkopel/Henryk': 'Henryk-hostname',
 '/logged_users/pkopel/Ignacy': 'Ignacy-hostname',
 '/logged_users/pkopel/Jacek': 'Jacek-hostname',
 '/logged_users/pkopel/Kamil': 'Kamil-hostname',
 '/logged_users/pkopel/Leon': 'Leon-hostname',
 '/logged_users/pkopel/Marek': 'Marek-hostname',
 '/logged_users/pkopel/Norbert': 'Norbert-hostname',
 '/logged_users/pkopel/Oskar': 'Oskar-hostname',
 '/logged_users/pkopel/Patryk': 'Patryk-hostname',
 '/logged_users/pkopel/Rafał': 'Rafał-hostname',
 '/logged_users/pkopel/Stefan': 'Stefan-hostname',
 '/logged_users/pkopel/Tadeusz': 'Tadeusz-hostname',
 '/logged_users/skusnierz': 'condition failed',
 '/logged_users/skusnierz/0': 'Adam',
 '/logged_users/skusnierz/1': 'Borys',
 '/logged_users/skusnierz/10': 'Kamil',
 '/logged_users/skusnierz/11': 'Leon',
 '/logged_users/skusnierz/12': 'Marek',
 '/logged_users/skusnierz/13': 'Norbert',
 '/logged_users/skusnierz/14': 'Oskar',
 '/logged_users/skusnierz/15': 'Patryk',
 '/logged_users/skusnierz/16': 'Rafał',
 '/logged_users/skusnierz/17': 'Stefan',
 '/logged_users/skusnierz/18': 'Tadeusz',
 '/logged_users/skusnierz/2': 'Cezary',
 '/logged_users/skusnierz/3': 'Damian',
 '/logged_users/skusnierz/4': 'Emil',
 '/logged_users/skusnierz/5': 'Filip',
 '/logged_users/skusnierz/6': 'Gustaw',
 '/logged_users/skusnierz/7': 'Henryk',
 '/logged_users/skusnierz/8': 'Ignacy',
 '/logged_users/skusnierz/9': 'Jacek',
 '/logged_users/skusnierz/transaction/0': 'Adam',
 '/logged_users/skusnierz/transaction/1': 'Borys',
 '/logged_users/skusnierz/transaction/10': 'Kamil',
 '/logged_users/skusnierz/transaction/11': 'Leon',
 '/logged_users/skusnierz/transaction/12': 'Marek',
 '/logged_users/skusnierz/transaction/13': 'Norbert',
 '/logged_users/skusnierz/transaction/14': 'Oskar',
 '/logged_users/skusnierz/transaction/15': 'Patryk',
 '/logged_users/skusnierz/transaction/16': 'Rafał',
 '/logged_users/skusnierz/transaction/17': 'Stefan',
 '/logged_users/skusnierz/transaction/18': 'Tadeusz',
 '/logged_users/skusnierz/transaction/2': 'Cezary',
 '/logged_users/skusnierz/transaction/3': 'Damian',
 '/logged_users/skusnierz/transaction/4': 'Emil',
 '/logged_users/skusnierz/transaction/5': 'Filip',
 '/logged_users/skusnierz/transaction/6': 'Gustaw',
 '/logged_users/skusnierz/transaction/7': 'Henryk',
 '/logged_users/skusnierz/transaction/8': 'Ignacy',
 '/logged_users/skusnierz/transaction/9': 'Jacek',
 '/logged_users/skusnierz/transaction/Adam': 'updated-Adam',
 '/logged_users/skusnierz/transaction/Borys': 'updated-Borys',
 '/logged_users/skusnierz/transaction/Cezary': 'updated-Cezary',
 '/logged_users/skusnierz/transaction/Damian': 'updated-Damian',
 '/logged_users/skusnierz/transaction/Emil': 'updated-Emil',
 '/logged_users/skusnierz/transaction/Filip': 'updated-Filip',
 '/logged_users/skusnierz/transaction/Gustaw': 'updated-Gustaw',
 '/logged_users/skusnierz/transaction/Henryk': 'updated-Henryk',
 '/logged_users/skusnierz/transaction/Ignacy': 'updated-Ignacy',
 '/logged_users/skusnierz/transaction/Jacek': 'updated-Jacek',
 '/logged_users/skusnierz/transaction/Kamil': 'updated-Kamil',
 '/logged_users/skusnierz/transaction/Leon': 'updated-Leon',
 '/logged_users/skusnierz/transaction/Marek': 'updated-Marek',
 '/logged_users/skusnierz/transaction/Norbert': 'updated-Norbert',
 '/logged_users/skusnierz/transaction/Oskar': 'updated-Oskar',
 '/logged_users/skusnierz/transaction/Patryk': 'updated-Patryk',
 '/logged_users/skusnierz/transaction/Rafał': 'updated-Rafał',
 '/logged_users/skusnierz/transaction/Stefan': 'updated-Stefan',
 '/logged_users/skusnierz/transaction/Tadeusz': 'updated-Tadeusz',
 '/logged_users/solecki': 'Tadeusz-notebook-condafree1py362847d525672542009895af0d8d60e2f2-79xg5sk',
 '/logged_users/solecki/Adam': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Borys': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Cezary': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Damian': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Emil': 'Emil',
 '/logged_users/solecki/Filip': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Gustaw': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Henryk': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Ignacy': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Jacek': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Kamil': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Leon': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Marek': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Norbert': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Oskar': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Patryk': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Rafał': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Stefan': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/solecki/Tadeusz': 'notebook-condafree1py362847d525672542009895af0d8d60e2f2-86rblb8',
 '/logged_users/status': 'Success',
 '/logged_users/swawozny/Adam': 'Adam',
 '/logged_users/swawozny/Borys': 'Borys',
 '/logged_users/swawozny/Cezary': 'Cezary',
 '/logged_users/swawozny/Damian': 'Damian',
 '/logged_users/swawozny/Emil': 'Emil',
 '/logged_users/swawozny/Filip': 'Filip',
 '/logged_users/swawozny/Gustaw': 'Gustaw',
 '/logged_users/swawozny/Henryk': 'Henryk',
 '/logged_users/swawozny/Ignacy': 'Ignacy',
 '/logged_users/swawozny/Jacek': 'Jacek',
 '/logged_users/swawozny/Kamil': 'Kamil',
 '/logged_users/swawozny/Leon': 'Leon',
 '/logged_users/swawozny/Marek': 'Marek',
 '/logged_users/swawozny/Norbert': 'Norbert',
 '/logged_users/swawozny/Oskar': 'Oskar',
 '/logged_users/swawozny/Patryk': 'Patryk',
 '/logged_users/swawozny/Rafał': 'Rafał',
 '/logged_users/swawozny/Stefan': 'Stefan',
 '/logged_users/swawozny/Tadeusz': 'Tadeusz',
 '/logged_users/szarbartosz/1': 'Adam',
 '/logged_users/szarbartosz/10': 'Jacek',
 '/logged_users/szarbartosz/11': 'Kamil',
 '/logged_users/szarbartosz/12': 'Leon',
 '/logged_users/szarbartosz/13': 'Marek',
 '/logged_users/szarbartosz/14': 'Norbert',
 '/logged_users/szarbartosz/15': 'Oskar',
 '/logged_users/szarbartosz/16': 'Patryk',
 '/logged_users/szarbartosz/17': 'Rafał',
 '/logged_users/szarbartosz/18': 'Stefan',
 '/logged_users/szarbartosz/19': 'Tadeusz',
 '/logged_users/szarbartosz/2': 'Borys',
 '/logged_users/szarbartosz/3': 'Cezary',
 '/logged_users/szarbartosz/4': 'Damian',
 '/logged_users/szarbartosz/5': 'Emil',
 '/logged_users/szarbartosz/6': 'Filip',
 '/logged_users/szarbartosz/7': 'Gustaw',
 '/logged_users/szarbartosz/8': 'Henryk',
 '/logged_users/szarbartosz/9': 'Ignacy',
 '/logged_users/szarbartosz/Adam': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Borys': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Cezary': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Damian': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Emil': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Filip': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Gustaw': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Henryk': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Ignacy': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Jacek': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Kamil': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Leon': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Marek': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Norbert': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Oskar': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Patryk': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Rafał': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Stefan': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szarbartosz/Tadeusz': 'notebook-premium2py361c60dbc4f0284c78aee09e9714200ebf-597fslbgf',
 '/logged_users/szelemeh/Adam': 'Adam-host',
 '/logged_users/szelemeh/Borys': 'Borys-host',
 '/logged_users/szelemeh/Cezary': 'Cezary-host',
 '/logged_users/szelemeh/Damian': 'Damian-host',
 '/logged_users/szelemeh/Emil': 'Emil-host',
 '/logged_users/szelemeh/Filip': 'Filip-host',
 '/logged_users/szelemeh/Gustaw': 'Gustaw-host',
 '/logged_users/szelemeh/Henryk': 'Henryk-host',
 '/logged_users/szelemeh/Ignacy': 'Ignacy-host',
 '/logged_users/szelemeh/Jacek': 'Jacek-host',
 '/logged_users/szelemeh/Kamil': 'Kamil-host',
 '/logged_users/szelemeh/Leon': 'Leon-host',
 '/logged_users/szelemeh/Marek': 'Marek-host',
 '/logged_users/szelemeh/Norbert': 'Norbert-host',
 ...}
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

```python


{'/logged_users/szarbartosz/1': 'Adam',
 '/logged_users/szarbartosz/10': 'Jacek',
 '/logged_users/szarbartosz/11': 'Kamil',
 '/logged_users/szarbartosz/12': 'Leon',
 '/logged_users/szarbartosz/13': 'Marek',
 '/logged_users/szarbartosz/14': 'Norbert',
 '/logged_users/szarbartosz/15': 'Oskar',
 '/logged_users/szarbartosz/16': 'Patryk',
 '/logged_users/szarbartosz/17': 'Rafał',
 '/logged_users/szarbartosz/18': 'Stefan',
 '/logged_users/szarbartosz/19': 'Tadeusz',
 '/logged_users/szarbartosz/2': 'Borys',
 '/logged_users/szarbartosz/3': 'Cezary',
 '/logged_users/szarbartosz/4': 'Damian',
 '/logged_users/szarbartosz/5': 'Emil',
 '/logged_users/szarbartosz/6': 'Filip',
 '/logged_users/szarbartosz/7': 'Gustaw',
 '/logged_users/szarbartosz/8': 'Henryk',
 '/logged_users/szarbartosz/9': 'Ignacy',
 '/logged_users/szarbartosz/Adam': 'Adam',
 '/logged_users/szarbartosz/Borys': 'Borys',
 '/logged_users/szarbartosz/Cezary': 'Cezary',
 '/logged_users/szarbartosz/Damian': 'Damian',
 '/logged_users/szarbartosz/Emil': 'Emil',
 '/logged_users/szarbartosz/Filip': 'Filip',
 '/logged_users/szarbartosz/Gustaw': 'Gustaw',
 '/logged_users/szarbartosz/Henryk': 'Henryk',
 '/logged_users/szarbartosz/Ignacy': 'Ignacy',
 '/logged_users/szarbartosz/Jacek': 'Jacek',
 '/logged_users/szarbartosz/Kamil': 'Kamil',
 '/logged_users/szarbartosz/Leon': 'Leon',
 '/logged_users/szarbartosz/Marek': 'Marek',
 '/logged_users/szarbartosz/Norbert': 'Norbert',
 '/logged_users/szarbartosz/Oskar': 'Oskar',
 '/logged_users/szarbartosz/Patryk': 'Patryk',
 '/logged_users/szarbartosz/Rafał': 'Rafał',
 '/logged_users/szarbartosz/Stefan': 'Stefan',
 '/logged_users/szarbartosz/Tadeusz': 'Tadeusz'}
```

### Task 5 : Get single key (e.g. status of transaction)

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

Check the key you are modifying in on-failure handler in previous task

```python
for i in etcd.get_prefix('/tmp/failure'):
    print(i)
```

```python
(b'condtion failed - users modification', <etcd3.client.KVMetadata object at 0x7fa600cc6978>)
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

```python
/logged_users/szarbartosz/Norbert - Norbert
/logged_users/szarbartosz/Marek - Marek
/logged_users/szarbartosz/Leon - Leon
/logged_users/szarbartosz/Kamil - Kamil
/logged_users/szarbartosz/Jacek - Jacek
/logged_users/szarbartosz/Ignacy - Ignacy
/logged_users/szarbartosz/Henryk - Henryk
/logged_users/szarbartosz/Gustaw - Gustaw
/logged_users/szarbartosz/Filip - Filip
/logged_users/szarbartosz/Emil - Emil
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

```python
Adam: True
Borys: True
Cezary: True
Damian: True
Emil: True
Filip: True
Gustaw: True
Henryk: True
Ignacy: True
Jacek: True
Kamil: True
Leon: True
Marek: True
Norbert: True
Oskar: True
Patryk: True
Rafał: True
Stefan: True
Tadeusz: True
Adam: False
Borys: False
Cezary: False
Damian: False
Emil: False
Filip: False
Gustaw: False
Henryk: False
Ignacy: False
Jacek: False
Kamil: False
Leon: False
Marek: False
Norbert: False
Oskar: False
Patryk: False
Rafał: False
Stefan: False
Tadeusz: False
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

```python
/logged_users/szarbartosz/USER : something
leased key:  (b'something', <etcd3.client.KVMetadata object at 0x7fa601514b00>)
leased key:  (None, None)
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

```python
(b'value', <etcd3.client.KVMetadata object at 0x7fa600cc6b38>)
(b'value', <etcd3.client.KVMetadata object at 0x7fa601512400>)
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

```python
a
Is acquaired? True
b
c
```

### Task 11: Watch key

etcd3 api: https://python-etcd3.readthedocs.io/en/latest/usage.html

This cell will lock this notebook on waiting  
After running it create a new notebook and try to add new user

```python
def etcd_call(cb):
    print(cb)

etcd.add_watch_callback(key='/test/test', callback=etcd_call)
```

```python
1
<etcd3.watch.WatchResponse object at 0x7fa601512208>
<etcd3.watch.WatchResponse object at 0x7fa601512208>
<etcd3.watch.WatchResponse object at 0x7fa601512208>
```

```python
#etcd.put('/test/test', 'test')
```
