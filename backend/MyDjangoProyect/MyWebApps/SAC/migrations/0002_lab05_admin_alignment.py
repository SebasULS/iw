from django.db import migrations, models
from django.utils import timezone


class Migration(migrations.Migration):

    dependencies = [
        ('sac', '0001_initial'),
    ]

    operations = [
        migrations.AlterModelTable(name='peluqueria', table='hair_salons'),
        migrations.AlterModelTable(name='usuario', table='users'),
        migrations.AlterModelTable(name='estilista', table='stylists'),
        migrations.AlterModelTable(name='servicio', table='services'),
        migrations.AlterModelTable(name='cita', table='appointments'),
        migrations.AlterModelTable(name='horarioestilista', table='stylist_schedules'),
        migrations.RenameField(model_name='estilista', old_name='id_peluqueria', new_name='hair_salon'),
        migrations.RenameField(model_name='servicio', old_name='id_peluqueria', new_name='hair_salon'),
        migrations.RenameField(model_name='horarioestilista', old_name='id_estilista', new_name='stylist'),
        migrations.RenameField(model_name='cita', old_name='id_usuario', new_name='user'),
        migrations.RenameField(model_name='cita', old_name='id_estilista', new_name='stylist'),
        migrations.RenameField(model_name='cita', old_name='id_servicio', new_name='service'),
        migrations.AlterField(
            model_name='estilista',
            name='hair_salon',
            field=models.ForeignKey(db_column='hair_salon_id', on_delete=models.deletion.CASCADE, related_name='estilistas', to='sac.peluqueria'),
        ),
        migrations.AlterField(
            model_name='servicio',
            name='hair_salon',
            field=models.ForeignKey(db_column='hair_salon_id', on_delete=models.deletion.CASCADE, related_name='servicios', to='sac.peluqueria'),
        ),
        migrations.AlterField(
            model_name='horarioestilista',
            name='stylist',
            field=models.ForeignKey(db_column='stylist_id', on_delete=models.deletion.CASCADE, related_name='horarios', to='sac.estilista'),
        ),
        migrations.AlterField(
            model_name='cita',
            name='user',
            field=models.ForeignKey(db_column='user_id', on_delete=models.deletion.CASCADE, related_name='citas', to='sac.usuario'),
        ),
        migrations.AlterField(
            model_name='cita',
            name='stylist',
            field=models.ForeignKey(db_column='stylist_id', on_delete=models.deletion.CASCADE, related_name='citas_asignadas', to='sac.estilista'),
        ),
        migrations.AlterField(
            model_name='cita',
            name='service',
            field=models.ForeignKey(db_column='service_id', on_delete=models.deletion.CASCADE, related_name='citas_servicio', to='sac.servicio'),
        ),
        migrations.AddField(
            model_name='peluqueria',
            name='status',
            field=models.CharField(default='active', max_length=20),
        ),
        migrations.AddField(
            model_name='peluqueria',
            name='created',
            field=models.DateTimeField(default=timezone.now, editable=False),
        ),
        migrations.AddField(
            model_name='peluqueria',
            name='modified',
            field=models.DateTimeField(default=timezone.now),
        ),
        migrations.AddField(
            model_name='peluqueria',
            name='created_id',
            field=models.PositiveBigIntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='peluqueria',
            name='modified_id',
            field=models.PositiveBigIntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='usuario',
            name='status',
            field=models.CharField(default='active', max_length=20),
        ),
        migrations.AddField(
            model_name='usuario',
            name='created',
            field=models.DateTimeField(default=timezone.now, editable=False),
        ),
        migrations.AddField(
            model_name='usuario',
            name='modified',
            field=models.DateTimeField(default=timezone.now),
        ),
        migrations.AddField(
            model_name='usuario',
            name='created_id',
            field=models.PositiveBigIntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='usuario',
            name='modified_id',
            field=models.PositiveBigIntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='estilista',
            name='status',
            field=models.CharField(default='active', max_length=20),
        ),
        migrations.AddField(
            model_name='estilista',
            name='created',
            field=models.DateTimeField(default=timezone.now, editable=False),
        ),
        migrations.AddField(
            model_name='estilista',
            name='modified',
            field=models.DateTimeField(default=timezone.now),
        ),
        migrations.AddField(
            model_name='estilista',
            name='created_id',
            field=models.PositiveBigIntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='estilista',
            name='modified_id',
            field=models.PositiveBigIntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='servicio',
            name='status',
            field=models.CharField(default='active', max_length=20),
        ),
        migrations.AddField(
            model_name='servicio',
            name='created',
            field=models.DateTimeField(default=timezone.now, editable=False),
        ),
        migrations.AddField(
            model_name='servicio',
            name='modified',
            field=models.DateTimeField(default=timezone.now),
        ),
        migrations.AddField(
            model_name='servicio',
            name='created_id',
            field=models.PositiveBigIntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='servicio',
            name='modified_id',
            field=models.PositiveBigIntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='cita',
            name='status',
            field=models.CharField(default='active', max_length=20),
        ),
        migrations.AddField(
            model_name='cita',
            name='created',
            field=models.DateTimeField(default=timezone.now, editable=False),
        ),
        migrations.AddField(
            model_name='cita',
            name='modified',
            field=models.DateTimeField(default=timezone.now),
        ),
        migrations.AddField(
            model_name='cita',
            name='created_id',
            field=models.PositiveBigIntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='cita',
            name='modified_id',
            field=models.PositiveBigIntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='horarioestilista',
            name='status',
            field=models.CharField(default='active', max_length=20),
        ),
        migrations.AddField(
            model_name='horarioestilista',
            name='created',
            field=models.DateTimeField(default=timezone.now, editable=False),
        ),
        migrations.AddField(
            model_name='horarioestilista',
            name='modified',
            field=models.DateTimeField(default=timezone.now),
        ),
        migrations.AddField(
            model_name='horarioestilista',
            name='created_id',
            field=models.PositiveBigIntegerField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='horarioestilista',
            name='modified_id',
            field=models.PositiveBigIntegerField(blank=True, null=True),
        ),
    ]