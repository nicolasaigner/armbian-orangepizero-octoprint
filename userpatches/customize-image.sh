#!/bin/bash

# Instalar as dependências necessárias
apt-get update
apt-get install -y python3 python3-pip python3-flask wireless-tools wpasupplicant hostapd dnsmasq

# Instalar o OctoPrint
#pip3 install octoprint

# Configurar o usuário e a senha
echo "root:1234" | chpasswd
echo "ender ALL=(ALL:ALL) ALL" | (EDITOR="tee -a" visudo)
adduser --disabled-password --gecos "" ender
echo "ender:123" | chpasswd
chsh -s /bin/bash ender

# Configurar o fuso horário
echo "America/Sao_Paulo" >/etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# Configurar a localização
sed -i 's/^# pt_BR.UTF-8 UTF-8$/pt_BR.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
update-locale LANG=pt_BR.UTF-8

# Criar o diretório para o aplicativo Flask
mkdir -p /etc/custom_config_wifi

# Criar o diretório para os templates do Flask
mkdir -p /etc/custom_config_wifi/templates

# Criar o arquivo configuration-wifi.py
cat <<'EOF' >/etc/custom_config_wifi/configuration-wifi.py
from flask import Flask, render_template, request
import subprocess

app = Flask(__name__)

@app.route('/', methods=['GET', 'POST'])
def update_wifi():
    if request.method == 'POST':
        ssid = request.form['ssid']
        password = request.form['password']

        # Atualiza as configurações de WiFi
        with open('/etc/wpa_supplicant/wpa_supplicant.conf', 'a') as f:
            f.write(f'\nnetwork={{\nssid="{ssid}"\npsk="{password}"\n}}')

        # Reinicia o serviço de rede
        subprocess.call(['service', 'networking', 'restart'])

        return 'WiFi atualizado!'
    else:
        return render_template('update_wifi.html')

@app.route('/wifi', methods=['GET'])
def get_wifi():
    # Leia as configurações atuais de WiFi do arquivo /etc/wpa_supplicant/wpa_supplicant.conf
    with open('/etc/wpa_supplicant/wpa_supplicant.conf', 'r') as f:
        return f.read()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# Criar o arquivo update_wifi.html
cat <<'EOF' >/etc/custom_config_wifi/templates/update_wifi.html
<!DOCTYPE html>
<html>
<body>
<form method="post">
    <label for="ssid">SSID:</label><br>
    <input type="text" id="ssid" name="ssid"><br>
    <label for="password">Password:</label><br>
    <input type="password" id="password" name="password"><br>
    <input type="submit" value="Update WiFi Settings">
</form>
</body>
</html>
EOF

# Garantir que o aplicativo Flask seja iniciado na inicialização
echo "@reboot root /usr/bin/python3 /etc/custom_config_wifi/configuration-wifi.py &" >>/etc/crontab

# Configurar o ponto de acesso WiFi
cat <<EOF >/etc/hostapd/hostapd.conf
interface=wlan0
driver=nl80211
ssid=Orange Armbian Octo
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=12345678
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF

# Habilitar o serviço hostapd na inicialização
systemctl enable hostapd

# Configurar o dnsmasq
cat <<EOF >/etc/dnsmasq.conf
interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
EOF

# Habilitar o serviço dnsmasq na inicialização
systemctl enable dnsmasq

# Configurar a interface de rede wlan0
cat <<EOF >/etc/network/interfaces.d/wlan0
auto wlan0
iface wlan0 inet static
    address 192.168.4.1
    netmask 255.255.255.0
EOF

# Reiniciar os serviços de rede
systemctl daemon-reload
systemctl restart networking

# Remove o serviço armbian-firstrun.service
rm /root/.not_logged_in_yet

# Reiniciar o sistema
reboot
