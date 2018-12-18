# dockutil :: v0.1.0

| Attribute     | Value |
|--------------:|----|
| Namespace     | dockutil |
| Emoji         | 🚢 [apps] 🚢 [dirs]  |
| Description   | adds, removes, and sorts items in the osx dock |
| Dependencies  | dockutil  |
| Compatability | OSX  |

## Configuration

```yml
dockutil:
  apps:
    - { path: /Applications/Google Chrome.app, pos: 2 }
  dirs:
    - { display: stack, sort: dateadded, path: ~/Downloads, view: fan }
```
