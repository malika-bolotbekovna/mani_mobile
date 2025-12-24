from django.contrib import admin
from django.contrib.auth import get_user_model

User = get_user_model()


@admin.register(User)
class ManiUserAdmin(admin.ModelAdmin):
    list_display = ("id", "email", "name", "is_staff", "is_active", "created_at")
    search_fields = ("email", "name")
    list_filter = ("is_staff", "is_active")
