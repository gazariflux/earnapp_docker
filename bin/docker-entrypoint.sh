#!/usr/bin/env bash

function run_earnapp_install {
    echo "Prepare installation of earnapp."
    curl -sL https://brightdata.com/static/earnapp/install.sh > /tmp/earnapp.sh
    grep -E "^(BASE_URL|VERSION|OS_NAME|OS_ARCH)" /tmp/earnapp.sh > /tmp/earnapp_vars.sh
    PRODUCT="earnapp"
    source /tmp/earnapp_vars.sh

    if [ "$OS_ARCH" = "x86_64" ]; then
        file=$PRODUCT-x64-$VERSION
    elif [ "$OS_ARCH" = "amd64" ]; then
        file=$PRODUCT-x64-$VERSION
    elif [ "$OS_ARCH" = "armv7l" ]; then
        file=$PRODUCT-arm7l-$VERSION
    elif [ "$OS_ARCH" = "armv6l" ]; then
        file=$PRODUCT-arm7l-$VERSION
    elif [ "$OS_ARCH" = "aarch64" ]; then
        file=$PRODUCT-aarch64-$VERSION
    elif [ "$OS_ARCH" = "arm64" ]; then
        file=$PRODUCT-aarch64-$VERSION
    else
        # perr "10_arch_other" "$OS_ARCH"
        file=$PRODUCT-arm7l-$VERSION
    fi

    curl -sL "${BASE_URL}/${file}" > "/tmp/earnapp" 
    chmod +x /tmp/earnapp
    /tmp/earnapp install --auto 2>&1 | tee /tmp/earnapp_install.log
    echo "Installation is done."    
}

if [[ ! -f /etc/earnapp/uuid ]];
then
    echo "First run"
    run_earnapp_install
    # notify user to register instance.
    NODE_SDK_UUID=$(cat /etc/earnapp/uuid)
    MESSAGE="Your earnapp instance is installed and will start soon. Use this link to register instance: https://earnapp.com/r/${NODE_SDK_UUID}"

    if [[ -z "${NOTIFY_DISCORD_WEBHOOK_URL}" ]]; then
        echo "NOTIFY_DISCORD_WEBHOOK_URL is not set."
    else
        echo "Sending notification to discord."
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"${MESSAGE}\" }" "${NOTIFY_DISCORD_WEBHOOK_URL}"
    fi

    if [[ -z "${NOTFY_TELEGRAM_WEBHOOK_URL}" ]]; then
        echo "NOTFY_TELEGRAM_WEBHOOK_URL is not set."
    else
        echo "Sending notification to telegram."
        curl "${NOTFY_TELEGRAM_WEBHOOK_URL}${MESSAGE}"
    fi
elif [[ ! -f /usr/bin/earnapp ]];
then
    echo "Found configuration but no earnapp binary."
    run_earnapp_install
fi

echo "Starting earnapp."
nohup /usr/bin/earnapp run
