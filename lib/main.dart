import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REST API_Json_Place Holder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> posts = [];
  List<Album> albums = [];
  List<User> users = [];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final postsResponse = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      final albumsResponse = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));
      final usersResponse = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

      if (postsResponse.statusCode == 200 &&
          albumsResponse.statusCode == 200 &&
          usersResponse.statusCode == 200) {
        setState(() {
          posts = (jsonDecode(postsResponse.body) as List)
              .map((e) => Post.fromJson(e))
              .toList();
          albums = (jsonDecode(albumsResponse.body) as List)
              .map((e) => Album.fromJson(e))
              .toList();
          users = (jsonDecode(usersResponse.body) as List)
              .map((e) => User.fromJson(e))
              .toList();
        });
      } else {
        print('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'REST API_json_place holder',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: _currentIndex == 0
          ? PostsWidget(posts: posts)
          : _currentIndex == 1
              ? AlbumsWidget(albums: albums)
              : UsersWidget(users: users),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Posts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album),
            label: 'Albums',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}

class PostsWidget extends StatelessWidget {
  final List<Post> posts;

  PostsWidget({required this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text(
                  (index + 1).toString(),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              title: Text(
                posts[index].title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              subtitle: Text(posts[index].body),
            ),
          ),
        );
      },
    );
  }
}

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class AlbumsWidget extends StatelessWidget {
  final List<Album> albums;

  AlbumsWidget({required this.albums});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: albums.length,
      itemBuilder: (context, index) {
        Album currentAlbum = albums[index];

        return Center(
            child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('userId: ${currentAlbum.userId}'),
                Text('id: ${currentAlbum.id}'),
                Text('${currentAlbum.title}'),
              ],
            ),
          ),
        ));
      },
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class UsersWidget extends StatelessWidget {
  final List<User> users;

  UsersWidget({required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return Center(
            child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("id: ${user.id ?? ''}"),
                Text("Name: ${user.name ?? ''}"),
                Text("Username: ${user.username ?? ''}"),
                Text("Email: ${user.email ?? ''}"),
                Text(
                    "Address: ${user.address.street ?? ''}, ${user.address.suite ?? ''}, ${user.address.city ?? ''}, ${user.address.zipcode ?? ''}, ${user.address.geo ?? ''}, ${user.address.geo.lat ?? ''}, ${user.address.geo.lng ?? ''}"),
                Text("Phone: ${user.phone ?? ''}"),
                Text("Website: ${user.website ?? ''}"),
                Text(
                    "Company: ${user.company.name ?? ''}, ${user.company.catchPhrase ?? ''}, ${user.company.bs ?? ''}"),
              ],
            ),
          ),
        ));
      },
    );
  }
}

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    required this.website,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      address: Address.fromJson(json['address']),
      phone: json['phone'],
      website: json['website'],
      company: Company.fromJson(json['company']),
    );
  }
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  Address({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
    required this.geo,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      suite: json['suite'],
      city: json['city'],
      zipcode: json['zipcode'],
      geo: Geo.fromJson(json['geo']),
    );
  }
}

class Geo {
  final String lat;
  final String lng;

  Geo({
    required this.lat,
    required this.lng,
  });

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      lat: json['lat'] ?? '',
      lng: json['lng'] ?? '',
    );
  }
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({
    required this.name,
    required this.catchPhrase,
    required this.bs,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'] ?? '',
      catchPhrase: json['catchPhrase'] ?? '',
      bs: json['bs'] ?? '',
    );
  }
}
