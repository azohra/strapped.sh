# brew :: v0.1.1

| Attribute     | Value |
|--------------:|----|
| Namespace     | brew |
| Emoji         | 🚰 [taps] 🍺 [packages] 🍻 [casks]  |
| Description   | installs packages, casks, and taps via brew |
| Dependencies  | brew  |
| Compatability | OSX  |

## Configuration

```yml
brew:
  taps:
    - { name: azohra/tools }
  packages:
    - { name: ruby }
  casks:
    - { name: 1password }
```
