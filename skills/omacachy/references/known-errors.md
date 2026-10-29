# Errores y comportamientos conocidos

Casos observados durante la integración con Omarchy 4.0.6-1. Comprueba que la
versión actual siga teniendo la misma ruta de código antes de aplicar soluciones.

## Pacman rechaza archivos de /etc/skel ya presentes

- Síntoma: la transacción Omarchy aborta por archivos propiedad de otros paquetes.
- Confirmación: `pacman -Qo` atribuye las rutas a `cachyos-hypr-noctalia` o
  `cachyos-alacritty-config`; consultar dependencias y scriptlets instalados.
- Causa observada: ambos presets comparten rutas de skel con Omarchy.
- Corrección implementada: respaldar skel y archivos externos necesarios para
  greeter/perfil; retirar solo esos presets sin retirada recursiva ni forzar
  dependencias. Conservar Noctalia, greetd e Hyprland.
- Validación: transacción sin conflictos y archivos del greeter conservados.
  No asumir que un aborto significa que todo el instalador quedó sin cambios:
  snapshots, copias y pasos anteriores pueden haberse ejecutado.

## Respaldo del perfil falla con Permission denied en .local

- Síntoma: seeding aborta intentando copiar copias de recuperación protegidas.
- Causa observada: el respaldo copiaba todo `.local` al encontrarlo en skel.
- Corrección implementada: `backup_skel_collisions` enumera solo hojas que skel
  va a sobrescribir, incluidos enlaces rotos, y conserva sus rutas existentes.
- Validación: prueba de regresión con archivo de recuperación no legible, sin
  copiarlo ni modificar sus permisos. No aplicar `chmod`/`chown` recursivo a HOME.

## package-guard rechaza una versión de Omarchy

El pin exige una versión revisada; el rechazo no demuestra incompatibilidad.
Lee [updates.md](updates.md), revisa candidatos y migraciones y adapta la política
solo con evidencia. No borres el hook ni cambies el número para forzar el paso.

## Dos peticiones de contraseña durante el arranque

Si una desbloquea LUKS y otra inicia sesión, son funciones independientes, no un
fallo del instalador. El autologin puede eliminar la segunda si el usuario lo
solicita. No descifres el disco como arreglo rutinario. Si las dos pertenecen a
LUKS o aparece otra petición de llavero, diagnostica esa secuencia por separado.
