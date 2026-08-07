#!/bin/bash
set -e

# 1. Start the virtual display (no real screen needed)
Xvfb $DISPLAY -screen 0 ${VNC_RESOLUTION}x16 &
sleep 1

# 2. Start the lightweight window manager
fluxbox &
sleep 1

# 3. Start x11vnc pointed at the virtual display
x11vnc -display $DISPLAY -forever -shared -rfbport 5901 \
       -passwd "$VNC_PASSWORD" -bg -o /var/log/x11vnc.log

# 4. Start noVNC (HTML5 client) proxying to the VNC port, self-signed TLS
websockify -D --web=/usr/share/novnc/ --cert=/root/self.pem 6080 localhost:5901 \
  2>/tmp/websockify.log || \
  (openssl req -new -subj "/C=US" -x509 -days 365 -nodes -out /root/self.pem -keyout /root/self.pem && \
   websockify -D --web=/usr/share/novnc/ --cert=/root/self.pem 6080 localhost:5901)

# 5. Launch Firefox inside the virtual display
DISPLAY=$DISPLAY firefox &

echo "Ready. Open: http://localhost:6080/vnc.html  (password: $VNC_PASSWORD)"

tail -f /dev/null
