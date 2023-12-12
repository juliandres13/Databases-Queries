// ¿Cual es el instructor que mas lecciones ha impartido?

db.lecciones.aggregate([
  {
    $group: {
      _id: "$cedula_instructor",

      cantidad_lecciones: { $sum: 1 },
    },
  },

  {
    $sort: { cantidad_lecciones: -1 },
  },

  { $limit: 10 },

  {
    $project: {
      _id: 0,

      cedula_instructor: "$_id",

      cantidad_lecciones: 1,
    },
  },
]);

// Estudiante que mas ha reprobado su examen teorico

db.examenes.aggregate([
  {
    $group: {
      _id: "$cedula_estudiante",

      veces_reprobado: {
        $sum: { $cond: [{ $eq: ["$estado", "REPROBADO"] }, 1, 0] },
      },
    },
  },

  { $sort: { veces_reprobado: -1 } },

  { $limit: 1 },
]);

// ¿Cuál es el vehiculo mas utilizado por el estudiante que mas ha reprobado su examen teorico?

db.lecciones.aggregate([
  {
    $lookup: {
      from: "asistencia_lecciones",

      localField: "id_leccion",

      foreignField: "id_leccion",

      as: "asistencia",
    },
  },

  {
    $lookup: {
      from: "examenes",

      localField: "asistencia.cedula_estudiante",

      foreignField: "cedula_estudiante",

      as: "examenes",
    },
  },

  {
    $group: {
      _id: {
        cedula_estudiante: "$asistencia.cedula_estudiante",

        placa_vehiculo: "$placa_vehiculo",
      },

      veces_utilizado: {
        $sum: 1,
      },
    },
  },
  { $unwind: "$_id.cedula_estudiante" },

  {
    $project: {
      _id: 0,

      cedula_estudiante: "$_id.cedula_estudiante",

      placa_vehiculo: "$_id.placa_vehiculo",

      veces_utilizado: 1,
    },
  },

  {
    $lookup: {
      from: "examenes",

      localField: "cedula_estudiante",

      foreignField: "cedula_estudiante",

      as: "examenes",
    },
  },

  {
    $addFields: {
      veces_reprobado: {
        $reduce: {
          input: "$examenes",

          initialValue: 0,

          in: {
            $add: [
              "$$value",

              {
                $cond: {
                  if: { $eq: ["$$this.estado", "REPROBADO"] },

                  then: 1,

                  else: 0,
                },
              },
            ],
          },
        },
      },
    },
  },

  {
    $project: {
      cedula_estudiante: 1,

      placa_vehiculo: 1,

      veces_utilizado: 1,

      veces_reprobado: 1,
    },
  },

  { $sort: { veces_reprobado: -1 } },

  { $limit: 1 },
]);
