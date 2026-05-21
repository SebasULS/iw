from django.core.exceptions import ValidationError
from django.db import models
from django.utils import timezone


def validar_telefono(valor):
    """Acepta telefonos con digitos, espacios y simbolos comunes."""
    if not valor:
        return

    caracteres_permitidos = set("0123456789 +()-")
    if any(caracter not in caracteres_permitidos for caracter in valor):
        raise ValidationError("El telefono solo puede contener digitos y simbolos basicos.")

    digitos = [caracter for caracter in valor if caracter.isdigit()]
    if len(digitos) < 7:
        raise ValidationError("El telefono debe contener al menos 7 digitos.")


class ModeloAuditable(models.Model):
    """Centraliza los campos comunes pedidos por la rubrica."""

    status = models.CharField(max_length=20, default='active')
    created = models.DateTimeField(default=timezone.now, editable=False)
    modified = models.DateTimeField(default=timezone.now)
    created_id = models.PositiveBigIntegerField(blank=True, null=True)
    modified_id = models.PositiveBigIntegerField(blank=True, null=True)

    class Meta:
        abstract = True

    def save(self, *args, **kwargs):
        """Ejecuta validaciones antes de guardar y actualiza la auditoria."""
        marca_tiempo = timezone.now()
        if not self.created:
            self.created = marca_tiempo
        self.modified = marca_tiempo
        self.full_clean()
        return super().save(*args, **kwargs)