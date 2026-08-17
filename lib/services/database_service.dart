import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/infusion_log.dart';
import '../models/infusion_type.dart';
import '../models/product.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'infuccino_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Products Table
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        category TEXT NOT NULL,
        imagePath TEXT,
        rating REAL NOT NULL,
        origin TEXT,
        tastingNotes TEXT,
        description TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Infusion Logs Table
    await db.execute('''
      CREATE TABLE infusion_logs (
        id TEXT PRIMARY KEY,
        dateTime TEXT NOT NULL,
        category TEXT NOT NULL,
        type TEXT NOT NULL,
        productId TEXT,
        productName TEXT NOT NULL,
        weightGrams REAL NOT NULL,
        waterVolumeMl REAL,
        temperatureCelsius REAL NOT NULL,
        rating REAL NOT NULL,
        notes TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (productId) REFERENCES products(id) ON DELETE SET NULL
      )
    ''');

    // Seed default products
    await _seedDefaultProducts(db);
  }

  Future<void> _seedDefaultProducts(Database db) async {
    final now = DateTime.now();

    final defaultProducts = [
      // Mate
      Product(
        id: 'prod_mate_1',
        name: 'Canarias Serena',
        brand: 'Canarias',
        category: InfusionCategory.mate,
        rating: 4.9,
        origin: 'Brasil / Uruguay',
        tastingNotes: ['Manzanilla', 'Suave', 'Toronjil', 'Herbal'],
        description: 'Compuesta con hierbas sedantes (toronjil, pasiflora, manzanilla). Molienda fina uruguaya de gran durabilidad.',
        createdAt: now.subtract(const Duration(days: 30)),
      ),
      Product(
        id: 'prod_mate_2',
        name: 'Playadito Tradicional',
        brand: 'Playadito (Cooperativa Liebig)',
        category: InfusionCategory.mate,
        rating: 4.8,
        origin: 'Corrientes, Argentina',
        tastingNotes: ['Dulce', 'Suave', 'Bajo contenido de polvo', 'Floral'],
        description: 'Elaborada con palo, estacionamiento natural. Sabor suave, ideal para todo el día.',
        createdAt: now.subtract(const Duration(days: 28)),
      ),
      Product(
        id: 'prod_mate_3',
        name: 'Rosamonte Especial',
        brand: 'Rosamonte',
        category: InfusionCategory.mate,
        rating: 4.7,
        origin: 'Misiones, Argentina',
        tastingNotes: ['Intenso', 'Ahumado', 'Madera', 'Barbacuá'],
        description: 'Estacionamiento prolongado de 24 meses. Sabor fuerte y característico.',
        createdAt: now.subtract(const Duration(days: 25)),
      ),

      // Café
      Product(
        id: 'prod_cafe_1',
        name: 'Geisha Los Pozos',
        brand: 'Café de Especialidad Panamá',
        category: InfusionCategory.cafe,
        rating: 4.95,
        origin: 'Boquete, Panamá (1800 msnm)',
        tastingNotes: ['Jazmín', 'Bergamota', 'Melocotón', 'Miel'],
        description: 'Varietal Geisha proceso lavado. Perfil floral y cítrico complejo espectacular en V60.',
        createdAt: now.subtract(const Duration(days: 22)),
      ),
      Product(
        id: 'prod_cafe_2',
        name: 'Etiopía Yirgacheffe G1',
        brand: 'Tostador Artesanal',
        category: InfusionCategory.cafe,
        rating: 4.85,
        origin: 'Yirgacheffe, Etiopía',
        tastingNotes: ['Floral', 'Cítrico limón', 'Frutos rojos', 'Acidez brillante'],
        description: 'Origen mítico del café. Acidez brillante y notas a flores de jazmín.',
        createdAt: now.subtract(const Duration(days: 18)),
      ),
      Product(
        id: 'prod_cafe_3',
        name: 'Colombia Huila Supremo',
        brand: 'Origen Andino',
        category: InfusionCategory.cafe,
        rating: 4.75,
        origin: 'Huila, Colombia',
        tastingNotes: ['Chocolate amargo', 'Caramelo', 'Avellana'],
        description: 'Tueste medio. Cuerpo sedoso y balance perfecto para French Press o Moka.',
        createdAt: now.subtract(const Duration(days: 15)),
      ),

      // Té
      Product(
        id: 'prod_te_1',
        name: 'Earl Grey Imperial',
        brand: 'Twinings / Especialidad',
        category: InfusionCategory.te,
        rating: 4.9,
        origin: 'Sri Lanka & Bergamota de Calabria',
        tastingNotes: ['Bergamota', 'Cítrico limón', 'Floral', 'Té negro'],
        description: 'Hebras seleccionadas de té negro aromatizadas con aceite natural de bergamota.',
        createdAt: now.subtract(const Duration(days: 14)),
      ),
      Product(
        id: 'prod_te_2',
        name: 'Sencha Verde Orgánico',
        brand: 'Kyoto Tea House',
        category: InfusionCategory.te,
        rating: 4.85,
        origin: 'Uji, Kioto, Japón',
        tastingNotes: ['Herbal', 'Pasto fresco', 'Algas', 'Dulce'],
        description: 'Té verde japonés cosechado en primavera, vaporizado suavemente.',
        createdAt: now.subtract(const Duration(days: 10)),
      ),
      Product(
        id: 'prod_te_3',
        name: 'Manzanilla, Lavanda & Miel',
        brand: 'Herbal Blend',
        category: InfusionCategory.te,
        rating: 4.7,
        origin: 'Patagonia, Argentina',
        tastingNotes: ['Manzanilla', 'Lavanda', 'Miel', 'Vainilla'],
        description: 'Infusión relajante libre de cafeína en saquitos piramidales de seda.',
        createdAt: now.subtract(const Duration(days: 8)),
      ),
    ];

    for (var prod in defaultProducts) {
      await db.insert('products', prod.toMap());
    }

    // Seed sample logs
    final sampleLogs = [
      InfusionLog(
        id: 'log_seed_1',
        dateTime: DateTime(now.year, now.month, now.day, 8, 30),
        category: InfusionCategory.mate,
        type: InfusionType.mateTradicional,
        productId: 'prod_mate_1',
        productName: 'Canarias Serena',
        weightGrams: 35.0,
        waterVolumeMl: 750.0,
        temperatureCelsius: 78.0,
        rating: 5.0,
        notes: 'Espuma abundante y excelente aguante del mate matutino.',
      ),
      InfusionLog(
        id: 'log_seed_2',
        dateTime: DateTime(now.year, now.month, now.day, 16, 0),
        category: InfusionCategory.cafe,
        type: InfusionType.cafeV60,
        productId: 'prod_cafe_1',
        productName: 'Geisha Los Pozos',
        weightGrams: 18.0,
        waterVolumeMl: 300.0,
        temperatureCelsius: 92.0,
        rating: 4.9,
        notes: 'Ratio 1:16.6, tiempo de extracción 2m 45s. Notas florales muy nítidas.',
      ),
      InfusionLog(
        id: 'log_seed_3',
        dateTime: DateTime(now.year, now.month, now.day, 20, 15),
        category: InfusionCategory.te,
        type: InfusionType.teHebras,
        productId: 'prod_te_1',
        productName: 'Earl Grey Imperial',
        weightGrams: 4.0,
        waterVolumeMl: 280.0,
        temperatureCelsius: 85.0,
        rating: 4.8,
        notes: 'Infusionado por 3 minutos exactos. Aroma cítrico envolvente.',
      ),
    ];

    for (var log in sampleLogs) {
      await db.insert('infusion_logs', log.toMap());
    }
  }

  // --- Products CRUD ---
  Future<List<Product>> getProducts({InfusionCategory? category}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps;

    if (category != null) {
      maps = await db.query(
        'products',
        where: 'category = ?',
        whereArgs: [category.name],
        orderBy: 'rating DESC, createdAt DESC',
      );
    } else {
      maps = await db.query(
        'products',
        orderBy: 'rating DESC, createdAt DESC',
      );
    }

    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<Product?> getProductById(String id) async {
    final db = await database;
    final maps = await db.query('products', where: 'id = ?', whereArgs: [id], limit: 1);
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(String id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // --- Infusion Logs CRUD ---
  Future<List<InfusionLog>> getAllLogs() async {
    final db = await database;
    final maps = await db.query('infusion_logs', orderBy: 'dateTime DESC');
    return maps.map((m) => InfusionLog.fromMap(m)).toList();
  }

  Future<List<InfusionLog>> getLogsForDay(DateTime day) async {
    final db = await database;
    final startOfDay = DateTime(day.year, day.month, day.day, 0, 0, 0).toIso8601String();
    final endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59).toIso8601String();

    final maps = await db.query(
      'infusion_logs',
      where: 'dateTime >= ? AND dateTime <= ?',
      whereArgs: [startOfDay, endOfDay],
      orderBy: 'dateTime DESC',
    );
    return maps.map((m) => InfusionLog.fromMap(m)).toList();
  }

  Future<List<InfusionLog>> getLogsForProduct(String productId) async {
    final db = await database;
    final maps = await db.query(
      'infusion_logs',
      where: 'productId = ?',
      whereArgs: [productId],
      orderBy: 'dateTime DESC',
    );
    return maps.map((m) => InfusionLog.fromMap(m)).toList();
  }

  Future<int> insertLog(InfusionLog log) async {
    final db = await database;
    return await db.insert(
      'infusion_logs',
      log.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateLog(InfusionLog log) async {
    final db = await database;
    return await db.update(
      'infusion_logs',
      log.toMap(),
      where: 'id = ?',
      whereArgs: [log.id],
    );
  }

  Future<int> deleteLog(String id) async {
    final db = await database;
    return await db.delete('infusion_logs', where: 'id = ?', whereArgs: [id]);
  }
}
