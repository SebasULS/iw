from django.db import models

from .base import ModeloAuditable, validar_telefono


class Peluqueria(ModeloAuditable):
    """Representa la sede principal del negocio."""

    nombre = models.CharField(max_length=100)
    direccion = models.CharField(max_length=255)
    telefono = models.CharField(max_length=20)
    descripcion = models.TextField(blank=True, null=True)
    fecha_registro = models.DateTimeField(auto_now_add=True)

    def clean(self):
        validar_telefono(self.telefono)

    class Meta:
        db_table = 'hair_salons'
        verbose_name = 'Hair salon'
        verbose_name_plural = 'Hair salons'
        ordering = ['nombre']

    def __str__(self):
        return self.nombre