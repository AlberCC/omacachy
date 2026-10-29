# Actualizar Omarchy sobre CachyOS

Ayuda a mantener esta integración sin asumir que una actualización válida para
Omarchy estándar conserva CachyOS. Responde en español salvo preferencia contraria.
Verifica el estado real y las políticas instaladas en cada intervención.
Consulta el perfil local privado solo si existe; no publiques su contenido.

## Alcance y autorización

Un aviso o una consulta de compatibilidad autoriza diagnóstico, no instalación.
Crear esta skill tampoco autoriza actualizar. Si el usuario ya solicita instalar,
continúa dentro de ese alcance sin volver a pedir permiso rutinario. Antes de una
mutación autorizada, presenta el resultado concreto de la revisión y el plan de
recuperación; si no hay autorización de instalación, termina con esa propuesta.
Reiniciar, retirar el cifrado, modificar EFI/UEFI/Windows o publicar en GitHub no
se deduce de una petición de actualización.

## Averiguar qué se actualizaría

1. Lee `AGENTS.md`, `handoff.md` y la documentación de conservación del repo local
   en el checkout si existe. Para personalizar el sistema usa también la skill
   `omarchy` disponible. No edites el árbol empaquetado `/usr/share/omarchy/`.
2. Comprueba paquetes instalados, kernels, servicios de login, repositorios,
   hooks mkinitcpio/pacman y protecciones efectivas; no confíes solo en el código
   del instalador. Usa consultas sin modificar configuración ni paquetes.
3. Distingue actualizaciones de aplicaciones, sistema/kernel y paquetes Omarchy.
   `pacman -Qu` y `pacman -Si` consultan bases locales que pueden estar obsoletas.
   Para información fresca, usa `checkupdates` si está disponible: refresca una
   base separada, no la de `/var/lib/pacman`. Distingue su salida sin novedades de
   un fallo de red. No instales herramientas solo para diagnosticar. Si hace falta,
   descarga bases/paquetes oficiales a un temporal aislado sin instalarlos ni
   ejecutar scriptlets. Declara cualquier límite de frescura.
4. Consulta notas y código oficiales de la versión candidata. Revisa el contenido
   real de los paquetes y migraciones relevantes, no solo el changelog ni un diff
   entre etiquetas que podría no corresponder al paquete. Verifica firmas con
   claves de confianza existentes antes de usar los paquetes para instalar;
   no debilites `SigLevel` ni aceptes claves sin comprobar su procedencia.

No ejecutes `pacman -Sy` sobre las bases reales para mirar novedades; evita la
ventana de actualización parcial. No uses `omarchy update` como simulación:
puede podar caché, escribir snapshots, actualizar claves y después instalar y
migrar. Ni `--dry-run` del instalador ni una simulación de pacman prueban scripts,
transacciones completas o arranque.

## Decidir compatibilidad

Revisa si la transacción o sus migraciones tocan:

- kernels CachyOS, módulos NVIDIA para cada kernel y `nvidia-utils` compatible;
- `sd-encrypt`, parámetros LUKS, hooks y presets de mkinitcpio;
- Limine, generación de imágenes/entradas y hooks de despliegue EFI;
- repositorios y mirrorlists CachyOS, Snapper y su integración de restauración;
- SDDM, sesión Omarchy/uwsm, inicio automático y configuración de usuario.

Las protecciones son barreras parciales, no una prueba de compatibilidad. Un
bloqueo de versión significa «sin revisar», no necesariamente «incompatible».
No borres hooks, no ignores paquetes con `IgnorePkg`, no fuerces conflictos ni
sustituyas kernels para conseguir que la actualización pase. No cambies el pin de
versión solo porque el número sea mayor. Una nueva versión requiere revisar el
paquete y sus migraciones, adaptar la política de forma acotada, respaldarla y
validarla antes de instalar. Si no puede conservarse la integración, explica el
bloqueo y propone una corrección revisable; no repitas la misma actualización.

Entrega una conclusión breve: lista/versiones candidatas y frescura de la
consulta, compatible/bloqueada/pendiente de evidencia, cambios relevantes y
siguiente paso. No declares «segura» una actualización solo por pasar fixtures.
No mantengas el equipo congelado indefinidamente: concreta qué revisión o arreglo
permitiría retomar las actualizaciones.

## Si la instalación está autorizada

- Comprueba espacio y salud del estado de paquetes, sin otra transacción activa.
  Prepara un snapshot raíz identificado y confirmado, sin limpieza automática,
  más copias de `/boot`, configuración relevante y listado de paquetes fuera del
  subvolumen raíz. No incluyas almacenes de credenciales ni solicites contraseñas
  LUKS; `/boot` puede contener material sensible en initramfs: copias protegidas.
  Confirma que hay acceso a TTY, entrada de kernel alternativa y medio live.
  Explica lo que el snapshot no restaura (HOME y la partición de arranque).
- Inspecciona el actualizador y la vía de migraciones instalada antes de elegir
  el comando. Prefiere el flujo Omarchy revisado que ejecuta las migraciones;
  una transacción directa de pacman no es equivalente. No desactives guards
  ni hagas una actualización parcial para sortear un error. Si el flujo requiere
  corregirse, prepara y valida esa corrección antes de ejecutarlo.
- Ejecuta en una terminal con autenticación del usuario; no recojas contraseñas
  en el chat. Conserva un log con permisos apropiados. Ante fallo, detente,
  determina las fases ya ejecutadas y el estado de paquetes/imágenes; no
  reinicies ni reintentes a ciegas.
- Verifica versiones, preservación de repositorios y guards, imágenes reales
  para todos los kernels CachyOS, disponibilidad de módulos NVIDIA y soporte
  cryptsetup en initramfs. Un código cero de `limine-mkinitcpio` no demuestra
  que todas las imágenes se hayan generado. Compara inventario/checksums EFI
  antes/después sin escribir EFI; investiga diferencias inesperadas.
- Revisa errores nuevos de servicios y Hyprland. Distingue fallos anteriores.
  No reinicies sin autorización; tras un reinicio autorizado comprueba kernel
  activo, NVIDIA, LUKS, acceso al escritorio y las funciones que el usuario pruebe.
  Marca lo no probado, incluida restauración y arranque alternativo.
- Registra fecha, versiones origen/destino, política revisada, snapshot/copia,
  resultado y límites en documentación local apropiada. No publiques datos del
  equipo ni logs automáticamente. No uses `snapper rollback` a ciegas: coordina
  raíz, módulos y `/boot` con el procedimiento CachyOS instalado.
