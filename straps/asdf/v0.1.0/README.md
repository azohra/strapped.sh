# asdf :: v0.1.0

| Attribute     | Value |
|--------------:|----|
| Namespace     | asdf |
| Emoji         | 🐙 [plugins] ⌨ [versions]  |
| Description   | Extendable version manager |
| Dependencies  | asdf  |
| Compatability | unix  |

## Configuration

```yml
asdf:
  plugins:
    - { name: clojure, url: https://github.com/halcyon/asdf-clojure.git }
  versions:
    - { dir: ~/opeional_local_install, name: clojure, version: 1.9.0 }
```
