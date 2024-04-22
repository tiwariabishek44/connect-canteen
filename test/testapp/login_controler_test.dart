import 'package:connect_canteen/testapp/login_controler.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {} // Mock HTTP client

void main() {
  group('LoginController', () {
    late LoginController loginController;
    late MockHttpClient httpClient;

    setUp(() {
      httpClient = MockHttpClient();
      loginController = LoginController(httpClient: httpClient);
    });

    test('login - successful', () async {
      // Arrange

      when(() => httpClient.post(
              Uri.parse('http://192.168.1.69:8080/api/open/student/login'),
              body: {
                'email': 'test@example.com',
                'password': 'password',
              })).thenAnswer((_) async {
        return http.Response('{"token": "your_token"}', 200);
      });

      loginController.emailcontroller.text = 'test@example.com';
      loginController.passwordcontroller.text = 'password';

      // Act
      await loginController.login();

      // Assert
      expect(loginController.loginSuccess.value, true);
    });

    test('login - unsuccessful', () async {
      // Arrange

      when(() => httpClient.post(
              Uri.parse('http://192.168.1.69:8080/api/open/student/login'),
              body: {
                'email': 'test@example.com',
                'password': 'password',
              })).thenAnswer((_) async {
        return http.Response('{"error": "Invalid credentials"}', 401);
      });

      loginController.emailcontroller.text = 'test@example.com';
      loginController.passwordcontroller.text = 'anythingharibhadur';

      // Act
      await loginController.login();

      // Assert
      expect(loginController.loginSuccess.value, false);
    });

    test('succesfull news fetch ', () async {
      // Arrange

      when(() => httpClient.get(
            Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          )).thenAnswer((_) async {
        return http.Response('{"status": "success"}', 200);
      });

      // Act
      await loginController.newsFetch();

      // Assert
      expect(loginController.newsLoded.value, true);
    });

    test('error while  news fetch ', () async {
      // Arrange

      when(() => httpClient.get(
            Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          )).thenAnswer((_) async {
        return http.Response('{"error": "server error"}', 4001);
      });

      // Act
      await loginController.newsFetch();

      // Assert
      expect(loginController.newsLoded.value, false);
    });
  });
}
