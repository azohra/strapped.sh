# bash

| Attribute     | Value |
|--------------:|----|
| Namespace     | bash |
| Emoji         | 📂 [mkdir] 👉 [touch] 🗣 [echo] 👟 [exec]  |
| Description   | performs bash commands |
| Dependencies  | echo mkdir touch  |
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
