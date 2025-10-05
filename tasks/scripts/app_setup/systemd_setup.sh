sudo cp flask-app.service /etc/systemd/system

sudo chmod 644 /etc/systemd/system/flask-app.service

sudo systemctl daemon-reload

sudo systemctl start flask-app.service
sudo systemctl enable flask-app.service
