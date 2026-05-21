from datetime import datetime

from django.core.exceptions import ValidationError
from django.db import models

from .base import ModeloAuditable


class Cita(ModeloAuditable):
    """Gestiona las reservas y evita conflictos de horario."""

    ESTADOS_VALIDOS = {'pendiente', 'confirmada', 'completada', 'cancelada'}

    user = models.ForeignKey('Usuario', db_column='user_id', on_delete=models.CASCADE, related_name='citas')
    stylist = models.ForeignKey('Estilista', db_column='stylist_id', on_delete=models.CASCADE, related_name='citas_asignadas')
    service = models.ForeignKey('Servicio', db_column='service_id', on_delete=models.CASCADE, related_name='citas_servicio')
    fecha = models.DateField()
    hora_inicio = models.TimeField()
    hora_fin = models.TimeField()
    estado = models.CharField(max_length=50, default='pendiente')
    observaciones = models.TextField(blank=True, null=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    def clean(self):
        if self.hora_fin <= self.hora_inicio:
            raise ValidationError('La hora de fin debe ser mayor que la hora de inicio.')

        if self.estado not in self.ESTADOS_VALIDOS:
            raise ValidationError({'estado': 'El estado de la cita no es valido.'})

        if self.service_id:
            inicio = datetime.combine(self.fecha, self.hora_inicio)
            fin = datetime.combine(self.fecha, self.hora_fin)
            duracion_real = int((fin - inicio).total_seconds() / 60)
            if duracion_real != self.service.duracion_minutos:
                raise ValidationError({
                    'hora_fin': 'La duracion de la cita debe coincidir con la duracion del servicio.'
                })

            if self.stylist.hair_salon_id != self.service.hair_salon_id:
                raise ValidationError('El estilista y el servicio deben pertenecer a la misma peluqueria.')

        conflicto = Cita.objects.filter(
            stylist=self.stylist,
            fecha=self.fecha,
        ).exclude(pk=self.pk)

        for cita in conflicto:
            if self.hora_inicio < cita.hora_fin and self.hora_fin > cita.hora_inicio:
                raise ValidationError('La cita se cruza con otra reserva del estilista.')

    class Meta:
        db_table = 'appointments'
        verbose_name = 'Appointment'
        verbose_name_plural = 'Appointments'
        ordering = ['-fecha', 'hora_inicio']

    def __str__(self):
        return f"Cita #{self.id} | {self.user.nombre} con {self.stylist.nombre}"