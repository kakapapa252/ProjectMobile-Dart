from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager

from django.conf import settings
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.authtoken.models import Token
# Create your models here.



class MyAccountManager(BaseUserManager):
    def create_user(self, email, username, password = None):
        if not email:
            raise ValueError('User Must have Email')
        if not username:
            raise ValueError('User Must have Username')

        user = self.model(
            email=self.normalize_email(email),
            username = username,
        )

        user.set_password(password)
        user.save()
        return user

    def create_superuser(self, email, username, password):
        user = self.create_user(
            email=self.normalize_email(email),
            username = username,
            password = password,
        )
        user.is_admin = True
        user.is_superuser = True
        user.is_staff = True
        user.save()
        return user



class Account(AbstractBaseUser):
    email = models.EmailField(unique=True, verbose_name='email',max_length= 60)
    username = models.CharField(unique=True, max_length= 30)
    is_active = models.BooleanField(default = True)
    date_joined = models.DateTimeField(verbose_name='date joined', auto_now_add=True)
    is_admin = models.BooleanField(default = False)
    is_staff = models.BooleanField(default = False)
    is_superuser = models.BooleanField(default = False)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    objects = MyAccountManager()

    def __str__(self):
        return(self.email)
    
    #For checking Permission, all admins have all permissions
    def has_perm(self, perm, obj=None):
        return self.is_admin

    def has_module_perms(self, app_label):
        return(True)


@receiver(post_save, sender = settings.AUTH_USER_MODEL)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created: 
        Token.objects.get_or_create(user=instance)