FROM alpine:3.20

ENV HOME=/root \
    DISPLAY=:1 \
    VNC_RESOLUTION=1280x720 \
    VNC_PASSWORD=changeme

# Install a minimal graphical stack:
# - Xvfb: virtual framebuffer (no real GPU/display needed)
# - Fluxbox: extremely lightweight window manager
# - x11vnc: exposes the X session over VNC
# - noVNC + websockify: browser-based VNC client (HTML5)
# - firefox: the only "app" installed
RUN apk add --no-cache \
    xvfb \
    fluxbox \
    x11vnc \
    firefox \
    novnc \
    websockify \
    bash \
    supervisor \
    ttf-dejavu \
    xterm \
    net-tools

# noVNC web files (apk package already installs them under /usr/share/novnc typically;
# this symlink keeps the classic /vnc.html path working across Alpine versions)
RUN mkdir -p /usr/share/novnc && \
    ln -sf /usr/share/novnc/vnc_lite.html /usr/share/novnc/vnc.html 2>/dev/null || true

# Minimal Fluxbox config (keeps startup fast, no heavy menus/themes)
RUN mkdir -p /root/.fluxbox && \
    echo "session.screen0.toolbar.visible: true" > /root/.fluxbox/init

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 6080 5901

CMD ["/start.sh"]
