# Instalación y configuración

Determina distribución, versiones, GPU, kernel, gestor de arranque, cifrado,
subvolúmenes y gestor de acceso reales. En un checkout lee
`docs/install-cachyos-preserved.md` y el instalador antes de proponer ejecutarlo.
`--preserve-cachyos` es opt-in, su implementación inicial está limitada a
CachyOS con Limine y Snapper configurado para raíz. No extrapoles ese soporte a
GRUB/systemd-boot, otras versiones Omarchy o configuraciones sin Snapper.

Comprueba las restricciones de versión en código y paquetes candidatos. No
conviertas el pin inicial 4.0.6-1 en una promesa de soporte futuro. Verifica copia
de arranque/escritorio y snapshot, y explica que no constituyen un backup completo.
No ejecutes instaladores al revisar una instalación. Si se autoriza instalar,
usa una terminal donde el usuario pueda autenticarse, detente ante errores y
valida antes de reiniciar o cambiar el gestor de acceso.

Preserva kernels, repositorios y GPU CachyOS. No fuerces `--overwrite` para
conflictos entre paquetes. Comprueba propietarios y dependencias. La sustitución
de presets requiere copia y conservar los archivos usados por el greeter.

Para cambiar SDDM/greetd comprueba el enlace `display-manager.service`, la sesión
real y archivos `.desktop`; no supongas que están solo en `/usr/share`: SDDM
puede buscar también en `/usr/local/share/wayland-sessions`. No reinicies el
servicio en una sesión activa como forma de aplicar un ajuste para el siguiente
arranque. El inicio automático es una preferencia explícita, no parte obligatoria
de instalar Omacachy; no sustituye el desbloqueo LUKS.
