from django.contrib import admin
from django.utils.html import format_html

# Se importa desde models/ para mantener una sola puerta de entrada a los modelos.
from .models import (
    Peluqueria,
    Usuario,
    Estilista,
    Servicio,
    Cita,
    HorarioEstilista
)


@admin.register(Peluqueria)
class PeluqueriaAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'telefono', 'status', 'fecha_registro')
    search_fields = ('nombre', 'direccion', 'telefono')
    list_filter = ('status', 'fecha_registro')


@admin.register(Usuario)
class UsuarioAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'email', 'rol', 'status', 'fecha_registro')
    search_fields = ('nombre', 'email', 'telefono')
    list_filter = ('rol', 'status', 'fecha_registro')


@admin.register(Estilista)
class EstilistaAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'especialidad', 'telefono', 'hair_salon', 'status')
    search_fields = ('nombre', 'especialidad', 'telefono')
    list_filter = ('hair_salon', 'status')


@admin.register(Servicio)
class ServicioAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'hair_salon', 'precio', 'duracion_minutos', 'status')
    search_fields = ('nombre', 'descripcion')
    list_filter = ('hair_salon', 'status')


@admin.register(HorarioEstilista)
class HorarioEstilistaAdmin(admin.ModelAdmin):
    list_display = ('stylist', 'dia_semana', 'hora_inicio', 'hora_fin', 'activo', 'status')
    search_fields = ('stylist__nombre', 'dia_semana')
    list_filter = ('dia_semana', 'activo', 'status')


@admin.register(Cita)
class CitaAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'stylist', 'service', 'fecha', 'hora_inicio', 'estado_badge', 'status')
    search_fields = ('user__nombre', 'stylist__nombre', 'service__nombre', 'observaciones')
    list_filter = ('estado', 'status', 'fecha')

    @admin.display(description='Estado')
    def estado_badge(self, obj):
        colores = {
            'pendiente': '#f59e0b',
            'confirmada': '#2563eb',
            'completada': '#16a34a',
            'cancelada': '#dc2626',
        }
        color = colores.get(obj.estado, '#475569')
        return format_html(
            '<strong style="color: {}">{}</strong>',
            color,
            obj.estado.capitalize(),
        )