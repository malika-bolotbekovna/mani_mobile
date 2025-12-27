from rest_framework import serializers
from .models import Course, Lesson, Exercise, Progress, Topic, Vocabulary


class TopicSerializer(serializers.ModelSerializer):
    class Meta:
        model = Topic
        fields = ["id", "title"]


class CourseSerializer(serializers.ModelSerializer):
    topic = TopicSerializer(read_only=True)
    topic_id = serializers.IntegerField(write_only=True)

    class Meta:
        model = Course
        fields = ["id", "title", "topic", "topic_id"]
        

class LessonSerializer(serializers.ModelSerializer):
    is_completed = serializers.SerializerMethodField()

    class Meta:
        model = Lesson
        fields = (
            "id",
            "course",
            "title",
            "order_num",
            "xp_reward",
            "is_completed",
            # добавь сюда остальные поля Lesson, которые тебе реально нужны
        )

    def get_is_completed(self, obj):
        request = self.context.get("request")
        user = getattr(request, "user", None)
        if not user or not user.is_authenticated:
            return False
        return Progress.objects.filter(user=user, lesson=obj, completed=True).exists()


    
class ExerciseSerializer(serializers.ModelSerializer):
    class Meta:
        model = Exercise
        fields = "__all__"


class ProgressSerializer(serializers.ModelSerializer):
    class Meta:
        model = Progress
        fields = "__all__"


class VocabularySerializer(serializers.ModelSerializer):
    class Meta:
        model = Vocabulary
        fields = "__all__"


# serializers.py
class SubmitAttemptSerializer(serializers.Serializer):
    exercise_id = serializers.IntegerField()
    is_correct = serializers.BooleanField()
