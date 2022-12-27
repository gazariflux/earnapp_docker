# Unofficial docker image for earnapp.


This image does not require to have privileged mode or systemd for running.


At first launch, earnapp is initialized and will send you a notification with the link to use to register instance.


Example:

    docker run \
        -e NOTIFY_DISCORD_WEBHOOK_URL="<DISCORD_WEBHOOK_URL>" \
        -e NOTFY_TELEGRAM_WEBHOOK_URL="https://api.telegram.org/bot<YourBOTToken>/sendMessage?chat_id=<channel_id>&text=" \
        gazari/earnapp_docker:latest

