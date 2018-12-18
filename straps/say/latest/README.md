# say :: v0.1.0

| Attribute     | Value |
|--------------:|----|
| Namespace     | say |
| Emoji         | 🔈 [phrase] 🔈 [file]  |
| Description   | uses the mac `say` command to convert text to speech |
| Dependencies  |   |
| Compatability | OSX  |

## Configuration

```yml
say:
  phrase:
    - { voice: Karen, text: Strapped is so cool! }
  file:
    - { voice: Alex, file: ~/lyrics.txt }
```
