# bash :: v0.1.0

| Attribute     | Value |
|--------------:|----|
| Namespace     | bash |
| Emoji         | 📂 [mkdir] 👉 [touch] 🗣 [echo] 👟 [exec]  |
| Description   | performs bash commands |
| Dependencies  | echo mkdir touch exec  |
| Compatability | unix  |

## Configuration

```yml
bash:
  mkdir:
    - { dir: ~/photos }
  touch:
    - { file: .bashrc }
  echo:
    - { msg: Hello world }
  exec:
    - { file: ~/Downloads/osx_defaults.sh }
```
