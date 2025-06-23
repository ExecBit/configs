if status is-interactive
    # Commands to run in interactive sessions can go here
end

set PATH ~/.cargo/bin/ $PATH
set PATH /opt/linphone/bin $PATH
set PATH ~/.scripts/bash $PATH
set PATH ~/.scripts/python/ $PATH

#set -g fish_key_bindings fish_vi_key_bindings

export EDITOR=nvim
export VISUAL=nvim

#не забыть поставить эти ебучие пакеты
export CC=/usr/bin/gcc-14
export CXX=/usr/bin/g++-14

function yy
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

function cf
    cd ~ && cd (fd -t d | fzf)
end

