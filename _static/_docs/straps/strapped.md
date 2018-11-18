# Example

| Attribute     | Value                                     |
|--------------:|-------------------------------------------|
| Namespace     | strapped                                  |
| Emoji         | 🔫                                        |
| Description   | base configuration for strapped to run    |
| Dependencies  | strapped.sh                               |
| Compatability | Universal                                 |

### Configuration
```yml
# load from a remote URL
strapped:
  repo: https://raw.githubusercontent.com/azohra/strapped/master/straps/ 
```

```yml
# load from a local file
strapped:
  repo: ~/.strapped/strapped.yml
```