from rest_framework import serializers

from .models import Peluqueria, Usuario, Estilista, Servicio, Cita, HorarioEstilista


class PeluqueriaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Peluqueria
        fields = ['id', 'nombre', 'direccion', 'telefono', 'descripcion', 'fecha_registro', 'status']
        read_only_fields = ['id', 'fecha_registro']


class UsuarioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Usuario
        fields = ['id', 'nombre', 'email', 'contraseña', 'telefono', 'rol', 'fecha_registro', 'status']
        read_only_fields = ['id', 'fecha_registro']
        extra_kwargs = {'contraseña': {'write_only': True}}


class EstilistaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Estilista
        fields = ['id', 'nombre', 'telefono', 'especialidad', 'hair_salon', 'status']
        read_only_fields = ['id']


class ServicioSerializer(serializers.ModelSerializer):
    class Meta:
        model = Servicio
        fields = ['id', 'nombre', 'descripcion', 'precio', 'duracion_minutos', 'hair_salon', 'status']
        read_only_fields = ['id']


class CitaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Cita
        fields = [
            'id', 'user', 'stylist', 'service',
            'fecha', 'hora_inicio', 'hora_fin',
            'estado', 'observaciones', 'fecha_creacion', 'status',
        ]
        read_only_fields = ['id', 'fecha_creacion']


class HorarioEstilistaSerializer(serializers.ModelSerializer):
    class Meta:
        model = HorarioEstilista
        fields = ['id', 'stylist', 'dia_semana', 'hora_inicio', 'hora_fin', 'activo', 'status']
        read_only_fields = ['id']
