# Diagnóstico

Identifica la fase: paquetes, aplicación de sistema, perfil, initramfs, arranque,
greeter o sesión. Recoge el error exacto y el último log pertinente, con contexto
acotado y sin secretos; no hagas dumps completos de HOME o `/etc`.

Consultas orientativas, según el síntoma:

```bash
pacman -Q omarchy omarchy-settings
uname -r
pacman -Qq | rg '^(linux-cachyos|nvidia)'
readlink -f /etc/systemd/system/display-manager.service
systemctl --failed
systemctl --user --failed
lsblk -o NAME,TYPE,FSTYPE,MOUNTPOINTS
```

Usa `pacman -Qo RUTA` para conflictos de propiedad, consultas de dependencias
para retiradas, `journalctl -b -u UNIDAD` para un servicio concreto y
`hyprctl configerrors` en una sesión disponible. Acota las salidas antes de
compartirlas; un log puede contener datos personales. No ejecutes binarios del
repo desconocidos como simples consultas sin leer su código.

Compara estado instalado, código del wrapper y documentación de la versión.
Propón una reparación pequeña basada en evidencia y comprueba su resultado antes
de ampliar el alcance. Ante crash/core dump usa la skill de diagnóstico si está
disponible; no envíes dumps a terceros automáticamente.

Si una reparación falla, determina qué cambió y conserva evidencia. No repitas
el instalador, reconstruyas imágenes o reinicies como prueba genérica. Actualiza
el catálogo de errores solo con causas y resultados comprobados, sin identidad,
UUID reales, números de serie, tokens ni rutas personales.
