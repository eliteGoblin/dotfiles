for zsh. I want feature like. 

in ~. I have folder .my_zshrc and .creds/ 
so in ~/.zshrc, it always seeks to load these folders : load means it will iterate each folder recursiovely, and source each .sh file. 

so here's my ~/.zshrc file, as example:  `documents/requirement/zshrc_example`


I want you update: 

* Main idea is modularize , and simplify main ~/.zshrc, leave it mostly just for zsh it self: PATH setting

* It should load all a list of folder in .zshrc, that's configurable via change .zshrc. e.g load .my_zshrc/ and .creds

* Example, say for load rerelated to zsh, like all the alias, I will have file ~/.my_zshrc/alias.sh or even I can further breakdown: ~/.my_zshrc/personal/alias.sh my .zshrc will load them into it. 
    * I mean: I want the flexibility to structure my folder, I need ability to load recursively for all sub folders
* Current list of folder I need:
    * ~/.my_zshrc/alias/ which has common alias

# Install

I want you generate steps of how to install dotfiles into my computer:

1. first clone this dotfiles repo into somewhere, then
2. I think need softlink to point zsh config and other config like nvim to using my dotfiles.

Ideally: install should be idempotent. and log or warning something is broken

Create a README.md

# Non feature requirements

* Record context in Claude.md