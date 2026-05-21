from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated

from .models import Peluqueria, Usuario, Estilista, Servicio, Cita, HorarioEstilista
from .serializers import (
    PeluqueriaSerializer,
    UsuarioSerializer,
    EstilistaSerializer,
    ServicioSerializer,
    CitaSerializer,
    HorarioEstilistaSerializer,
)


class PeluqueriaViewSet(viewsets.ModelViewSet):
    queryset = Peluqueria.objects.all().order_by('nombre')
    serializer_class = PeluqueriaSerializer
    permission_classes = [IsAuthenticated]


class UsuarioViewSet(viewsets.ModelViewSet):
    queryset = Usuario.objects.all().order_by('nombre')
    serializer_class = UsuarioSerializer
    permission_classes = [IsAuthenticated]


class EstilistaViewSet(viewsets.ModelViewSet):
    queryset = Estilista.objects.all().order_by('nombre')
    serializer_class = EstilistaSerializer
    permission_classes = [IsAuthenticated]


class ServicioViewSet(viewsets.ModelViewSet):
    queryset = Servicio.objects.all().order_by('nombre')
    serializer_class = ServicioSerializer
    permission_classes = [IsAuthenticated]


class CitaViewSet(viewsets.ModelViewSet):
    queryset = Cita.objects.all().order_by('-fecha', 'hora_inicio')
    serializer_class = CitaSerializer
    permission_classes = [IsAuthenticated]


class HorarioEstilistaViewSet(viewsets.ModelViewSet):
    queryset = HorarioEstilista.objects.all().order_by('stylist', 'dia_semana')
    serializer_class = HorarioEstilistaSerializer
    permission_classes = [IsAuthenticated]
