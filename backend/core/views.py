from rest_framework import viewsets, mixins, status
from rest_framework.response import Response
from rest_framework.decorators import action
from .models import Course, ExerciseAttempt, Lesson, Exercise, Progress, Topic, Vocabulary
from .serializers import (
    CourseSerializer,
    LessonSerializer,
    ExerciseSerializer,
    ProgressSerializer,
    SubmitAttemptSerializer,
    TopicSerializer,
    VocabularySerializer,
)


class TopicViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Topic.objects.all().order_by("title")
    serializer_class = TopicSerializer


class CourseViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Course.objects.select_related("topic").all().order_by("title")
    serializer_class = CourseSerializer

    def get_queryset(self):
        qs = super().get_queryset()
        topic_id = self.request.query_params.get("topic")
        if topic_id:
            qs = qs.filter(topic_id=topic_id)
        return qs


class LessonViewSet(viewsets.ModelViewSet):
    queryset = Lesson.objects.all().order_by("order_num")
    serializer_class = LessonSerializer

    def get_queryset(self):
        qs = super().get_queryset()
        course_id = self.request.query_params.get("course")
        if course_id:
            qs = qs.filter(course_id=course_id)
        return qs



class ExerciseViewSet(viewsets.ModelViewSet):
    queryset = Exercise.objects.all()
    serializer_class = ExerciseSerializer

    def get_queryset(self):
        qs = super().get_queryset()
        lesson_id = self.request.query_params.get("lesson")
        if lesson_id:
            qs = qs.filter(lesson_id=lesson_id)
        return qs   



class ProgressViewSet(
    mixins.ListModelMixin,
    mixins.RetrieveModelMixin,
    viewsets.GenericViewSet,
):
    """
    Доступ:
      - GET /progress/            -> список прогресса пользователя
      - GET /progress/{id}/       -> конкретная запись прогресса (только своя)
      - POST /progress/submit-attempt/ -> записать результат упражнения и пересчитать прогресс урока
    """
    serializer_class = ProgressSerializer

    def get_queryset(self):
        # Важно: пользователь видит только свой прогресс
        return Progress.objects.filter(user=self.request.user).select_related("lesson")

    @action(detail=False, methods=["post"], url_path="submit-attempt")
    def submit_attempt(self, request):
        s = SubmitAttemptSerializer(data=request.data)
        s.is_valid(raise_exception=True)

        exercise_id = s.validated_data["exercise_id"]
        is_correct = s.validated_data["is_correct"]

        # Получаем упражнение и урок
        try:
            exercise = Exercise.objects.select_related("lesson").get(pk=exercise_id)
        except Exercise.DoesNotExist:
            return Response(
                {"detail": "Exercise not found"},
                status=status.HTTP_404_NOT_FOUND,
            )

        lesson = exercise.lesson

        # 1) сохраняем попытку
        ExerciseAttempt.objects.create(
            user=request.user,
            exercise=exercise,
            lesson=lesson,  # денормализация, чтобы быстрее фильтровать по уроку
            is_correct=is_correct,
        )

        # 2) прогресс по уроку
        progress, _ = Progress.objects.get_or_create(
            user=request.user,
            lesson=lesson,
        )

        # 3) score (если нужно)
        if is_correct:
            progress.score += 1

        # 4) пересчет completed/all_correct — ПО ВСЕМ УПРАЖНЕНИЯМ УРОКА
        exercise_ids = list(
            Exercise.objects.filter(lesson=lesson).values_list("id", flat=True)
        )

        # Если вдруг у урока нет упражнений — не считаем завершенным (можно поменять на True при желании)
        if not exercise_ids:
            progress.completed = False
            progress.all_correct = False
            progress.save(update_fields=["score", "completed", "all_correct", "updated_at"])
            return Response(
                {
                    "lesson_id": lesson.id,
                    "completed": progress.completed,
                    "all_correct": progress.all_correct,
                    "score": progress.score,
                    "next": None,
                },
                status=status.HTTP_200_OK,
            )

        # Берём последнюю попытку по каждому упражнению
        last_by_exercise = {}
        for ex_id in exercise_ids:
            last = (
                ExerciseAttempt.objects
                .filter(user=request.user, exercise_id=ex_id)
                .order_by("-created_at")
                .first()
            )
            last_by_exercise[ex_id] = last.is_correct if last else None

        completed = all(last_by_exercise[ex_id] is not None for ex_id in exercise_ids)
        all_correct = completed and all(last_by_exercise[ex_id] is True for ex_id in exercise_ids)

        progress.completed = completed
        progress.all_correct = all_correct
        progress.save(update_fields=["score", "completed", "all_correct", "updated_at"])

        return Response(
            {
                "lesson_id": lesson.id,
                "completed": progress.completed,
                "all_correct": progress.all_correct,
                "score": progress.score,
                # фронту удобно: если урок завершён — показываем страницу 1 (карточки перевода)
                "next": "translation_cards" if progress.completed else None,
            },
            status=status.HTTP_200_OK,
        )


class VocabularyViewSet(viewsets.ModelViewSet):
    queryset = Vocabulary.objects.all()
    serializer_class = VocabularySerializer
