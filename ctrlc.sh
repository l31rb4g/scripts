while read line; do
    echo -n $line | xclip -i -selection clipboard
done
