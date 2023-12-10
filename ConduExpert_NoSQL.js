use condu_expert

db.createCollection('academias')
db.createCollection('instructores')
db.createCollection('estudiantes')
db.estudiantes.aggregate([{$group: {_id: '$cedula'}}])
db.createCollection('')
db.createCollection('')
db.createCollection('')
db.createCollection('')
db.createCollection('')
db.createCollection('')