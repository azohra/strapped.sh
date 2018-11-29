# unix_utils

| Attribute     | Value |
|--------------:|----|
| Namespace     | unix_utils |
| Emoji         | 📂 [mkdir] 👉 [touch] 🗣
🗣 [echo]  |
| Description   | performs unix commands |
| Dependencies  | echo  |
| Compatability | OSX  |

## Configuration

```yml
unix_utils:
  mkdir:
    - { dir: ~/photos }
  touch:
    - { file: .bashrc }
  echo:
    - { msg: Hello world }
```
