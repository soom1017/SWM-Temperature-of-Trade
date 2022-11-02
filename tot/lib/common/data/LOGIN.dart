// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// abstract class API {
//   static Future<void> _signInGoogle() async {
//     final GoogleSignInAccount? googleSignInAccount =
//     await GoogleSignIn().signIn();
//     final GoogleSignInAuthentication? googleSignInAuthentication =
//     await googleSignInAccount?.authentication;
//     final AuthCredential credential = GoogleAuthProvider.credential(
//       accessToken: googleSignInAuthentication?.accessToken,
//       idToken: googleSignInAuthentication?.idToken,
//     );
//     UserCredential user =
//     await FirebaseAuth.instance.signInWithCredential(credential);
//     await _authUser({
//       'uid': user.user!.uid.toString(),
//       'access_token':
//       FirebaseAuth.instance.currentUser!.getIdToken().toString(),
//     }, 'etc');
//   }
//
//   Future<void> _signInFacebook() async {
//     final LoginResult result = await FacebookAuth.instance.login();
//     final AuthCredential credential =
//     FacebookAuthProvider.credential(result.accessToken!.token);
//     UserCredential user =
//     await FirebaseAuth.instance.signInWithCredential(credential);
//     await _authUser({
//       'uid': user.user!.uid.toString(),
//       'access_token':
//       FirebaseAuth.instance.currentUser!.getIdToken().toString(),
//     }, 'etc');
//   }
//
//   Future<void> _signInApple() async {
//     final appleCredential = await SignInWithApple.getAppleIDCredential(
//       scopes: [
//         AppleIDAuthorizationScopes.email,
//         AppleIDAuthorizationScopes.fullName,
//       ],
//     );
//
//     final credential = OAuthProvider("apple.com").credential(
//       idToken: appleCredential.identityToken,
//       accessToken: appleCredential.authorizationCode,
//     );
//     UserCredential user =
//     await FirebaseAuth.instance.signInWithCredential(credential);
//     await _authUser({
//       'access_token':
//       FirebaseAuth.instance.currentUser!.getIdToken().toString(),
//     }, 'etc');
//     await API.changeDioToken();
//     await getBookmarkByLoad();
//   }
//
//   Future<void> _signInKakao() async {
//     final isInstalled = await kakao.isKakaoTalkInstalled();
//     late String token;
//     if (isInstalled) {
//       final temp = await kakao.UserApi.instance.loginWithKakaoTalk();
//       token = temp.accessToken;
//     } else {
//       final temp = await kakao.UserApi.instance.loginWithKakaoAccount();
//       token = temp.accessToken;
//     }
//
//     final user = await kakao.UserApi.instance.me();
//     final customToken = await _authUser({
//       'uid': user.id.toString(),
//       'access_token': token.toString(),
//     }, 'kakao');
//
//     await FirebaseAuth.instance.signInWithCustomToken(customToken!);
//     await API.changeDioToken();
//     await getBookmarkByLoad();
//   }
//
//   void _naviToRootTab(BuildContext context) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => RootTab(),
//         ));
//   }
//
//   Future<String?> _authUser(Map<String, dynamic> user, String Oauth) async {
//     try {
//       final String url = '/users/auth/$Oauth';
//       final customTokenResponse = await API.dio.post(url, data: user);
//       return customTokenResponse.data;
//     } catch (e) {
//       print(e);
//       return null;
//     }
//   }
// }
