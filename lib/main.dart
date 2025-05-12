import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(AppDiaryApp());
}

class AppDiaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uygulama Defteri',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppListPage(),
    );
  }
}

class AppInfo {
  String name;
  String category;
  Map<String, dynamic> cookies;
  String packageName;

  AppInfo({
    required this.name, 
    this.category = 'Kategorisiz', 
    this.cookies = const {}, 
    required this.packageName
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'category': category,
    'cookies': cookies,
    'packageName': packageName
  };

  factory AppInfo.fromJson(Map<String, dynamic> json) => AppInfo(
    name: json['name'],
    category: json['category'] ?? 'Kategorisiz',
    cookies: json['cookies'] ?? {},
    packageName: json['packageName']
  );
}

class AppListPage extends StatefulWidget {
  @override
  _AppListPageState createState() => _AppListPageState();
}

class _AppListPageState extends State<AppListPage> {
  List<AppInfo> _apps = [];
  final _storage = FlutterSecureStorage();
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    try {
      // Uygulama listesini yükle
      String? savedAppsJson = await _storage.read(key: 'saved_apps');
      if (savedAppsJson != null) {
        List<dynamic> savedApps = json.decode(savedAppsJson);
        setState(() {
          _apps = savedApps.map((app) => AppInfo.fromJson(app)).toList();
        });
      }
    } catch (e) {
      print('Uygulamalar yüklenirken hata: $e');
    }
  }

  Future<void> _saveApps() async {
    try {
      String appsJson = json.encode(_apps.map((app) => app.toJson()).toList());
      await _storage.write(key: 'saved_apps', value: appsJson);
    } catch (e) {
      print('Uygulamalar kaydedilirken hata: $e');
    }
  }

  Future<void> _fetchAllInstalledApps() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Sistemdeki tüm uygulamaları al
      List<Application> apps = await DeviceApps.getInstalledApplications(
        includeAppIcons: false,
        includeSystemApps: false,
      );

      // Yeni uygulamaları ekle (zaten varsa ekleme)
      for (var app in apps) {
        // Eğer uygulama zaten listede yoksa ekle
        if (!_apps.any((existingApp) => existingApp.packageName == app.packageName)) {
          setState(() {
            _apps.add(AppInfo(
              name: app.appName,
              packageName: app.packageName,
            ));
          });
        }
      }

      // Değişiklikleri kaydet
      await _saveApps();
    } catch (e) {
      print('Uygulamalar alınırken hata: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uygulamalar alınırken hata oluştu'))
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addApp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String category = '';
        Map<String, dynamic> cookies = {};
        String packageName = '';

        return AlertDialog(
          title: Text('Yeni Uygulama Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Uygulama Adı'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Kategori'),
                onChanged: (value) => category = value,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Paket Adı'),
                onChanged: (value) => packageName = value,
              ),
              TextField(
                decoration: InputDecoration(hintText: 'Çerez Bilgileri (JSON formatında)'),
                onChanged: (value) {
                  try {
                    cookies = json.decode(value);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Geçersiz JSON formatı'))
                    );
                  }
                },
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('İptal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Kaydet'),
              onPressed: () {
                if (name.isNotEmpty && packageName.isNotEmpty) {
                  setState(() {
                    _apps.add(AppInfo(
                      name: name, 
                      category: category.isEmpty ? 'Kategorisiz' : category, 
                      cookies: cookies,
                      packageName: packageName
                    ));
                  });
                  _saveApps();
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kategorilere göre gruplandırma
    Map<String, List<AppInfo>> categorizedApps = {};
    for (var app in _apps) {
      if (!categorizedApps.containsKey(app.category)) {
        categorizedApps[app.category] = [];
      }
      categorizedApps[app.category]!.add(app);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Uygulama Defteri'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Tüm Uygulamaları Getir',
            onPressed: _fetchAllInstalledApps,
          ),
        ],
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : ListView(
            children: categorizedApps.entries.map((entry) {
              return ExpansionTile(
                title: Text(entry.key),
                children: entry.value.map((app) {
                  return ListTile(
                    title: Text(app.name),
                    subtitle: Text('Paket Adı: ${app.packageName}'),
                    trailing: Text('Çerez: ${app.cookies.length}'),
                    onTap: () {
                      // Uygulama detaylarını düzenleme
                      _showAppDetailsDialog(app);
                    },
                  );
                }).toList(),
              );
            }).toList(),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addApp,
        child: Icon(Icons.add),
        tooltip: 'Yeni Uygulama Ekle',
      ),
    );
  }

  void _showAppDetailsDialog(AppInfo app) {
    TextEditingController nameController = TextEditingController(text: app.name);
    TextEditingController categoryController = TextEditingController(text: app.category);
    TextEditingController cookiesController = TextEditingController(
      text: json.encode(app.cookies)
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uygulama Detayları'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Uygulama Adı'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Kategori'),
                ),
                TextField(
                  controller: cookiesController,
                  decoration: InputDecoration(labelText: 'Çerez Bilgileri (JSON)'),
                  maxLines: 3,
                ),
                Text('Paket Adı: ${app.packageName}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('İptal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Kaydet'),
              onPressed: () {
                try {
                  // Çerez bilgilerini parse et
                  Map<String, dynamic> updatedCookies = 
                    json.decode(cookiesController.text);

                  // Uygulamayı güncelle
                  setState(() {
                    app.name = nameController.text;
                    app.category = categoryController.text.isEmpty 
                      ? 'Kategorisiz' 
                      : categoryController.text;
                    app.cookies = updatedCookies;
                  });

                  // Değişiklikleri kaydet
                  _saveApps();
                  Navigator.of(context).pop();
                } catch (e) {
                  // JSON parse hatası
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Geçersiz JSON formatı'))
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
