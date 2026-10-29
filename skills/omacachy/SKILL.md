---
name: omacachy
description: Instala, mantiene, configura y diagnostica Omarchy sobre CachyOS con omacachy, incluidos actualizaciones, conflictos de paquetes, escritorio y recuperación. Úsala para esta integración o su repositorio; no para Omarchy estándar ni personalización genérica de Linux.
---

# Omacachy

Mantén la integración de Omarchy con CachyOS conservando la propiedad de CachyOS
sobre sus kernels, módulos GPU, repositorios y mecanismos de arranque/recuperación.
Adapta las instrucciones al estado real: el paquete puede usarse en equipos
cifrados o sin cifrar, con distintas GPU y gestores de arranque.

## Contexto y límites

- Ubica el repositorio por el directorio actual o la ruta indicada por el usuario;
  no presupongas un nombre de usuario o ruta de clon. Lee su `AGENTS.md` y
  `handoff.md` antes de modificar código. Los datos de sesiones anteriores son
  evidencia histórica, no una detección del equipo actual.
- Si existe `${XDG_CONFIG_HOME:-$HOME/.config}/omacachy/agent-local.md`, lee solo
  ese perfil local para preferencias y contexto del equipo. No lo exijas ni lo
  crees como requisito. No publiques ni copies su contenido al repositorio;
  verifica sus afirmaciones antes de realizar cambios.
- Revisión/diagnóstico no implica instalación, reinicio, publicación ni escritura
  en servicios externos. Respeta el alcance ya autorizado sin pedir permisos
  repetidos. Instalar el plugin no autoriza ninguna operación sobre el sistema.
- Comienza por observación. Antes de modificar, prepara un cambio concreto y una
  recuperación proporcional. Nunca pidas secretos en el chat ni vuelques
  credenciales. Mantén logs y copias sensibles protegidos y fuera de Git.
- No modifiques `/usr/share/omarchy/` directamente. Para personalización consulta
  la skill Omarchy si está disponible; en su ausencia inspecciona interfaces y
  configuración instaladas, respaldando solo las rutas relevantes.
- Un fallo de permisos del agente no prueba un fallo del equipo. No relajes
  permisos ni elimines protecciones para poder inspeccionar archivos.

## Elegir procedimiento

Lee solo las referencias necesarias:

- Instalar o reconfigurar la integración: [installation.md](references/installation.md).
- Aviso o ejecución de actualizaciones: [updates.md](references/updates.md).
- Errores, comportamiento inesperado o arranque fallido:
  [diagnostics.md](references/diagnostics.md), y si coincide el síntoma,
  [known-errors.md](references/known-errors.md).
- Recuperación: [recovery.md](references/recovery.md).
- Modificar el proyecto: sigue sus instrucciones de desarrollo, pruebas y plan
  de ingeniería; no apliques políticas de personalización a código fuente.

Las referencias del paquete son autocontenidas. Si hay checkout, contrástalas con
su documentación y scripts; si no existe, inspecciona las fuentes instaladas y
expón las limitaciones, sin clonar o instalar automáticamente.

## Resultado

Explica estado comprobado, cambios propuestos o realizados, validación y límites.
Distingue causa confirmada de hipótesis, prueba de fixture de ejecución real y
arranque satisfactorio de recuperación comprobada. Registra errores nuevos como
síntoma, evidencia, causa, solución, validación y alcance; anonimiza ejemplos.
No conviertas una experiencia en un requisito universal sin evidencia.
