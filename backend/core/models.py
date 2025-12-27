from django.conf import settings
from django.db import models


class Topic(models.Model):
    title = models.CharField(max_length=100)

    def __str__(self):
        return self.title


class Course(models.Model):
    title = models.CharField(max_length=200)
    topic = models.ForeignKey(Topic, on_delete=models.CASCADE, related_name="courses")

    def __str__(self):
        return f"{self.title} ({self.topic.title})"


class Lesson(models.Model):
    course = models.ForeignKey(Course, on_delete=models.CASCADE, related_name="lessons")
    title = models.CharField(max_length=200)
    order_num = models.PositiveIntegerField(default=1)
    xp_reward = models.PositiveIntegerField(default=10)

    class Meta:
        ordering = ["order_num"]

    def __str__(self):
        return self.title


class Exercise(models.Model):
    TYPE_CHOICES = (
        ("choice", "Choice"),
        ("input", "Input"),
        ("cards", "Cards"),
    )

    lesson = models.ForeignKey(Lesson, on_delete=models.CASCADE, related_name="exercises")
    type = models.CharField(max_length=10, choices=TYPE_CHOICES)
    question = models.TextField()
    correct_answer = models.CharField(max_length=1000)

    options_json = models.TextField(
        blank=True,
        default="[]",
        help_text="Для choice и cards: варианты ответа (текст или image url)",
    )


class ExerciseAttempt(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="exercise_attempts",
    )
    exercise = models.ForeignKey(
        Exercise,
        on_delete=models.CASCADE,
        related_name="attempts",
    )
    lesson = models.ForeignKey(  # денормализация для быстрых запросов
        Lesson,
        on_delete=models.CASCADE,
        related_name="attempts",
    )

    is_correct = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        indexes = [
            # нужно для запросов вида:
            # filter(user=..., lesson=...) + order_by(-created_at)
            models.Index(fields=["user", "lesson", "created_at"]),
            # нужно для запросов вида:
            # filter(user=..., exercise=...) + order_by(-created_at)
            models.Index(fields=["user", "exercise", "created_at"]),
        ]


class Progress(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="progress",
    )
    # важно: для удобных запросов с обратной стороны (lesson.progress.all())
    lesson = models.ForeignKey(
        Lesson,
        on_delete=models.CASCADE,
        related_name="progress",
    )
    score = models.IntegerField(default=0)

    # комментарии поправил, чтобы не вводили в заблуждение:
    completed = models.BooleanField(default=False)     # выполнены ВСЕ упражнения урока (по твоему ТЗ)
    all_correct = models.BooleanField(default=False)   # последние попытки по ВСЕМ упражнениям правильные

    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ("user", "lesson")


class Vocabulary(models.Model):
    word = models.CharField(max_length=100)
    translation = models.CharField(max_length=200)
    example = models.TextField(blank=True, default="")

    def __str__(self):
        return self.word
