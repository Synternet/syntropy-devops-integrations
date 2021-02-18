#!/bin/bash
login="$1"

echo "Creating archive .."
zip -r temp.zip .

echo "Transferring archive to server"
scp temp.zip $login