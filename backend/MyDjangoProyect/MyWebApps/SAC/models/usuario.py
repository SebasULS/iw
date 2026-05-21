from django.contrib.auth.hashers import identify_hasher, make_password
from django.core.exceptions import ValidationError
from django.db import models

from .base import ModeloAuditable, validar_telefono


class Usuario(ModeloAuditable):
    """Almacena a los clientes y administradores del sistema."""

    ROLES_VALIDOS = {'cliente', 'administrador', 'recepcionista'}

    nombre = models.CharField(max_length=100)
    email = models.EmailField(max_length=100, unique=True)
    contraseña = models.CharField(
        max_length=255,
        help_text="Almacena la contraseña encriptada. Usa django.contrib.auth.hashers.make_password()"
    )
    telefono = models.CharField(max_length=20, blank=True, null=True)
    rol = models.CharField(max_length=50)
    fecha_registro = models.DateTimeField(auto_now_add=True)

    def clean(self):
        if self.telefono:
            validar_telefono(self.telefono)

        if self.rol not in self.ROLES_VALIDOS:
            raise ValidationError({'rol': f"El rol debe ser uno de: {', '.join(sorted(self.ROLES_VALIDOS))}."})

    def save(self, *args, **kwargs):
        # Si la contrasena aun no esta cifrada, se protege antes del guardado final.
        try:
            identify_hasher(self.contraseña)
        except Exception:
            self.contraseña = make_password(self.contraseña)
        return super().save(*args, **kwargs)

    class Meta:
        db_table = 'users'
        verbose_name = 'User'
        verbose_name_plural = 'Users'

    def __str__(self):
        return f"{self.nombre} ({self.email})"