# use systemd-environment-d-generator(8) to generate environment, and export those variables
set -o allexport
source <(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
set +o allexport

HOME_PROFILE_D=${XDG_CONFIG_HOME:-$HOME/.config}/profile.d
if [ -d "$HOME_PROFILE_D" ]; then
  for i in "$HOME_PROFILE_D"/*.sh; do
    if [ -r "$i" ]; then
      source "$i"
    fi
  done
  unset i
fi

# vim: ft=sh
