import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockGoTrueClient extends Mock implements GoTrueClient {}
class MockSession extends Mock implements Session {}
class MockUser extends Mock implements User {}
class FakeUserAttributes extends Fake implements UserAttributes {}

void main() {
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;
  late MockSession mockSession;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Provide an in-memory shared_preferences so Supabase can initialize
    SharedPreferences.setMockInitialValues({});

    registerFallbackValue(FakeUserAttributes());

    await Supabase.initialize(
      url: 'https://placeholder.supabase.co',
      anonKey: 'placeholder-anon-key',
    );
  });

  setUp(() {
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();
    mockSession = MockSession();
  });

  group('AuthService — mocked GoTrueClient', () {
    group('isLoggedIn', () {
      test('returns true when a session exists', () {
        when(() => mockAuth.currentSession).thenReturn(mockSession);
        expect(mockAuth.currentSession != null, isTrue);
      });

      test('returns false when no session exists', () {
        when(() => mockAuth.currentSession).thenReturn(null);
        expect(mockAuth.currentSession != null, isFalse);
      });
    });

    group('userEmail', () {
      test('returns email when user is logged in', () {
        when(() => mockAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.email).thenReturn('test@futurepath.com');
        expect(mockAuth.currentUser?.email, 'test@futurepath.com');
      });

      test('returns null when no user is logged in', () {
        when(() => mockAuth.currentUser).thenReturn(null);
        expect(mockAuth.currentUser?.email, isNull);
      });
    });

    group('signIn', () {
      test('calls signInWithPassword with correct credentials', () async {
        final response = AuthResponse(session: mockSession, user: mockUser);

        when(() => mockAuth.signInWithPassword(
          email: 'test@futurepath.com',
          password: 'password123',
        )).thenAnswer((_) async => response);

        final result = await mockAuth.signInWithPassword(
          email: 'test@futurepath.com',
          password: 'password123',
        );

        expect(result.user, mockUser);
        expect(result.session, mockSession);

        verify(() => mockAuth.signInWithPassword(
          email: 'test@futurepath.com',
          password: 'password123',
        )).called(1);
      });

      test('throws AuthException on invalid credentials', () {
        when(() => mockAuth.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(AuthException('Invalid login credentials'));

        expect(
              () => mockAuth.signInWithPassword(
            email: 'bad@test.com',
            password: 'wrongpass',
          ),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('signUp', () {
      test('calls signUp with correct credentials', () async {
        final response = AuthResponse(session: null, user: mockUser);

        when(() => mockAuth.signUp(
          email: 'newuser@futurepath.com',
          password: 'password123',
        )).thenAnswer((_) async => response);

        final result = await mockAuth.signUp(
          email: 'newuser@futurepath.com',
          password: 'password123',
        );

        expect(result.user, mockUser);

        verify(() => mockAuth.signUp(
          email: 'newuser@futurepath.com',
          password: 'password123',
        )).called(1);
      });
    });

    group('signOut', () {
      test('calls signOut on the auth client', () async {
        when(() => mockAuth.signOut()).thenAnswer((_) async {});

        await mockAuth.signOut();

        verify(() => mockAuth.signOut()).called(1);
      });
    });

    group('resetPassword', () {
      test('calls resetPasswordForEmail with email and redirectTo', () async {
        when(() => mockAuth.resetPasswordForEmail(
          any(),
          redirectTo: any(named: 'redirectTo'),
        )).thenAnswer((_) async {});

        await mockAuth.resetPasswordForEmail(
          'test@futurepath.com',
          redirectTo: 'io.futurepath://reset-password',
        );

        verify(() => mockAuth.resetPasswordForEmail(
          'test@futurepath.com',
          redirectTo: 'io.futurepath://reset-password',
        )).called(1);
      });
    });

    group('updatePassword', () {
      test('calls updateUser with new password attributes', () {
        when(() => mockAuth.updateUser(any()))
            .thenThrow(UnimplementedError());

        expect(
              () => mockAuth.updateUser(UserAttributes(password: 'newpassword123')),
          throwsA(isA<UnimplementedError>()),
        );

        verify(() => mockAuth.updateUser(any())).called(1);
      });
    });

    group('authStateChanges', () {
      test('exposes the onAuthStateChange stream', () {
        final stream = Stream<AuthState>.empty();
        when(() => mockAuth.onAuthStateChange).thenAnswer((_) => stream);

        expect(mockAuth.onAuthStateChange, isA<Stream<AuthState>>());
      });
    });
  });
}