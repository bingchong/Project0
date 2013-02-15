from django.db import models

# Create your models here.
class User(models.Model):
	username = models.CharField(max_length=128)
	passwd = models.CharField(max_length=128)
	count = models.IntegerField()
	
	def __unicode__(self):
		return (self.username, self.count)
	
