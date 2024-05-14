import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'hasura_token_interceptor.dart';

class HasuraHelper {
  static HasuraConnect? hasuraConnect;
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static HasuraConnect get hasuraHelper {
    hasuraConnect = HasuraConnect(
      dotenv.env['HASURA_ENDPOINT']!,
      // headers: {
      //   "content-type": 'application/json',
      //   "x-hasura-admin-secret": "8LsOMZkwjeQes7whcogqdMiAaRyITVnirnR1emToP49z2Sgl0SFz0OK6VjD2sc9o"

      // }
      interceptors: [TokenInterceptor()],
    );
    return hasuraConnect!;
  }
}
