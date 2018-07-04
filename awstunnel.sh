
while true; do
    echo '>>> Opening tunnel on port 2222'
    ssh -R 0.0.0.0:2222:localhost:22 paladino.pro
    echo -e '\n>>> Connection closed, retrying in 2 seconds...'
    sleep 2
done

