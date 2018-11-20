# testing

| Attribute     | Value                                     |
|--------------:|-------------------------------------------|
| Namespace     | testing                                      |
| Emoji         | An emoji that best describes your strap   |
| Description   | A description of your strap               |
| Dependencies  | ex: Git                                   |
| Compatability | ex: Unix, Mac OS                          |

## Configuration

```yml
testing:
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
