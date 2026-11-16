# Restore a LUKS header

The LUKS header of an encrypted partition holds the key slots. If the header is damaged, you cannot open the partition, even with the correct passphrase.

The backup copies in `/var/lib/luks-header` are on the encrypted root partition. If the root partition does not open, get the copies from the restic repository. `restic-sys` and `/etc/restic/restic.env` are also on the encrypted disk, so you use plain `restic` from a live USB system.

The copies open the partition with each passphrase that was valid when the copy was made, also after you removed that passphrase. Delete the restored files after you use them.

## Get the copies from restic

1. Start the computer from an Arch Linux live USB system and connect to the internet.
2. Install restic:

   ```sh
   pacman -Sy restic
   ```

3. Get these values from the 1Password item that `restic.env` points to:
   - the repository address, for example `gs:<bucket>:/<path>`,
   - the repository password,
   - the JSON key of the Google Cloud service account.
4. Save the JSON key to `/tmp/gcs-key.json`. Then set the values:

   ```sh
   export RESTIC_REPOSITORY='gs:<bucket>:/<path>'
   export RESTIC_PASSWORD='<password>'
   export GOOGLE_APPLICATION_CREDENTIALS=/tmp/gcs-key.json
   ```

5. Restore the copies. This command writes the files to `/tmp/restore/var/lib/luks-header`:

   ```sh
   restic restore latest --include /var/lib/luks-header --target /tmp/restore
   ```

## Write the header back

1. Find the partition of the damaged header in `partitions.txt`. Each line has the UUID, the partition, and the mapper name. The file name of the copy is the UUID of the partition. The partition names can change between boots, so compare them with the output of `lsblk`.
2. Make sure that the copy is the header of the partition. The UUID in the output must be the same as the UUID in the file name:

   ```sh
   cryptsetup luksDump /tmp/restore/var/lib/luks-header/<uuid>.img
   ```

3. Write the header to the partition. The command does not change the data on the partition:

   ```sh
   cryptsetup luksHeaderRestore <partition> --header-backup-file /tmp/restore/var/lib/luks-header/<uuid>.img
   ```

4. Make sure that your passphrase opens the partition:

   ```sh
   cryptsetup open --test-passphrase <partition>
   ```

For more information, see [Restore using cryptsetup](https://wiki.archlinux.org/title/Dm-crypt/Device_encryption#Restore_using_cryptsetup) in the Arch wiki.
