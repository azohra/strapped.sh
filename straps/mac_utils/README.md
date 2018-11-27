# Mac Utils

| Attribute     | Value                                     |
|--------------:|-------------------------------------------|
| Namespace     | mac_utils                                 |
| Emoji         | 🛠️                                        |
| Description   | edit plists                               |
| Dependencies  | none                                      |
| Compatability | OSX                                       |

## Configuration

```yml
mac_utils:
  plist:
  - { domain: com.microsoft.Word,  key: kSubUIAppCompletedFirstRunSetup1507, type: bool, value: true }
  - { domain: com.microsoft.Excel, key: kSubUIAppCompletedFirstRunSetup1507, type: bool, value: true }
```
