
NEW_USER=$1

# Check if user already exists
if id "$NEW_USER" &>/dev/null; then
    echo "✅ User '$NEW_USER' already exists. Skipping creation."
    exit 0
fi

echo "ℹ️ Creating user '$NEW_USER'..."

# Create user with home dir and bash shell
useradd -m -s /bin/bash "$NEW_USER"

# Add user to sudo group
# usermod -aG sudo "$NEW_USER"

echo "✅ User '$NEW_USER' created and added to sudo group."

# Create SSH directory for new user
mkdir -p /home/"$NEW_USER"/.ssh
chmod 700 /home/"$NEW_USER"/.ssh

# Copy authorized_keys from root
cp /root/.ssh/authorized_keys /home/"$NEW_USER"/.ssh/authorized_keys
chmod 600 /home/"$NEW_USER"/.ssh/authorized_keys
chown -R "$NEW_USER":"$NEW_USER" /home/"$NEW_USER"/.ssh

cp /root/.condarc /home/"$NEW_USER"/.
chown "$NEW_USER":"$NEW_USER" /home/"$NEW_USER"/.condarc

cp /root/.bashrc /home/"$NEW_USER"/.
chown "$NEW_USER":"$NEW_USER" /home/"$NEW_USER"/.bashrc
