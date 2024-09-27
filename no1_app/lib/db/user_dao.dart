import 'app_database.dart';
import 'models/user_model.dart';

// handles the interactions with the User table, 
// including inserting, querying, updating, and deleting users

"""
HOW TO USE:
import 'db/user_dao.dart';
...
class _UserScreenState extends State<UserScreen> {
  final userDao = UserDao();
...
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: FutureBuilder<List<User>>(
        future: userDao.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No users found.');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('Age: ${user.age}'),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userDao.insertUser(User(name: 'New User', age: 25));
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
"""

class UserDao {
  final dbProvider = AppDatabase.instance;

  Future<void> insertUser(User user) async {
    final db = await dbProvider.database;
    await db.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<User>> getUsers() async {
    final db = await dbProvider.database;
    final result = await db.query('users');

    return result.map((map) => User.fromMap(map)).toList();
  }

  Future<void> updateUser(User user) async {
    final db = await dbProvider.database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int id) async {
    final db = await dbProvider.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}