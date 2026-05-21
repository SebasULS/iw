from django.db import models

from .base import ModeloAuditable, validar_telefono


class Estilista(ModeloAuditable):
    """Modela al personal que atiende los servicios."""

    nombre = models.CharField(max_length=100)
    telefono = models.CharField(max_length=20)
    especialidad = models.CharField(max_length=100)
    hair_salon = models.ForeignKey(
        'Peluqueria', 
        db_column='hair_salon_id',
        on_delete=models.CASCADE, 
        related_name='estilistas'
    )

    def clean(self):
        validar_telefono(self.telefono)

    class Meta:
        db_table = 'stylists'
        verbose_name = 'Stylist'
        verbose_name_plural = 'Stylists'

    def __str__(self):
        return f"{self.nombre} - {self.especialidad}"