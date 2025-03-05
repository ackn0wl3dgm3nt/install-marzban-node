#!/bin/bash

# Update and install required packages
apt update && apt upgrade -y
apt install sudo curl nano ufw -y

# Ask for IP address
read -p "Enter the allowed IP for UFW rules: " ALLOWED_IP

# Install Marzban Node step by step
echo -e "\n" | sudo bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/master/marzban-node.sh)" @ install <<EOF
Y




EOF

# Install Caddy
curl -sSL https://raw.githubusercontent.com/ackn0wl3dgm3nt/install-caddy/main/install.sh | bash

# Configure Caddy
echo "Paste your Caddyfile configuration (end with an empty line and press ENTER):"
USER_CONFIG=""
while IFS= read -r line; do
    [[ -z "$line" ]] && break  # Stop reading on an empty line
    USER_CONFIG+="$line"$'\n'
done
echo "$USER_CONFIG" | sudo tee /etc/caddy/Caddyfile > /dev/null

# Restart Caddy
systemctl restart caddy

# Configure UFW
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80
ufw allow from "$ALLOWED_IP" to any port 62050
ufw allow from "$ALLOWED_IP" to any port 62051
ufw enable
ufw reload

echo "Setup completed successfully!"
