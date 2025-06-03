# mobile_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# In Django shell (python manage.py shell)

from django.contrib.contenttypes.models import ContentType

# Get all content types for your app

ContentType.objects.filter(app_label='your_app_name').values('id', 'model')

# Or get specific ones

land_ct = ContentType.objects.get(app_label='your_app', model='land')
property_ct = ContentType.objects.get(app_label='your_app', model='property')

print(f"Land: {land_ct.id}")
print(f"Property: {property_ct.id}")
