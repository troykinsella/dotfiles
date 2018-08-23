#!/usr/bin/env bash

set -e

readonly ENC_DIR=~/.encrypted
readonly DEC_DIR=~/.decrypted
readonly ENCFS_MOUNT=~/bin/mount-encfs
readonly ENCFS_UMOUNT=~/bin/umount-encfs
readonly ENCFS_PASSWD=~/bin/encfs-passwd

test "$(id -u)" = "0" && { echo "do not run as root" >&2; exit 1; }

sudo apt install -y encfs
mkdir -p ~/bin
mkdir -p $ENC_DIR
mkdir -p $DEC_DIR

cat <<EOF > $ENCFS_MOUNT
#!/usr/bin/env bash
if ! mount | grep "encfs on $DEC_DIR type fuse.encfs" > /dev/null; then
  encfs --standard $ENC_DIR $DEC_DIR
else
  echo Already mounted, stupid
fi
EOF

cat <<EOF > $ENCFS_UMOUNT
#!/usr/bin/env bash
fusermount -u $DEC_DIR
EOF

cat <<EOF > $ENCFS_PASSWD
#!/usr/bin/env bash
encfsctl passwd $ENC_DIR
EOF

chmod +x $ENCFS_MOUNT $ENCFS_UMOUNT $ENCFS_PASSWD
$ENCFS_MOUNT # run it
