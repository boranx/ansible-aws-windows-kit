# Ansible Aws Windows Kit

Generic aws windows ansible kit. Creates dynamic windows instances from ec2. It installs windows features, selenium, jdk etc.. after the provisioning.

## Dependencies

```shell
sudo pip install pywinrm
sudo pip install xmltodict
```

## How to install

* Remove ```roles/ec2-instance/files/win_ec2_user_data``` and ```roles/ec2-instance/vars/main.yml``` files

* Create the ```roles/ec2-instance/vars/main.yml``` file like this:

```yml
aws_access_key: # AWS Secret key
aws_secret_key: # AWS Secret key id
win_ec2_region: eu-west-1
win_ec2_name_prefix: "{{ selenium_grid_role }}" # You don't need to change this line
win_user: Administrator # User name placed in ec2-instance user data.
win_pass: # User pass placed in ec2-instance user data.
win_ec2_security_group: # AWS Security Group Name
item_id: ami-96b824ef
win_ec2_instance_type: t2.micro
```

* Create the ```roles/ec2-instance/files/win_ec2_user_data``` file like this:

```ps1
<powershell>
$admin = [adsi]("WinNT://./administrator, user")
$admin.PSBase.Invoke("SetPassword", "     ") # Set the Administrator password, that you specified before.
Invoke-Expression ((New-Object System.Net.Webclient).DownloadString('https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1'))
</powershell>
```

## Encryption & Decryption Of Private Files

```shell
ansible-vault encrypt roles/ec2-instance/files/win_ec2_user_data
```

```shell
ansible-vault encrypt roles/ec2-instance/vars/main.yml
```

```shell
ansible-vault view ...
```

```shell
ansible-vault decrypt ...
```

## Run

* Add your role to ```roles``` folder.

* Create a subplaybook which contains some roles.

* Run master playbook like below and pass the ```role=subplaybook.yml``` parameter.

```shell
ansible-playbook master.yml --extra-vars "role=selenium-hub" --ask-vault-pass
```

```shell
ansible-playbook master.yml --extra-vars "role=selenium-node selenium_hub_register_address=http://seleniumhubaddress:4444/grid/register" --ask-vault-pass
```