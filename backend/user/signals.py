# users/signals.py
from django.db.models.signals import pre_save
from django.dispatch import receiver
from .models import ManiUser

@receiver(pre_save, sender=ManiUser)
def delete_old_avatar(sender, instance, **kwargs):
    if not instance.pk:
        return
    try:
        old = sender.objects.get(pk=instance.pk)
    except sender.DoesNotExist:
        return
    if old.avatar and old.avatar != instance.avatar:
        old.avatar.delete(save=False)
