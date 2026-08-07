# lite-desktop

نسخة خفيفة جدًا من فكرة "سطح مكتب Linux يعمل عبر المتصفح" — مبنية على
Alpine Linux + Xvfb + Fluxbox + noVNC بدلاً من Ubuntu + XFCE + systemd + snapd،
ما يقلل حجم الصورة بشكل كبير وسرعة الإقلاع.

## المكونات
- **Alpine 3.20** بدلاً من Ubuntu 22.04 (حجم أساسي أصغر بكثير)
- **Xvfb** بدل تشغيل سيرفر عرض حقيقي
- **Fluxbox** بدل XFCE (مدير نوافذ بسيط جدًا بدون تأثيرات)
- **x11vnc + noVNC + websockify** للوصول عبر المتصفح
- **Firefox** فقط (بدون snapd أو أدوات نظام إضافية)

## البناء
```bash
docker build . -t lite-desktop
```

## التشغيل
```bash
docker run -it -p 6080:6080 -p 5901:5901 \
  -e VNC_PASSWORD=yourpassword \
  lite-desktop
```

## الوصول
افتح المتصفح على:
```
http://localhost:6080/vnc.html
```
واستخدم كلمة المرور التي حددتها في `VNC_PASSWORD`.

## ملاحظات
- الدقة الافتراضية 1280x720، يمكن تغييرها عبر متغير `VNC_RESOLUTION`.
- لا يوجد systemd ولا snapd ولا صلاحيات sudo داخل الحاوية — الهدف الخفة فقط.
- يمكنك استبدال `firefox` بأي تطبيق آخر خفيف في الـ Dockerfile إذا أردت.
