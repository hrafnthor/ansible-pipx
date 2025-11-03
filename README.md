# Ansible PipX

An Ansible role for installing the Python packaging tool [pipx](https://github.com/pypa/pipx), and arbitrary number of packages via it, globally.

### Notes & limitations:

This role was created out of my own frustration with needing to use `pipx` for installing various tools on a global level but not really finding a good reproducible way to install `pipx` it self on my preferred platform.

If your platforms have an up to date version of `pipx` in the native package manager, just go with that rather than this role! Alternatively you can use the `pipx.install.distribution` block to define the installation.

*Attention:* Installing pipx via the archive method will make the community.general.pipx Ansible package not function properly since by default it requires python -m pipx to work, which will not work using the pipx.pyz file. This can be remedied by passing the path of the pipx executable (by default placed at /usr/bin/pipx) created by this role to the executable parameter of the community.general.pipx role see docs.

*Attention* This role currently only supports distribution installation for `Debian` based distributions.

### Requirements:

This role requires the `ansible.utils` and `community.general>=11.4.1` collection be installed from Ansible-Galaxy via:

```shell
ansible-galaxy collection install ansible.utils
ansible-galaxy collection install community.general:11.4.1
```

Version 11.4.1 of community general is required since earlier versions of `community.general.pipx` were not idempotent when installing specific versions of packages.

It then also requires the `jsonschema` Python package be installed. It can be installed via pip:

```shell
pip3 install jsonschema
```

### Role Variables

```yaml
pipx:
  install:
    distribution:             Mutually exclusive to the [archive] block
      remove:  [bool]         Indicates that the distribution version should be removed. Defaults to false.
      version: [string]       [required] The version to install from the native package manager
    archive:                  Mutually exclusive to the [distribution] block
      default: [string]       The version to link to global path. Must exist as a archive downloaded version.
      versions:
        - version: [string]   [required] The version to download
          checksum: [string]  [required] The checksum for the version. Must have the form 'algorithm:checksum'. See Pipx's Github repository.
          remove: [boolean]   Indicates that this specific version should be removed. Defaults to false.
  packages:
    executable: [string]      If using the archive installation of pipx, add the path to the executable here. If default location values are used then this should be /usr/bin/pipx.
    global:                   Array of packages to install globally
      - name: [string]        [required] The name of the package being managed
        version: [string]     The version to install, or 'latest'. Will default to 'latest' if omitted.
        remove: [boolean]     Indicates that the package should be uninstalled. Defaults to false.
        force: [boolean]      Indicates that this version should be forcefully installed. Defaults to false.
```

#### Defaults

The following default variables are available for modification:

`hth_pipx_archive_destination_path`:

The default destination path to where archive versions will be placed.

Defaults to `/opt/pipx`.

`hth_pipx_archive_destination_path_owner`:

The default owner of the destination path where archive versions will be placed.

Defaults to `root`.

`hth_pipx_archive_destination_path_group`:

The default group owner of the destination path where archive versions will be placed.

Defaults to `root`.

`hth_pipx_archive_destination_path_mode`:

The default mode of the destination path where archive versions will be placed.

Defaults to `0755`.

`hth_pipx_default_artifact_link_path`:

The default path to where the default version will be symlinked to.

Defaults to `/usr/bin/pipx`.

`hth_pipx_default_python_venv_package`:

The default `Python venv` package to install from distribution package sources.

Defaults to `python3.12-venv`.

#### Example

```yaml
pipx:
  install:
    archive:
      default: "1.8.0"
      versions:
        - version: "1.8.0"
          checksum: "sha256:b9eabd835dffe0677e36bd99416fc9837c592bd8c079235379bed3dfe043c601"
  packages:
    executable: /usr/bin/pipx
    global:
    - name: manly
      version: "0.4.1"
      force: true
```

### Setup

Before the role can be used it needs to be added to the machine running the playbook, and as of writing this, this role is not hosted on Ansible-Galaxy only on Github.

1. Create a `requirements.yml` file in the root directory of the playbook being worked on.

2. Add the following definition inside the `requirements.yml` file:

```yml
- name: hth-pipx
  src: https://github.com/hrafnthor/ansible-pipx.git
  scm: git
```

3. Install the requirements by executing

```shell
ansible-galaxy install -r .requirements.yml
```

This will allow any playbook run from this machine to use the role `hth-pipx`


### Example Playbook


```yaml
- hosts: all
    vars:
    - pipx:
        install:
          archive:
            default: "1.8.0"
            versions:
              - version: "1.8.0"
                checksum: "sha256:b9eabd835dffe0677e36bd99416fc9837c592bd8c079235379bed3dfe043c601"
        packages:
          - name: manly
            version: "0.4.1"
            force: true
  roles:
     - hth-pipx
```

## License

```
Copyright 2025 Hrafn Thorvaldsson

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
