# Recuperación

Primero determina si falla el arranque, el kernel, el greeter o solo el perfil.
Con escritorio averiado intenta una TTY; con fallo del kernel considera una
entrada alternativa existente, si está disponible. No prometas que el kernel LTS
o un snapshot funcionan si no se han probado.

Identifica snapshot raíz, copias de `/boot` y perfil, versiones de paquetes y
subvolúmenes. Las copias en el mismo disco no cubren avería física; el snapshot
raíz suele excluir HOME y FAT32. Restaurar raíz puede dejar módulos y `/boot`
incoherentes. Inspecciona la integración CachyOS `limine-snapper-restore` instalada
antes de usarla; no apliques `snapper rollback` a ciegas con `subvol=/@`.

Si necesitas live USB, identifica particiones Linux con consultas de solo lectura
antes de proponer montaje o desbloqueo. Usa marcadores genéricos en instrucciones
compartidas y confirma el destino real antes de ejecutar. No escribas Windows,
EFI o UEFI por deducción. Nunca formatees como primer intento de reparación.

Para recuperar perfil conserva primero evidencia, distingue sobrescrituras de
archivos añadidos y evita extraer archivos sobre HOME sin revisar miembros y
rutas. Revisa qué efectos del instalador/importador quedan fuera de su rollback.
Para volver a otro gestor de acceso comprueba dependencias y configuración y
programa el cambio para el siguiente arranque sin cerrar la sesión activa.

Resume la recuperación propuesta, los datos preservados, la autorización
existente y las comprobaciones posteriores. Si falta acceso o evidencia, indica
la limitación concreta; no improvises una restauración destructiva.
