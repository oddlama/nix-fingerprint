# 🫆 nix-fingerprint

A little collection of helpers that exploit impurities in nix to gather
information about the underlying system in pure evaluation mode.

Also contains some other oddities we found.

Example:

```
# In pure eval mode
$ nix eval github:oddlama/nix-fingerprint#estimatedCurrentSystem
"x86_64-linux"
```

<sub>Please don't use this<sub>
