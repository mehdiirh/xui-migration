## Script to migrate [x-ui](https://github.com/vaxilu/x-ui) data and SSL certs

### On your new server run:
```bash
bash <(curl -Ls https://raw.githubusercontent.com/mehdiirh/xui-migation/master/migrator.sh)
```
and follow the instructions.

## One-line migration
You can pass the credentials of your old server to the script for one-line migration.

### SSH Arguments:

| ARG | DESCRIPTION     | EXAMPLE     |
|:---:|-----------------|-------------|
| -s  | server address  | 192.168.1.1 |
 | -u  | server username | root        |
| -p  | server password | MyPaSsWoEd  |

### One-line migration example
```bash
sudo bash <(curl -Ls https://raw.githubusercontent.com/mehdiirh/xui-migation/master/migrator.sh) -s 192.168.1.1 -u root -p MyPaSsWoEd
```

## ~
