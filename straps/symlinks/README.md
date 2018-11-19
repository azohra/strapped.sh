# Symlinks

| Attribute     | Value                                     |
|--------------:|-------------------------------------------|
| Namespace     | symlinks                                  |
| Emoji         | 💎                                        |
| Description   | symlinks directories together             |
| Dependencies  | ln                                        |
| Compatability | Unix                                      |

### Configuration
```yml
#great for dotfiles and personal configurations
symlinks:
  - { src: "/dev/dotfiles/.gitignore", dest: "~/.gitignore" }
  - { src: "/dev/dotfiles/.gitconfig", dest: "~/.gitconfig" }

```
