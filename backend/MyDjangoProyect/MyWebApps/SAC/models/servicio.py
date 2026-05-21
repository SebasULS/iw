from django.core.exceptions import ValidationError
from django.db import models

from .base import ModeloAuditable


class Servicio(ModeloAuditable):
    """Define la oferta comercial disponible en la peluqueria."""

    nombre = models.CharField(max_length=100)
    descripcion = models.TextField(blank=True, null=True)
    precio = models.DecimalField(max_digits=10, decimal_places=2)
    duracion_minutos = models.PositiveIntegerField()
    hair_salon = models.ForeignKey(
        'Peluqueria', 
        db_column='hair_salon_id',
        on_delete=models.CASCADE, 
        related_name='servicios'
    )

    def clean(self):
        if self.precio <= 0:
            raise ValidationError({'precio': 'El precio debe ser mayor que cero.'})
        if self.duracion_minutos <= 0:
            raise ValidationError({'duracion_minutos': 'La duracion debe ser mayor que cero.'})

    class Meta:
        db_table = 'services'
        verbose_name = 'Service'
        verbose_name_plural = 'Services'

    def __str__(self):
        return f"{self.nombre} - ${self.precio}"