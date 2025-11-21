import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "electrical_store.db");

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute("""
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT
      );
    """);

    await db.execute("""
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        subTitle TEXT,
        description TEXT,
        price INTEGER,
        image TEXT,
        category TEXT
      );
    """);

    await db.execute("""
      CREATE TABLE likes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        productId INTEGER
      );
    """);

    await db.execute("CREATE INDEX idx_user_email ON users(email);");
    await db.execute("CREATE INDEX idx_likes_user ON likes(userId);");
    await db.execute("CREATE INDEX idx_likes_product ON likes(productId);");

    await insertDefaultAdmin(db);
    await insertDefaultProducts(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE products ADD COLUMN category TEXT;");
    }
  }

  Future<void> insertDefaultAdmin(Database db) async {
    final existing = await db.query(
      "users",
      where: "email = ?",
      whereArgs: ["admin@gmail.com"],
      limit: 1,
    );

    if (existing.isEmpty) {
      await db.insert("users", {
        "name": "Admin",
        "email": "admin@gmail.com",
        "password": "123456789",
      });
    }
  }

  Future<void> insertDefaultProducts(Database db) async {
    final products = [
      {
        "title": "سماعات لاسلكية",
        "subTitle": "جودة صوت عالية",
        "description": "لوريم ايبسوم",
        "price": 59,
        "image": "assets/airpod.png",
        "category": "الإلكترونيات والأجهزة"
      },
      {
        "title": "جهاز موبايل",
        "subTitle": "وأصبح للموبايل قوة",
        "description": "لوريم ايبسوم",
        "price": 1099,
        "image": "assets/mobile.png",
        "category": "الإلكترونيات والأجهزة"
      },
      {
        "title": "نظارات ثلاثية الأبعاد",
        "subTitle": "لنقلك للعالم الافتراضي",
        "description": "لوريم ايبسوم",
        "price": 39,
        "image": "assets/class.png",
        "category": "الإلكترونيات والأجهزة"
      },
      {
        "title": "سماعات",
        "subTitle": "لساعات استماع طويلة",
        "description": "لوريم ايبسوم",
        "price": 56,
        "image": "assets/headset.png",
        "category": "الإلكترونيات والأجهزة"
      },
      {
        "title": "مسجل صوت",
        "subTitle": "سجل اللحظات المهمة حولك",
        "description": "لوريم ايبسوم",
        "price": 68,
        "image": "assets/speaker.png",
        "category": "الإلكترونيات والأجهزة"
      },
      {
        "title": "كاميرات كمبيوتر",
        "subTitle": "بجودة ودقة صورة عالية",
        "description": "لوريم ايبسوم",
        "price": 39,
        "image": "assets/camera.png",
        "category": "الإلكترونيات والأجهزة"
      },
    ];

    for (var p in products) {
      await db.insert("products", p);
    }
  }

 
}
