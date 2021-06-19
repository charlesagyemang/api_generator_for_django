from django.db import models #type: ignore
from utils.constants import TINY_STR_LEN, SHORT_STR_LEN, LONG_STR_LEN #type: ignore
import uuid
from apps__users import models as user_models
from django.forms.models import model_to_dict #type: ignore

  
class Asset(models.Model):
  '''
    This describes the Asset table
  '''
  id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
  name = models.CharField(max_length=SHORT_STR_LEN, blank=True)
  description = models.CharField(max_length=SHORT_STR_LEN, blank=False)
  documents = models.ManyToManyField(Document, blank=False)
  is_archived = models.BooleanField(blank=False)
  created_at = models.DateTimeField(auto_now_add=True)
  updated_at = models.DateTimeField(auto_now=True)

  def __str__(self):
    return self.name

  def info(self):
    return model_to_dict(self,['id', 'name'])


  def simple_json(self):
    res = model_to_dict(self, ["id", "name", "description", "is_archived"])
    res['id'] = self.pk 
    res['documents'] = list(self.documents.values())
    return res

  def full_json(self):
    return self.simple_json()

  class Meta:
    db_table = 'asset'
    ordering = ('-created_at',)
  
 #just added 
