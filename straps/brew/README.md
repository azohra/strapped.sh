# Brew

| Attribute     | Value                                       |
|--------------:|---------------------------------------------|
| Namespace     | brew                                        |
| Emoji         | 🍺[pkg] 🍻[cask] 🚰[tap]                     |
| Description   | installs packages, casks, and taps via brew |
| Dependencies  | brew                                        |
| Compatability | OSX                                         |

## Configuration

```yml
brew:
  taps:
    - { name: azohra/tools }
    - { name: homebrew/cask }
    - { name: homebrew/cask-drivers }
  packages:
    - { name: ruby, upgrade: true }
    - { name: zsh,  upgrade: true }
    - { name: lyra, upgrade: true }
  casks:
    - { name: 1password, upgrade: true }  
    - { name: firefox,   upgrade: true }
    - { name: slack,     upgrade: true }
```
