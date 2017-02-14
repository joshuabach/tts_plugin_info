# watts_plugin_info
A simple plugin for WaTTS, displaying all the informations the plugins get.

copy the plugin 'info.py' to your WaTTS plugin folder, usually '/var/lib/watts/plugins'.

The plugin can be enable by adding a few lines to the WaTTS configuration:
```
service.info.description = Simple Info Service
service.info.credential_limit = 1 
service.info.connection.type = local
# adjust the cmd setting to point to the plugin
service.info.cmd = /var/lib/watts/plugins/info.py
service.info.parallel_runner = infinite 
service.info.authz.allow.any.sub.any = true
```
