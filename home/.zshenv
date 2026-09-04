# First file zsh reads, for EVERY zsh: -c, -ic, -lc, -lic, and script interpretation.
# Must be silent -- the p10k instant prompt preamble in .zshrc requires no prior output.
. "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env.sh"
