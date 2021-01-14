# Ansible

**EXPERIMENTAL**

Alpine based Ansible image with the following dependencies installed.

* psycopg2
* pymysql
* requests
* boto

There are some example playbooks in the playbooks directory.

## Updating

There is a helper make target `make update` that tries to update the python packages installed in Pipenv.

When upgrading the version of Python the version needs to be updated in both the `Pipfile` and `Dockerfile`.

There is a helper make target `make tag` that get the ansible version from `Pipfile.lock` and uses it as a git tag. If the version of ansible doesn't change you may need to add build version to the end of the tag eg `v2.10.5-2`.
