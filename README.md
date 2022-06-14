# React-Frontend Plugin Template 

Reference example for using [decky-frontend-lib](https://github.com/SteamDeckHomebrew/decky-frontend-lib) in a [PluginLoader](https://github.com/SteamDeckHomebrew/PluginLoader) plugin.

## PluginLoader Discord [![Chat](https://img.shields.io/badge/chat-on%20discord-7289da.svg)](https://discord.gg/ZU74G2NJzk)

## Developers

### Dependencies

This template relies on the user having `pnpm` installed on their system.  
This can be downloaded from `npm` itself which is recommended. 

#### Linux
```bash
sudo npm i -g pnpm
```

### Keep Your Plugin Updated

1. In your plugin's repository run these commands:
   1. ``pnpm i``
   2.  (Optional, needed to solve build errors)
       1. ``pnpm update decky-frontend-lib --latest``
   3. ``pnpm run build``
2. You should perform numbers 1 and 3 every time you make changes to your plugin.

### Distribution

WIP. Check back in later.

