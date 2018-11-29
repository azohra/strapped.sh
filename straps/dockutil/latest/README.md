# dockutil

| Attribute     | Value |
|--------------:|----|
| Namespace     | dockutil |
| Emoji         | 🚢 [apps] 🚢 [dirs] 🚢 [position]  |
| Description   | adds, removes, and sorts items in the osx dock |
| Dependencies  | dockutil  |
| Compatability | OSX  |

## Configuration

```yml
dockutil:
  apps:
    - { path: /Applications/Google Chrome.app }
  dirs:
    - { display: stack, sort: dateadded, path: ~/Downloads, view: fan }
  position:
    - { name: Spotify, position: 1 }
```
