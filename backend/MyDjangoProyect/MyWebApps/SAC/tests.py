from datetime import date, time

from django.core.exceptions import ValidationError
from django.test import TestCase

from .models import Cita, Estilista, Peluqueria, Servicio, Usuario


class ModeloRestriccionesTest(TestCase):
	"""Pruebas puntuales de las restricciones pedidas por la practica."""

	def setUp(self):
		self.peluqueria = Peluqueria.objects.create(
			nombre='CarryCoders Studio',
			direccion='Av. Principal 123',
			telefono='987654321',
			descripcion='Sucursal central'
		)
		self.usuario = Usuario.objects.create(
			nombre='Ana Perez',
			email='ana@example.com',
			contraseña='secreto123',
			telefono='987654322',
			rol='cliente'
		)
		self.estilista = Estilista.objects.create(
			nombre='Luis Gomez',
			telefono='987654323',
			especialidad='Colorimetria',
			hair_salon=self.peluqueria,
		)
		self.servicio = Servicio.objects.create(
			nombre='Corte premium',
			descripcion='Incluye lavado y peinado',
			precio=25.50,
			duracion_minutos=60,
			hair_salon=self.peluqueria,
		)

	def test_password_se_guarda_encriptada(self):
		self.assertNotEqual(self.usuario.contraseña, 'secreto123')
		self.assertTrue(self.usuario.contraseña.startswith('pbkdf2_'))

	def test_cita_rechaza_cruce_de_horarios(self):
		Cita.objects.create(
			user=self.usuario,
			stylist=self.estilista,
			service=self.servicio,
			fecha=date(2026, 4, 23),
			hora_inicio=time(10, 0),
			hora_fin=time(11, 0),
			estado='confirmada',
		)

		with self.assertRaises(ValidationError):
			Cita(
				user=self.usuario,
				stylist=self.estilista,
				service=self.servicio,
				fecha=date(2026, 4, 23),
				hora_inicio=time(10, 30),
				hora_fin=time(11, 30),
				estado='pendiente',
			).save()
