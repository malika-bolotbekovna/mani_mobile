from django.contrib import admin
from .models import Lesson, Topic, Course, Exercise, Vocabulary

admin.site.register(Topic)
admin.site.register(Course)
admin.site.register(Lesson)
admin.site.register(Exercise)
admin.site.register(Vocabulary)