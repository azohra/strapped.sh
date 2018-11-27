# Unix Utils

| Attribute     | Value                                     |
|--------------:|-------------------------------------------|
| Namespace     | unix_utils                                |
| Emoji         | 🔗[ln] 📂[mkdir] ️🗣️[echo] 📤[source]       |
| Description   | perform general unix command line tasks   |
| Dependencies  | none                                      |
| Compatability | Unix                                      |

## Configuration

```yml
unix_utils:
  mkdir:
  - { dir: ~/photos }
  - { dir: /www/_static }
  ln:
  - { dir: "/dotfiles/.gitignore", link: "~/.gitignore" }
  - { dir: "/dotfiles/.gitconfig", link: "~/.gitconfig" }
  source:
  - { dir: ~/.bashrc }
  echo:
  - { phrase: "You have successfully installed strapped.sh" }
  - { phrase: "Made with <3 by Azohra" }
```
