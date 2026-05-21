from django.core.exceptions import ValidationError
from django.db import models

from .base import ModeloAuditable


class HorarioEstilista(ModeloAuditable):
    """Describe la disponibilidad semanal de cada estilista."""

    stylist = models.ForeignKey(
        'Estilista', 
        db_column='stylist_id',
        on_delete=models.CASCADE, 
        related_name='horarios'
    )
    dia_semana = models.CharField(max_length=20)
    hora_inicio = models.TimeField()
    hora_fin = models.TimeField()
    activo = models.BooleanField(default=True)

    def clean(self):
        if self.hora_fin <= self.hora_inicio:
            raise ValidationError('La hora de fin debe ser mayor que la hora de inicio.')

        conflicto = HorarioEstilista.objects.filter(
            stylist=self.stylist,
            dia_semana=self.dia_semana,
            activo=True,
        ).exclude(pk=self.pk)

        for horario in conflicto:
            if self.hora_inicio < horario.hora_fin and self.hora_fin > horario.hora_inicio:
                raise ValidationError('El horario del estilista se cruza con otro registro activo.')

    class Meta:
        db_table = 'stylist_schedules'
        verbose_name = 'Stylist schedule'
        verbose_name_plural = 'Stylist schedules'

    def __str__(self):
        return f"{self.stylist.nombre} | {self.dia_semana} ({self.hora_inicio} - {self.hora_fin})"