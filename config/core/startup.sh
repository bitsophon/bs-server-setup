#! /bin/bash
sudo cp -v /home/core/services/bitsophon-*.service /etc/systemd/system
sudo systemctl enable /etc/systemd/system/bitsophon-*.service
sudo systemctl daemon-reload
sudo systemctl restart bitsophon-proxy