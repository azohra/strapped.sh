# brew :: v0.1.0

| Attribute     | Value |
|--------------:|----|
| Namespace     | brew |
| Emoji         | 🍺 [packages] 🚰 [taps] 🍻 [casks]  |
| Description   | installs packages, casks, and taps via brew |
| Dependencies  | brew  |
| Compatability | OSX  |

## Configuration

```yml
brew:
  packages:
    - { name: ruby }
  taps:
    - { name: azohra/tools }
  casks:
    - { name: 1password }
```
