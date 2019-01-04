# bash :: v0.2.0

| Attribute     | Value |
|--------------:|----|
| Namespace     | bash |
| Emoji         | 📂 [mkdir] 🔗 [ln] 👉 [touch] 🗣 [echo] 👟 [exec]  |
| Description   | performs bash commands |
| Dependencies  | echo mkdir touch exec ln  |
| Compatability | unix  |

## Configuration

```yml
bash:
  mkdir:
    - { dir: ~/photos }
  ln:
    - { symbolic: false, target: ~/.configs/.bashrc, name: ~/.bashrc }
  touch:
    - { file: .bashrc }
  echo:
    - { msg: Hello world }
  exec:
    - { file: ~/Downloads/osx_defaults.sh }
```
