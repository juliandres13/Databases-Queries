## Importar colecciones dentro de la base de datos ConduExpert:
1. Antes recordar iniciar el comando 'mongod' para hacer las importaciones de las colecciones a la DB por consola:

mongoimport --db condu_expert --collection academias --drop --file tu_ruta_al_archivo_academias.json 

mongoimport --db condu_expert --collection clases --drop --file tu_ruta_al_archivo_clases.json 

mongoimport --db condu_expert --collection compras --drop --file tu_ruta_al_archivo_compras.json 

mongoimport --db condu_expert --collection estudiantes --drop --file tu_ruta_al_archivo_estudiantes.json 

mongoimport --db condu_expert --collection examenes --drop --file tu_ruta_al_archivo_examenes.json 

mongoimport --db condu_expert --collection facturas --drop --file tu_ruta_al_archivo_facturas_pagos.json 

mongoimport --db condu_expert --collection instructores --drop --file tu_ruta_al_archivo_instructores.json 

mongoimport --db condu_expert --collection lecciones --drop --file tu_ruta_al_archivo_lecciones.json 

mongoimport --db condu_expert --collection salones --drop --file tu_ruta_al_archivo_salones.json 

mongoimport --db condu_expert --collection vehiculos --drop --file tu_ruta_al_archivo_vehiculos.json 

mongoimport --db condu_expert --collection temas_clase --drop --file tu_ruta_al_archivo_temas_clase.json 

mongoimport --db condu_expert --collection temas_leccion --drop --file tu_ruta_al_archivo_temas_leccion.json

mongoimport --db condu_expert --collection asistencia_clases --drop --file tu_ruta_al_archivo_asistencia_clases.json 

mongoimport --db condu_expert --collection asistencia_lecciones --drop --file tu_ruta_al_archivo_asistencia_lecciones.json 
