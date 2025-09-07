# nix-fingerprint

A little collection of helpers that exploit impurities in nix to gather
information about the underlying system in pure evaluation mode.

Example:

```
# In pure eval mode
$ nix eval github:oddlama/nix-fingerprint#estimatedCurrentSystem
"x86_64-linux"
```
