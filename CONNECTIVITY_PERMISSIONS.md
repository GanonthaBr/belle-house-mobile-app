# Connectivity Permissions Setup Guide

## Android Permissions (Already Added)

The following permissions have been added to `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- Network permissions -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
```

### Permission Descriptions:

- **INTERNET**: Allows the app to access the internet
- **ACCESS_NETWORK_STATE**: Allows the app to access information about networks
- **ACCESS_WIFI_STATE**: Allows the app to access information about Wi-Fi networks

## iOS Permissions

For iOS, no additional permissions are required in `Info.plist` as the connectivity_plus package uses system APIs that don't require explicit permissions.

## Testing Connectivity

To test the connectivity functionality:

1. **Test with WiFi**: Connect to WiFi and verify the app shows "Connected"
2. **Test with Mobile Data**: Switch to mobile data and verify connectivity
3. **Test Offline Mode**: Turn off all networks and verify "No connection" status
4. **Test API Calls**: Try making API calls when offline to see error messages

## Usage in Your App

The connectivity checks are now automatically integrated into:

- All authentication methods (login, register, token refresh)
- All API service methods (GET, POST, PUT, DELETE)
- Manual checking utilities for UI components

## Runtime Permissions

Note: These are not runtime permissions that require user consent. They are declared permissions that Android grants automatically when the app is installed.

## Troubleshooting

If connectivity detection isn't working:

1. Ensure you've run `flutter pub get` after adding connectivity_plus
2. Clean and rebuild the app: `flutter clean && flutter pub get`
3. Check that the permissions are correctly added to AndroidManifest.xml
4. Test on a real device rather than an emulator for best results
