#!/bin/bash

# Threshold persen penggunaan disk
THRESHOLD=80

# Email tujuan (opsional)
EMAIL="anakgapesta@gmail.com"

# Subject email alert
SUBJECT="[PERINGATAN] Disk Usage Melebihi ${THRESHOLD}% di $(hostname)"

# Ambil data penggunaan disk
ALERTS=$(df -h --output=target,pcent | tail -n +2 | while read line; do
    USE=$(echo $line | awk '{print $2}' | tr -d '%')
    MOUNT=$(echo $line | awk '{print $1}')
    if [ "$USE" -ge "$THRESHOLD" ]; then
        echo "Mount point $MOUNT menggunakan ${USE}%"
    fi
done)

# Tampilkan dan kirim alert jika ditemukan
if [ -n "$ALERTS" ]; then
    echo "⚠️ Disk usage melebihi batas ${THRESHOLD}%:"
    echo "$ALERTS"
    
    # Kirim email jika tersedia `mail`
    if command -v mail >/dev/null 2>&1; then
        echo "$ALERTS" | mail -s "$SUBJECT" "$EMAIL"
    else
        echo "✉️ Email tidak dikirim: perintah 'mail' tidak ditemukan."
    fi
else
    echo "✅ Semua disk usage aman di bawah ${THRESHOLD}%"
fi
