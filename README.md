# .config


## nixos

rebuild with flakes
     
     nixos-rebuild switch --flake '/etc/nixos#root' --impure


format

     nixpkgs-fmt configuration.nix


## nvim

- https://oroques.dev/notes/neovim-init/


## alacritty

按 Ctrl + Shift + Space 进入 vim 模式，可以进行光标移动、选择、复制

缺少对 zmodem 协议的支持，不适合作为 ssh client

一些例子：
- https://sunnnychan.github.io/cheatsheet/linux/config/alacritty.yml.html
- https://www.v2ex.com/t/786386