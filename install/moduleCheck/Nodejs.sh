echo "Checking for Nodejs..."
if command -v node >/dev/null; then
    echo "Detected Nodejs..."
else
    echo "Installing Nodejs"
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    apt install -y nodejs
fi
