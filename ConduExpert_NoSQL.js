// Para todas las consultas

use condu_expert

db.createCollection('academias')

db.createCollection('instructores')

db.createCollection('estudiantes')

db.createCollection('salones')

db.createCollection('vehiculos')

db.estudiantes.aggregate([{$group: {_id: '$cedula'}}])