import 'package:heathbridge_lao/package.dart';

class UserProvider extends ChangeNotifier {
  final List<UserModel> _userModel = [];
  List<UserModel> get userModel => _userModel;

  Future<String> getFID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('fid') ?? "";
  }

  Future<String> getUID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid') ?? "";
  }

  Future<void> addUser(UserModel user) async {
    _userModel.add(user);
    notifyListeners();
  }

  Future<void> addUserHasura(List<UserModel> user) async {
    await _addUser(user: user[0]);
    user.clear();
    notifyListeners();
  }

  Future<String> _getUID(String tel) async {
    HasuraConnect connection = HasuraHelper.hasuraHelper;
    String fetchID = """
    query MyQuery(\$tel: String!) {
      users(where: {tel: {_eq: \$tel}}) {
       id
      }
    }
      """;
    var response = await connection.query(fetchID, variables: {
      "tel": tel,
    });
    String uid = response['data']['users'][0]['id'];
    return uid;
  }

  Future<void> _addUser({required UserModel user}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    HasuraConnect connection = HasuraHelper.hasuraHelper;
    String addUser = """
    mutation MyMutation(\$firstname: String, \$gender: String, \$lastname: String, \$password: String, \$tel: String, \$email: String) {
      insert_users(objects: {firstname: \$firstname, lastname: \$lastname, tel: \$tel, gender: \$gender, password: \$password, email: \$email}) {
        affected_rows
      }
    }
      """;
    await connection.mutation(addUser, variables: {
      "firstname": user.firstname,
      "lastname": user.lastname,
      "gender": user.gender,
      "tel": user.tel,
      "password": user.password,
      "email": user.email
    });

    String uid = await _getUID(user.tel ?? "");
    await prefs.setString('uid', uid);
  }

  Future<bool> validateUser(
      {required String tel, required String password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    HasuraConnect connection = HasuraHelper.hasuraHelper;
    String fetchUser = """
    query MyQuery(\$tel: String!) {
      users(where: {tel: {_eq: \$tel}}) {
       password
       user_id
      }
    }
      """;
    var response = await connection.query(fetchUser, variables: {
      "tel": tel,
    });

    String uid = response['data']['users'][0]['id'];
    if (response['data']['users'].isNotEmpty) {
      String fetchedPassword = response['data']['users'][0]['password'];
      if(fetchedPassword == password){
        await prefs.setString('uid', uid);
        return true;
      }else {
      return false;
    }
    } else {
      return false;
    }
  }
}
