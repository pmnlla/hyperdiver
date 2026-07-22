command -v gum &>/dev/null
gum_installed=$?

# ---- ALERT COMMAND ----
if [ "$1" == "alert" ]; then
    if [ $gum_installed -eq 0 ]; then  # 0 is true in this specific case:; 1 is an exit code.
        gum log --time timeonly --level "$2" "$3"
    else 
        echo "$2 | $3"
    fi
fi

# ---- ASK COMMAND ----
if [ "$1" == "ask" ]; then
    if [ $gum_installed -eq 0 ]; then 
        gum confirm "$2"
        exit $?
    else
        echo "PROMPT | $2 (y/n)"
        read -r confirm
        if [ "$confirm" == "y" ]; then
            exit 0
        else
            exit 1
        fi
    fi
fi
