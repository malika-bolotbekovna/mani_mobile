from rest_framework.routers import DefaultRouter

from .views import CourseViewSet, LessonViewSet, ExerciseViewSet, ProgressViewSet, TopicViewSet, VocabularyViewSet

router = DefaultRouter()
router.register(r"topics", TopicViewSet, basename="topics")
router.register(r"courses", CourseViewSet, basename="courses")
router.register(r"lessons", LessonViewSet)
router.register(r"exercises", ExerciseViewSet)
router.register(r"progress", ProgressViewSet, basename="progress")
router.register(r"vocabulary", VocabularyViewSet)

urlpatterns = router.urls
