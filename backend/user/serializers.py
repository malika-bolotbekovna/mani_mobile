from django.contrib.auth import get_user_model
from rest_framework import serializers

User = get_user_model()


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=6)

    class Meta:
        model = User
        fields = ('id', 'name', 'email', 'password', 'avatar')

    def create(self, validated_data):
        password = validated_data.pop('password')
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user


class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField()

    def validate(self, attrs):
        email = attrs['email']
        password = attrs['password']

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            raise serializers.ValidationError('Неверный email или пароль')

        if not user.check_password(password):
            raise serializers.ValidationError('Неверный email или пароль')

        attrs['user'] = user
        return attrs


# users/serializers.py
class ProfileSerializer(serializers.ModelSerializer):
    avatar_url = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = ("id", "name", "email", "avatar", "avatar_url")
        read_only_fields = ("id", "email", "name")

    def get_avatar_url(self, obj) -> str | None:
        request = self.context.get("request")
        if not obj.avatar:
            return None
        url = obj.avatar.url
        return request.build_absolute_uri(url) if request else url