# React-Frontend Plugin Template 

Reference example for using [decky-frontend-lib](https://github.com/SteamDeckHomebrew/decky-frontend-lib) in a [decky-loader](https://github.com/SteamDeckHomebrew/decky-loader) plugin.

## Decky Loader Discord [![Chat](https://img.shields.io/badge/chat-on%20discord-7289da.svg)](https://discord.gg/ZU74G2NJzk)

## Developers

### Dependencies

This template relies on the user having `pnpm` installed on their system.  
This can be downloaded from `npm` itself which is recommended. 

#### Linux

```bash
sudo npm i -g pnpm
```

### Getting Started

1. Clone the repository to use as an example for making your plugin.
2. In your clone of the repository run these commands:
   1. ``pnpm i``
   2. ``pnpm run build``
3. You should do this every time you make changes to your plugin.

Note: If you are recieveing build errors due to an out of date library, you should run this command inside of your repository:

```bash
pnpm update decky-frontend-lib --latest
```

### Distribution

Plugins are distributed officially through the [decky-plugin-database](https://github.com/SteamDeckHomebrew/decky-plugin-database) via usage of submodules and PRs.  
If you wish to distribute your plugin another way then you will need to build and bundle the plugin as a zip file.  
Here users can install the zip file from a URL in the settings menu, they will be warned that the plugin is not verified via hash.

