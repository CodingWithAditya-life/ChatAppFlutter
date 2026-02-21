import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKey() async {
    var scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "my-shope-c9575",
          "private_key_id": "9f46c0a71183f2af82e2c9a647b3657f9c67f48d",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDbwWKdW+7dordR\nFBIPZmOY2GVJWhqDFVPsr+KM00BnNRaLrC37x+fjlkSlohe2XGCd3UYkDsnyw6x9\nkjNBLZXpJZoiaVMuhWZVv/E4QbbFpzYO6YDh3dBtVFSWVEjVbDNNRUyqEiZ70J7D\n7K9o9T2iITT52ltpPKw2uQXHPAoLRiEEF8XnMaX/ZD1x2s8GdR97T8i6Q+HgPjdO\nSvzeIYM0Q9o7+mcp9ki7X/44bYa6yGPfFOtFRE7Zyqkw+XRi0hWhOwx7J/T9+GpH\n5cYGnInxVdF8ra5RYHx8TxqVkCzSk8lJYXKvpifC+wh8idmGnD5eVxHbIeNfyIL7\nhl7rkyNxAgMBAAECggEAGNg4P0om1e/mLHMfHOvv1AFDEj6ZmLr541x55H9NsggS\neyAFjYhVndQIrCEzRRlp4u8iqu5GbqfTVy8G6cDZnfjzqshK8IuBvQLCUXXnJVl4\n3HQRxMzAb7EvuangbMtFfDWa1pokDQN9BPGRXfBmqMR6/3RsY+10GuENgi+Lgyfo\n7CKorrAT3qdcZ4hio2tUZ5UiuE2/OhAzVMaayPbyilIIzNoz8ZqdqSdd3/W9wEO7\nJ5fvjvj4xm3ViDCz4IQTPPE5TQ4E3ZHuOoU/0MmdoqM9v9SONUS7rclkRw9bnkh6\nTjEVjJDUmUrj4WT2AQajNI3qgZwgR7ZYb/YQbDkesQKBgQDyYotmOmYvt89+FYpv\nZZ6oms2x6jIGPA9aJKMiQxDmcqz+dRJlLR4VQcabi3jLBISdkgDj14Gbsj6LONj7\npFZj6xOmkIRDjnW3WP5IWLDWsRJPcNnFOM5T60tlsCzz7Yi/939wezw7Y1kLS4gx\nkK7+mHLUoy6fNEJbfYq2nOGjSwKBgQDoGW6KGmkQg1ucEI0EJNjGGwHk9qib1/u5\n7tohGsw36mK9aRmkPvSyTueYsMr7ifz89gqFsV69rb7W3McBVvhREl26GKOI3SXg\n/FP+F7xN/BlL2zFEHAQ8eRF0qV+g59mVx/ntR2dZb3Omb33gU0jTCMomqV70P2F6\nnHxbtZoiswKBgAr8AEk/uEXNVK/oFf/6YPhPG6dGb8Hskt2I74Or+mYXKFPXxl+j\nbcuU0YVXCsBYkhH5/eRVbeA6ca8pglvVFL0ueBOCVRwipp8Kf2uT6V+xYp0LBjNz\n4ZXYAfC3zTG4wAvDEZltXEtssypZ3/AvGF8dVYbhZkl8us0eoVypO2iFAoGBAL15\nTXkmeFDHu3ibNlOEtQZ8s74z8o9O8avnJmFSHBclm7fe3dTspBwQOBa5dOuFyWbE\ngPCFTL9x4FJNZ5RbaFnesW8jgBVR3ANgWj0bKVlMjWYUqZJdgMPRXgOr5WpY+5K/\n7vLakK89Qd9EMzF3LANDsKuBJwgj2bMbnpXLmenrAoGBAK088ioJkmy8ufpEEt2s\nEE0wu/iS3dI4Y1wqVypHpeW0wcEQTmC8iOYgQCmM9OJl26+D/KLsktaO9ro7skkS\nX5Tml9eB4fk6zDKlxleWrZFjT47KJo3GJSlulCG6YRtXS00tEde2ysIjqNrR51v5\nKwqskenIJuhHTZ3W/ZyR2USg\n-----END PRIVATE KEY-----\n",
          "client_email": "firebase-adminsdk-8sqqx@my-shope-c9575.iam.gserviceaccount.com",
          "client_id": "117277239359966409433",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-8sqqx%40my-shope-c9575.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com"
        }),
        scopes);
    final serverKey = client.credentials.accessToken.data;
    print("serverKey =$serverKey");
    return serverKey;
  }
}
