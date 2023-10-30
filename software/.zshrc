source ~/.powerlevel10k/powerlevel10k.zsh-theme
source ~/.zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH=${PATH}:/home/amstrad/.local/bin
export ENVIRONMENT="DOCKER"
# configurate git

if [ -n "$GIT_USER_NAME" ]; then
    git config --global user.name "$GIT_USER_NAME"
fi

if [ -n "$GIT_USER_EMAIL" ]; then
    git config --global user.email "$GIT_USER_EMAIL"
fi

if [ -n "$TYPE_DEVELOPEER" ]; then
    git config --global user.email "$GIT_USER_EMAIL"
fi

# if [ "$$TYPE_DEVELOPER" = "TEST" ]; then
#     source /usr/local/bin/test.sh
# else
#     source /usr/local/bin/develop.sh
# fi


