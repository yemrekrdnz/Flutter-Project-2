import 'package:flutter/material.dart';

void main() => runApp(HistoricalPlacesApp());

// admin 1234 ile giriş yapabilirsiniz Yunus Emre Karadeniz 221041033
class HistoricalPlacesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tarihi Yerler Yunus Emre',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.teal[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal[700],
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal[600],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username == 'admin' && password == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HistoricalPlacesPage()),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Hatalı Giriş'),
          content: Text('Kullanıcı adı veya şifre yanlış.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Yap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tarihi Yerler Uygulaması',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoricalPlace {
  String name;
  String city;
  String country;
  int age;
  String description;

  HistoricalPlace({
    required this.name,
    required this.city,
    required this.country,
    required this.age,
    required this.description,
  });
}

class HistoricalPlacesPage extends StatefulWidget {
  @override
  _HistoricalPlacesPageState createState() => _HistoricalPlacesPageState();
}

class _HistoricalPlacesPageState extends State<HistoricalPlacesPage> {
  final List<HistoricalPlace> _places = [
    HistoricalPlace(
      name: 'Machu Picchu',
      city: 'Cusco',
      country: 'Peru',
      age: 600,
      description: 'İnka İmparatorluğu\'na ait tarihi bir yerleşim.',
    ),
    HistoricalPlace(
      name: 'Colosseum',
      city: 'Rome',
      country: 'Italy',
      age: 1950,
      description: 'Antik Roma\'nın en büyük amfitiyatrosu.',
    ),
    HistoricalPlace(
      name: 'Taj Mahal',
      city: 'Agra',
      country: 'India',
      age: 370,
      description: 'Şah Cihan tarafından inşa ettirilen bir türbe.',
    ),
  ];

  bool _isAscending = true;
  String _searchName = '';
  String _searchCity = '';

  void _sortPlaces() {
    setState(() {
      _places.sort((a, b) {
        if (_isAscending) {
          return a.name.compareTo(b.name);
        } else {
          return b.name.compareTo(a.name);
        }
      });
    });
  }

  void _sortByAge() {
    setState(() {
      _places.sort((a, b) =>
          _isAscending ? a.age.compareTo(b.age) : b.age.compareTo(a.age));
    });
  }

  void _toggleSortOrder() {
    setState(() {
      _isAscending = !_isAscending;
      _sortPlaces();
    });
  }

  void _addPlace(HistoricalPlace place) {
    setState(() {
      _places.add(place);
      _sortPlaces();
    });
  }

  void _updatePlace(int index, HistoricalPlace updatedPlace) {
    setState(() {
      _places[index] = updatedPlace;
      _sortPlaces();
    });
  }

  void _deletePlace(int index) {
    setState(() {
      _places.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlaces = _places.where((place) {
      return place.name.toLowerCase().contains(_searchName.toLowerCase()) &&
          place.city.toLowerCase().contains(_searchCity.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tarihi Yerler Yunus Emre'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'ascending') {
                _isAscending = true;
              } else if (value == 'descending') {
                _isAscending = false;
              } else if (value == 'age_ascending') {
                _isAscending = true;
                _sortByAge();
              } else if (value == 'age_descending') {
                _isAscending = false;
                _sortByAge();
              }
              _sortPlaces();
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'ascending',
                child: Text('Artan (A-Z)'),
              ),
              PopupMenuItem(
                value: 'descending',
                child: Text('Azalan (Z-A)'),
              ),
              PopupMenuItem(
                value: 'age_ascending',
                child: Text('Yaşa Göre Artan'),
              ),
              PopupMenuItem(
                value: 'age_descending',
                child: Text('Yaşa Göre Azalan'),
              ),
            ],
            icon: Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Mekan Adı Ara'),
              onChanged: (value) {
                setState(() {
                  _searchName = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Şehir Ara'),
              onChanged: (value) {
                setState(() {
                  _searchCity = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredPlaces.length,
              itemBuilder: (ctx, index) {
                final place = filteredPlaces[index];
                return Dismissible(
                  key: Key(place.name),
                  onDismissed: (direction) {
                    _deletePlace(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${place.name} silindi')),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 5,
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        place.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[900],
                        ),
                      ),
                      subtitle: Text(
                        '${place.city}, ${place.country} (${place.age} yıllık)\n${place.description}',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit, color: Colors.teal[700]),
                        onPressed: () =>
                            _showPlaceDialog(isUpdating: true, index: index),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showPlaceDialog(isUpdating: false),
      ),
    );
  }

  void _showPlaceDialog({required bool isUpdating, int? index}) {
    final _nameController = TextEditingController();
    final _cityController = TextEditingController();
    final _countryController = TextEditingController();
    final _ageController = TextEditingController();
    final _descriptionController = TextEditingController();

    if (isUpdating && index != null) {
      final place = _places[index];
      _nameController.text = place.name;
      _cityController.text = place.city;
      _countryController.text = place.country;
      _ageController.text = place.age.toString();
      _descriptionController.text = place.description;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isUpdating ? 'Güncelle' : 'Yeni Kayıt'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Mekan Adı'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'Şehir'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Ülke'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Kaç Yıllık'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Açıklama'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Vazgeç'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final city = _cityController.text.trim();
              final country = _countryController.text.trim();
              final ageText = _ageController.text.trim();
              final description = _descriptionController.text.trim();

              if (name.isEmpty ||
                  city.isEmpty ||
                  country.isEmpty ||
                  description.isEmpty) {
                _showErrorDialog('Tüm alanları doldurunuz.');
                return;
              }

              final age = int.tryParse(ageText);
              if (age == null || age <= 0) {
                _showErrorDialog('Yıl kısmına geçerli bir sayı giriniz.');
                return;
              }

              final newPlace = HistoricalPlace(
                name: name,
                city: city,
                country: country,
                age: age,
                description: description,
              );

              if (isUpdating && index != null) {
                _updatePlace(index, newPlace);
              } else {
                _addPlace(newPlace);
              }

              Navigator.of(ctx).pop();
            },
            child: Text(isUpdating ? 'Güncelle' : 'Ekle'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hata'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Tamam'),
          ),
        ],
      ),
    );
  }
}
