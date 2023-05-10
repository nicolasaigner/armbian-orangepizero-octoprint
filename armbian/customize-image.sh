#!/bin/bash

# Instalar as dependências necessárias
apt-get update
apt-get install -y python3 python3-pip python3-flask wireless-tools wpasupplicant

# Instalar o OctoPrint
pip3 install octoprint

# Criar o diretório para o aplicativo Flask
mkdir -p /etc/custom_config_wifi

# Criar o diretório para os templates do Flask
mkdir -p /etc/custom_config_wifi/templates

# Criar o arquivo configuration-wifi.py
cat << 'EOF' > /etc/custom_config_wifi/configuration-wifi.py
from flask import Flask, render_template, request
import subprocess

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def configure_wifi():
    if request.method == 'POST':
        ssid = request.form['ssid']
        password = request.form['password']

        # Atualiza as configurações de WiFi
        with open('/etc/wpa_supplicant/wpa_supplicant.conf', 'a') as f:
            f.write(f'\nnetwork={{\nssid="{ssid}"\npsk="{password}"\n}}')

        # Reinicia o serviço de rede
        subprocess.call(['service', 'networking', 'restart'])

        return 'WiFi configurado!'
    else:
        # Liste todas as redes WiFi disponíveis
        networks = subprocess.check_output(['iw', 'wlan0', 'scan', '|', 'grep', 'SSID'])
        return render_template('configure_wifi.html', networks=networks)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
EOF

# Criar o arquivo configure_wifi.html
cat << 'EOF' > /etc/custom_config_wifi/templates/configure_wifi.html
<!DOCTYPE html>
<html>
<body>
<form method="post">
    <label for="ssid">SSID:</label><br>
    <input type="text" id="ssid" name="ssid"><br>
    <label for="password">Password:</label><br>
    <input type="password" id="password" name="password"><br>
    <input type="submit" value="Conectar">
</form>
</body>
</html>
EOF

# Garantir que o aplicativo Flask seja iniciado na inicialização
echo "@reboot root /usr/bin/python3 /etc/custom_config_wifi/configuration-wifi.py &" >> /etc/crontab
