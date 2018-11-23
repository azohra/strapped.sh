# dockutils

| Attribute     | Value                                     |
|--------------:|-------------------------------------------|
| Namespace     | dockutils                                 |
| Emoji         | 🚢                                        |
| Description   | adds, removes, and sorts the osx dock     |
| Dependencies  | dockutils                                 |
| Compatability | OSX                                       |

## Configuration

```yml
dockutils:
  apps:
    - { name: Google Chrome,      pos: 1, path: "/Applications/Google Chrome.app"}
    - { name: Slack,              pos: 2, path: "/Applications/Slack.app"}
    - { name: Spotify,            pos: 3, path: "/Applications/Spotify.app"}

  dirs:
    - { path: "~/Downloads",      view: fan, display: stack, sort: dateadded }
    - { path: "~/Documents",      view: fan, display: stack, sort: dateadded }
    - { path: "~/Development",    view: fan, display: stack, sort: dateadded }
```
