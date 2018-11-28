# Git

| Attribute     | Value                                     |
|--------------:|-------------------------------------------|
| Namespace     | git                                       |
| Emoji         | 💾                                        |
| Description   | clones git repos to the specified folder  |
| Dependencies  | git                                       |
| Compatability | universal                                 |

## Configuration

```yml
git:
  clone:
    - { repo: git@github.com:kelseyhightower/nocode.git, folder: /Users/justin/Development/nocode }
    - { repo: git@github.com:azohra/lyra.git,            folder: /Users/justin/Development/lyra   }
```
