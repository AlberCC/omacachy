# Instalar Omarchy conservando CachyOS

Preparación del 2026-10-29 para Omarchy y omarchy-settings **4.0.6-1**, la
versión publicada en stable. La exportación de 4.0.4 se importa después.

## Alcance

`--preserve-cachyos` es nuevo: tiene pruebas de fixtures y revisión de los
paquetes reales descargados y una instalación en hardware completada con
19 PASS y 0 FAIL. El operador confirmó el arranque y el acceso al escritorio
tras reiniciar. La recuperación, el kernel LTS y las actualizaciones futuras
siguen sin validarse en este equipo.
Instala Omarchy y aplicaciones, modifica configuraciones y regenera initramfs
y entradas Linux de Limine. `pacman -Syu` también actualiza CachyOS: conserva
su familia de kernel, no una versión numérica congelada.

El modo exige CachyOS con Limine y Snapper para `/`. Antes de instalar:

- Copia `/boot` y `.config/{hypr,noctalia,uwsm}` a
  `~/.local/state/omacachy/recovery/FECHA/` (o bajo `$XDG_STATE_HOME`).
- Crea un snapshot raíz obligatorio en cada ejecución, sin limpieza automática.
- Instala barreras persistentes contra kernels convencionales ajenos a CachyOS,
  sustituciones NVIDIA y versiones Omarchy no revisadas.
- Inhibe el hook de despliegue EFI; conserva la generación de imágenes y entradas.
- Ejecuta una copia temporal root-owned del árbol de instalación: omite NVIDIA,
  sustitución de Snapper y reset de pacman. No edita los originales upstream.
- Omite `omarchy-refresh-limine` y difiere la habilitación de SDDM.
- Retira solo los paquetes de presets `cachyos-hypr-noctalia` y
  `cachyos-alacritty-config` si están instalados, porque comparten archivos
  de `/etc/skel` con Omarchy. Guarda skel y conserva los archivos de su
  greeter y entorno NVIDIA fuera de skel. No elimina Noctalia, greetd,
  Hyprland ni dependencias mediante retirada recursiva.

Las barreras no bloquean cualquier escritura posible de una migración ni
validan un `pacman -U` arbitrario. Una actualización futura puede detenerse
tras otros cambios; requiere revisión. No retirar los hooks para forzarla.
Las copias están en el mismo disco: copiarlas fuera para cubrir avería física.
No constituyen backup completo de HOME. El seeding también copia las rutas
existentes de HOME que `/etc/skel` va a sobrescribir a su propio directorio
de backup, sin recorrer los demás contenidos de `.local` o `.config`.

## Instalar desde tu terminal

Guardar el trabajo y usar una TTY (`Ctrl+Alt+F3`), entrando como el usuario
habitual. Tener disponible un USB live y conocer la contraseña LUKS.

```bash
cd ~/omacachy
bash bin/install-omarchy-quattro.sh --preserve-cachyos
```

No usar `sudo bash`, `--autologin` ni `--skip-user-configs` para este primer
escritorio completo. La autenticación sudo ocurre en esa terminal. El script
presenta el resumen y pide continuar. No reiniciar ante un error ni forzar
conflictos de paquetes: conservar la salida y revisar el log indicado.
No hay rollback automático. Anotar el directorio de recuperación y snapshot.

## Checkpoint antes del login

```bash
bash bin/install-omarchy-quattro.sh --preserve-cachyos --verify-only
pacman -Q linux-cachyos linux-cachyos-lts linux-cachyos-nvidia-open linux-cachyos-lts-nvidia-open
sudo limine-entry-tool --tree
sudo snapper --no-dbus -c root list
systemctl is-active greetd sddm
```

Confirmar entradas CachyOS y LTS, imágenes reales, hooks systemd/sd-encrypt y
módulos NVIDIA para los kernels instalados. Resolver cualquier FAIL o PASS
que diga "not verified". `--verify-only` escribe un log.

Solo tras validar el resultado, seleccionar SDDM para el siguiente arranque:

```bash
sudo systemctl disable greetd.service
sudo systemctl enable --force sddm.service
```

Sin `--now`: no se cierra la sesión actual. `--force` sustituye el enlace
`display-manager.service`. No habilitar ambos gestores simultáneamente.
El primer reinicio es un checkpoint manual, no parte del instalador.

## Validar después de reiniciar

```bash
uname -r
nvidia-smi
hyprctl configerrors
systemctl --failed
systemctl --user --failed
```

Probar LUKS, pantallas, audio, red, suspensión, bloqueo y captura. Debe
ejecutarse un único shell, Omarchy o Noctalia. Probar también el kernel LTS.
Después validar checksum y manifest del USB e importar configuraciones por
grupos, conservando monitores y GPU del destino. Revisar paquetes, mise y
servicios después; el rollback del importador no revierte todos sus efectos.

## Recuperar

Si falla el escritorio, usar una TTY y reparar el perfil desde `desktop.tar`
o el backup del seeding. Extraer encima no elimina archivos nuevos Omarchy.
Tras reparar el perfil, volver a greetd para el siguiente arranque:

```bash
sudo systemctl disable sddm.service
sudo systemctl enable --force greetd.service
```

Si falla Linux, intentar CachyOS LTS y el snapshot anterior desde Limine.
`limine-snapper-restore` restaura el snapshot arrancado mediante la integración
CachyOS. No aplicar `snapper rollback` a ciegas con `subvol=/@`.

Si no arranca Limine, usar el USB live. Diagnóstico inicial de solo lectura
sustituyendo `/dev/PARTICION_LUKS` por la partición Linux cifrada correcta:

```bash
sudo cryptsetup open --readonly /dev/PARTICION_LUKS rescue-root
sudo mount -o ro,subvolid=5 /dev/mapper/rescue-root /mnt
sudo btrfs subvolume list /mnt
```

Identificar el snapshot y coordinar raíz, módulos e imágenes de `/boot` antes
de restaurar. El snapshot excluye HOME y FAT32. No montar ni modificar Windows,
formatear EFI o cambiar UEFI como primer intento.

`omarchy update` actualiza el único sistema de paquetes compartido y ejecuta
migraciones. Las nuevas barreras limitan cambios concretos; cualquier nueva
versión Omarchy debe revisarse antes de levantar su bloqueo.
