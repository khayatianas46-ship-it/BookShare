import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BookShareApp());
}

const Color green = Color(0xFF386641);
const Color cream = Color(0xFFFFFBF4);
const Color coral = Color(0xFFFF8066);
const Color purple = Color(0xFF8C78D8);
const Color yellow = Color(0xFFFFD166);
const Color blue = Color(0xFF75C9D5);

class BookShareApp extends StatelessWidget {
  const BookShareApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BookShare',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: cream,
          colorScheme: ColorScheme.fromSeed(seedColor: green),
          appBarTheme: const AppBarTheme(
            backgroundColor: cream,
            foregroundColor: green,
            elevation: 0,
          ),
        ),
        home: const MainPage(),
      );
}

// -------------------- DONNEES --------------------
class Book {
  final String title;
  final String author;
  final String category;
  final Color color;
  final IconData icon;
  final String coverUrl;

  const Book({
    required this.title,
    required this.author,
    required this.category,
    required this.color,
    required this.icon,
    required this.coverUrl,
  });
}

const List<Book> books = [
  Book(
    title: 'Le Petit Prince',
    author: 'Antoine de Saint-Exupéry',
    category: 'Romans',
    color: Color(0xFFFFDFA8),
    icon: Icons.star_rounded,
    coverUrl: 'https://covers.openlibrary.org/b/isbn/9782070612758-L.jpg?default=false',
  ),
  Book(
    title: 'Les Misérables',
    author: 'Victor Hugo',
    category: 'Classiques',
    color: Color(0xFFD5E8D4),
    icon: Icons.account_balance_rounded,
    coverUrl: 'https://covers.openlibrary.org/b/isbn/9782253096344-L.jpg?default=false',
  ),
  Book(
    title: 'L’Étranger',
    author: 'Albert Camus',
    category: 'Romans',
    color: Color(0xFFE9D5E8),
    icon: Icons.nightlight_round,
    coverUrl: 'https://covers.openlibrary.org/b/isbn/9782070360024-L.jpg?default=false',
  ),
  Book(
    title: 'Harry Potter',
    author: 'J. K. Rowling',
    category: 'Jeunesse',
    color: Color(0xFFD9E9F7),
    icon: Icons.auto_awesome_rounded,
    coverUrl:
    'https://covers.openlibrary.org/b/title/Harry%20Potter%20and%20the%20Philosopher%27s%20Stone-L.jpg?default=false',

  ),
  Book(
    title: 'Une brève histoire du temps',
    author: 'Stephen Hawking',
    category: 'Science',
    color: Color(0xFFFFE5B4),
    icon: Icons.public_rounded,
    coverUrl:
    'https://covers.openlibrary.org/b/title/A%20Brief%20History%20of%20Time-L.jpg?default=false',
  ),
  Book(
    title: 'Le Comte de Monte-Cristo',
    author: 'Alexandre Dumas',
    category: 'Classiques',
    color: Color(0xFFD8E6D0),
    icon: Icons.directions_boat_rounded,
    coverUrl:
    'https://covers.openlibrary.org/b/title/The%20Count%20of%20Monte%20Cristo-L.jpg?default=false',
  ),
];

// -------------------- NAVIGATION PRINCIPALE --------------------
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<String> titles = const [
    'Catalogue',
    'Mes emprunts',
    'Événements',
    'Messages',
    'Mon profil',
  ];

  final List<IconData> icons = const [
    Icons.auto_stories_rounded,
    Icons.bookmark_rounded,
    Icons.event_rounded,
    Icons.chat_bubble_rounded,
    Icons.person_rounded,
  ];

  void selectPage(int index) {
    setState(() => selectedIndex = index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const CataloguePage(),
      const LoansPage(),
      const EventsPage(),
      const MessagesPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.auto_stories_rounded, size: 28),
            const SizedBox(width: 9),
            Text(titles[selectedIndex],
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tu es à jour ! Aucune notification.')),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        backgroundColor: cream,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
                decoration: const BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(30)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.menu_book_rounded, size: 34, color: green),
                    ),
                    SizedBox(height: 15),
                    Text('BookShare', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Text('Lire, partager, découvrir.', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Text('MENU PRINCIPAL', style: TextStyle(color: Colors.black45, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.4)),
              ),
              const SizedBox(height: 10),
              for (int i = 0; i < titles.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  child: ListTile(
                    selected: selectedIndex == i,
                    selectedTileColor: const Color(0xFFE2EEDC),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    leading: Icon(icons[i], color: selectedIndex == i ? green : Colors.black54),
                    title: Text(titles[i], style: TextStyle(fontWeight: selectedIndex == i ? FontWeight.bold : FontWeight.normal, color: selectedIndex == i ? green : Colors.black87)),
                    trailing: selectedIndex == i ? const Icon(Icons.chevron_right, color: green) : null,
                    onTap: () => selectPage(i),
                  ),
                ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFFFFE7D8), borderRadius: BorderRadius.circular(18)),
                  child: const Row(children: [
                    Icon(Icons.favorite_rounded, color: coral),
                    SizedBox(width: 10),
                    Expanded(child: Text('Chaque livre ouvre un nouveau monde.', style: TextStyle(fontWeight: FontWeight.w600))),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: selectedIndex, children: pages),
    );
  }
}

// -------------------- CATALOGUE --------------------
class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  String search = '';
  String category = 'Tous';
  final List<String> categories = const ['Tous', 'Romans', 'Classiques', 'Science', 'Jeunesse'];

  @override
  Widget build(BuildContext context) {
    final query = search.toLowerCase().trim();
    final filtered = books.where((book) {
      final matchesSearch = book.title.toLowerCase().contains(query) || book.author.toLowerCase().contains(query);
      final matchesCategory = category == 'Tous' || book.category == category;
      return matchesSearch && matchesCategory;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 25),
      children: [
        
Container(
  padding: const EdgeInsets.all(22),
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      colors: [green, Color(0xFF63966A)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(25),
    ),
  ),
  child: const Stack(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SALUT, LECTEUR ! 👋',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 11,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Une nouvelle\nhistoire t’attend.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              height: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Trouve ton prochain livre préféré.',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      Positioned(
        right: 0,
        bottom: 0,
        child: Icon(
          Icons.auto_stories_rounded,
          size: 70,
          color: Color(0x66FFFFFF),
        ),
      ),
    ],
  ),
),

        const SizedBox(height: 24),
        TextField(
          onChanged: (value) => setState(() => search = value),
          decoration: InputDecoration(
            hintText: 'Titre, auteur...',
            prefixIcon: const Icon(Icons.search, color: green),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 17),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(17), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Explorer les catégories', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 13),
        SizedBox(
          height: 43,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: categories.map((item) {
              final selected = category == item;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(item), selected: selected, selectedColor: green, backgroundColor: Colors.white,
                  labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
                  onSelected: (_) => setState(() => category = item),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 25),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Livres à découvrir', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          Text('${filtered.length} livres', style: const TextStyle(color: Colors.black54)),
        ]),
        const SizedBox(height: 15),
        if (filtered.isEmpty)
          const Padding(padding: EdgeInsets.all(30), child: Center(child: Text('Aucun livre trouvé.')))
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) => BookCard(book: filtered[index]),
          ),
      ],
    );
  }
}

// Couvertures réelles chargées depuis Open Library.
// Si une image n'est pas disponible, une couverture de secours s'affiche.
class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  Widget fallbackCover({bool large = false}) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [book.color, Color.lerp(book.color, Colors.black, 0.22)!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(large ? 14 : 9),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: large ? 7 : 5,
                decoration: BoxDecoration(
                  color: green.withOpacity(0.75),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(large ? 14 : 9),
                    bottomLeft: Radius.circular(large ? 14 : 9),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(large ? 12 : 8, 10, 7, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(book.icon, color: green.withOpacity(0.9), size: large ? 30 : 22),
                  const Spacer(),
                  Text(
                    book.title,
                    maxLines: large ? 5 : 4,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: green,
                      fontWeight: FontWeight.w900,
                      fontSize: large ? 12 : 9,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    book.author,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: green.withOpacity(0.8), fontSize: large ? 8 : 6),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget coverImage({bool large = false}) => ClipRRect(
        borderRadius: BorderRadius.circular(large ? 14 : 9),
        child: Image.network(
          book.coverUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          // Flutter Web: utilise un élément image HTML en cas de problème CORS.
          loadingBuilder: (context, child, progress) {
            if (progress == null) return child;
            return Container(
              color: const Color(0xFFF0F0E8),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: green),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) => fallbackCover(large: large),
        ),
      );

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => showDialog<void>(
            context: context,
            builder: (dialogContext) => AlertDialog(
              backgroundColor: cream,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(book.title, style: const TextStyle(color: green, fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(width: 115, height: 170, child: coverImage(large: true)),
                  const SizedBox(height: 16),
                  Text('Auteur : ${book.author}', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text('Catégorie : ${book.category}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Fermer', style: TextStyle(color: green)),
                ),
                
FilledButton(
  style: FilledButton.styleFrom(backgroundColor: green),
  onPressed: () async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pop(dialogContext);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Connecte-toi dans Mon profil pour réserver un livre.',
          ),
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .add({
        'userId': user.uid,
        'bookTitle': book.title,
        'author': book.author,
        'category': book.category,
        'status': 'en_attente',
        'requestedAt': FieldValue.serverTimestamp(),
      });

      if (!context.mounted) return;

      Navigator.pop(dialogContext);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ta demande de réservation a été enregistrée !',
          ),
        ),
      );
    } on FirebaseException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.code == 'permission-denied'
                ? 'Accès refusé : vérifie les règles Firestore.'
                : 'Impossible de réserver : ${e.message ?? e.code}',
          ),
        ),
      );
    }
  },
  child: const Text('Réserver'),
),

              ],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8EDE5)),
              boxShadow: [BoxShadow(color: green.withOpacity(0.035), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                SizedBox(width: 76, height: 104, child: coverImage()),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFEAF1E6), borderRadius: BorderRadius.circular(20)),
                        child: Text(book.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: green, fontSize: 10, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(height: 8),
                      Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, height: 1.2, color: Color(0xFF26352A))),
                      const SizedBox(height: 5),
                      Text(book.author, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54, fontSize: 11, height: 1.25)),
                      const SizedBox(height: 8),
                      const Row(children: [
                        Icon(Icons.menu_book_rounded, size: 14, color: green),
                        SizedBox(width: 5),
                        Text('Voir les détails', style: TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.w600)),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, color: green, size: 22),
              ],
            ),
          ),
        ),
      );
}

// -------------------- EMPRUNTS --------------------

class LoansPage extends StatelessWidget {
  const LoansPage({super.key});

  @override
  @override
Widget build(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;

  debugPrint('Utilisateur Firebase : ${user?.uid}');
  debugPrint('Email Firebase : ${user?.email}');

  if (user == null) {
    return const Center(
      child: EmptyState(
        icon: Icons.person_outline_rounded,
        title: 'Connexion nécessaire',
        message: 'Connecte-toi pour consulter tes réservations.',
        color: purple,
      ),
    );
  }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('reservations')
          .where('userId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Impossible de charger tes réservations. '
                'Vérifie les règles Firestore.',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: green),
          );
        }

        final reservations = snapshot.data?.docs ?? [];

        if (reservations.isEmpty) {
          return const Center(
            child: EmptyState(
              icon: Icons.menu_book_rounded,
              title: 'Aucune réservation',
              message:
                  'Lorsque tu réserveras un livre, il apparaîtra ici.',
              color: purple,
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Mes réservations',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: green,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${reservations.length} réservation(s)',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 18),
            ...reservations.map((reservation) {
              final data = reservation.data();
              final title =
                  data['bookTitle']?.toString() ?? 'Livre inconnu';
              final author =
                  data['author']?.toString() ?? 'Auteur inconnu';
              final status =
                  data['status']?.toString() ?? 'en_attente';

              final normalizedStatus = status.toLowerCase();

              final Color statusColor;
              final String statusLabel;
              final IconData statusIcon;

              if (normalizedStatus == 'acceptee' ||
                  normalizedStatus == 'acceptée' ||
                  normalizedStatus == 'acceptee') {
                statusColor = green;
                statusLabel = 'Acceptée';
                statusIcon = Icons.check_circle_rounded;
              } else if (normalizedStatus == 'refusee' ||
                  normalizedStatus == 'refusée' ||
                  normalizedStatus == 'refusée') {
                statusColor = Colors.red;
                statusLabel = 'Refusée';
                statusIcon = Icons.cancel_rounded;
              } else {
                statusColor = Colors.orange;
                statusLabel = 'En attente';
                statusIcon = Icons.hourglass_top_rounded;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFECECE7)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 55,
                      height: 65,
                      decoration: BoxDecoration(
                        color: purple.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: purple,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: green,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            author,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                statusIcon,
                                size: 16,
                                color: statusColor,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                statusLabel,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}


// -------------------- EVENEMENTS --------------------
class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('La vie de la bibliothèque 🎉', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Rencontres, ateliers et découvertes.', style: TextStyle(color: Colors.black54)),
          const SizedBox(height: 22),
          eventCard(context, color: const Color(0xFFFFE0D5), icon: Icons.menu_book_rounded, date: 'SAMEDI • 15:00', title: 'Atelier de lecture', description: 'Un moment convivial pour partager nos histoires préférées.'),
          eventCard(context, color: const Color(0xFFDCE8FF), icon: Icons.groups_rounded, date: 'PROCHAINEMENT', title: 'Club des lecteurs', description: 'Découvre de nouveaux auteurs et échange tes idées.'),
          eventCard(context, color: const Color(0xFFFFEDB8), icon: Icons.palette_rounded, date: 'PROCHAINEMENT', title: 'Atelier créatif', description: 'Une activité ludique autour des livres et de l’imagination.'),
        ],
      );

  Widget eventCard(BuildContext context, {required Color color, required IconData icon, required String date, required String title, required String description}) => Container(
        margin: const EdgeInsets.only(bottom: 17),
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(23)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 115, width: double.infinity, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(17)), child: Icon(icon, size: 58, color: green)),
          const SizedBox(height: 15),
          Text(date, style: const TextStyle(color: green, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
          const SizedBox(height: 7),
          Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
          const SizedBox(height: 7),
          Text(description, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 13),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              style: FilledButton.styleFrom(backgroundColor: green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Les inscriptions seront disponibles prochainement.'))),
              child: const Text('En savoir plus'),
            ),
          ),
        ]),
      );
}

// -------------------- MESSAGES --------------------
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = [
      {'name': 'Bibliothèque', 'message': 'Bienvenue sur BookShare !', 'time': '09:30'},
      {'name': 'Équipe des bénévoles', 'message': 'Les prochains événements arrivent.', 'time': 'Hier'},
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Tes conversations 💬', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Reste en contact avec ta bibliothèque.', style: TextStyle(color: Colors.black54)),
        const SizedBox(height: 22),
        for (int i = 0; i < conversations.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: CircleAvatar(
                radius: 27,
                backgroundColor: i == 0 ? const Color(0xFFDCE8FF) : const Color(0xFFFFE0D5),
                child: Icon(i == 0 ? Icons.local_library_rounded : Icons.groups_rounded, color: green),
              ),
              title: Text(conversations[i]['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(padding: const EdgeInsets.only(top: 6), child: Text(conversations[i]['message']!)),
              trailing: Text(conversations[i]['time']!, style: const TextStyle(fontSize: 11, color: Colors.black45)),
              onTap: () => showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text(conversations[i]['name']!),
                  content: const Text('La messagerie complète sera disponible après connexion au backend.'),
                  actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Fermer'))],
                ),
              ),
            ),
          ),
        const SizedBox(height: 10),
        const EmptyState(icon: Icons.forum_rounded, title: 'Une messagerie à découvrir', message: 'Tu pourras échanger avec les bénévoles et les autres membres lorsque la messagerie sera connectée.', color: coral),
      ],
    );
  }
}

// -------------------- PROFIL / INSCRIPTION --------------------
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

 bool isLoggedIn = false;
bool showLogin = false;
bool hidePassword = true;
bool isLoading = false;

String memberName = '';
String memberEmail = '';

@override
void initState() {
  super.initState();

  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    isLoggedIn = true;
    memberName =
        user.displayName ?? user.email?.split('@').first ?? 'Membre';
    memberEmail = user.email ?? '';
  }
}


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  
Future<void> submitForm() async {
  if (!_formKey.currentState!.validate() || isLoading) return;

  setState(() => isLoading = true);

  final email = _emailController.text.trim();
  final password = _passwordController.text;
  final isLogin = showLogin;

  try {
    late UserCredential credential;
    late String name;

   
if (isLogin) {
  // Connexion
  credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );

  debugPrint(
  'Connexion Firebase réussie : ${credential.user?.uid}',
);

await Future<void>.delayed(const Duration(seconds: 2));

debugPrint(
  'Session Firebase après 2 secondes : '
  '${FirebaseAuth.instance.currentUser?.uid}',
);
  final user = credential.user!;
  name = user.displayName ?? email.split('@').first;

  // Récupération du nom enregistré dans Firestore
  try {
    final profile = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final savedName = profile.data()?['name'];
    if (savedName is String && savedName.isNotEmpty) {
      name = savedName;
    }
  } catch (_) {
    // La connexion reste possible si le profil Firestore
    // n'est pas accessible.
  }
} else {

      // Création du compte
      name = _nameController.text.trim();

      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user!;

      await user.updateDisplayName(name);

      // Le compte reste connecté même si l'enregistrement
      // complémentaire dans Firestore échoue.
      if (mounted) {
        setState(() {
          isLoggedIn = true;
          memberName = name;
          memberEmail = email;
        });
      }

      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        debugPrint('Erreur enregistrement profil Firestore : $e');
      }
    }

    if (!mounted) return;

    setState(() {
      isLoggedIn = true;
      memberName = name;
      memberEmail = email;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isLogin
              ? 'Connexion réussie !'
              : 'Compte créé avec succès !',
        ),
      ),
    );
  } on FirebaseAuthException catch (e) {
    String message;

    switch (e.code) {
      case 'email-already-in-use':
        message = 'Cette adresse e-mail possède déjà un compte.';
        break;
      case 'invalid-email':
        message = 'Adresse e-mail invalide.';
        break;
      case 'weak-password':
        message = 'Le mot de passe doit contenir au moins 6 caractères.';
        break;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        message = 'E-mail ou mot de passe incorrect.';
        break;
      case 'too-many-requests':
        message = 'Trop de tentatives. Réessaie plus tard.';
        break;
      case 'network-request-failed':
        message = 'Vérifie ta connexion Internet.';
        break;
      case 'operation-not-allowed':
        message = 'Active Email/Password dans Firebase Authentication.';
        break;
      default:
        message = 'Erreur Firebase : ${e.message ?? e.code}';
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Une erreur est survenue : $e')),
      );
    }
  } finally {
    if (mounted) {
      setState(() => isLoading = false);
    }
  }
}


  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return ListView(
        padding: const EdgeInsets.all(22),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(25)),
            child: const Column(children: [
              CircleAvatar(radius: 38, backgroundColor: Colors.white, child: Icon(Icons.person_rounded, color: green, size: 45)),
              SizedBox(height: 13),
              Text('Bienvenue sur BookShare', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 7),
              Text('Connecte-toi pour retrouver ton espace lecteur.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
            ]),
          ),
          const SizedBox(height: 25),
          Text(showLogin ? 'Connexion' : 'Créer un compte', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          Form(
            key: _formKey,
            child: Column(children: [
              if (!showLogin) ...[
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Nom et prénom', prefixIcon: Icon(Icons.person_outline), filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Entre ton nom et prénom.' : null,
                ),
                const SizedBox(height: 14),
              ],
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Adresse e-mail', prefixIcon: Icon(Icons.email_outlined), filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
                validator: (value) => value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim()) ? 'Entre une adresse e-mail valide.' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  labelText: 'Mot de passe', prefixIcon: const Icon(Icons.lock_outline), filled: true, fillColor: Colors.white, border: const OutlineInputBorder(),
                  suffixIcon: IconButton(onPressed: () => setState(() => hidePassword = !hidePassword), icon: Icon(hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                ),
                validator: (value) => value == null || value.length < 6 ? 'Utilise au moins 6 caractères.' : null,
              ),
              if (!showLogin) ...[
                const SizedBox(height: 14),
                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirmer le mot de passe', prefixIcon: Icon(Icons.lock_reset_rounded), filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
                  validator: (value) => value != _passwordController.text ? 'Les mots de passe ne correspondent pas.' : null,
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: green),
                  onPressed: submitForm,
                  child: Text(showLogin ? 'Se connecter' : 'Créer mon compte', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => setState(() {
                showLogin = !showLogin;
                _formKey.currentState?.reset();
                _passwordController.clear();
                _confirmController.clear();
              }),
              child: Text(showLogin ? 'Pas encore de compte ? Inscris-toi' : 'Tu as déjà un compte ? Connecte-toi', textAlign: TextAlign.center, style: const TextStyle(color: green)),
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(color: green, borderRadius: BorderRadius.circular(25)),
          child: Column(children: [
            const CircleAvatar(radius: 43, backgroundColor: Colors.white, child: Icon(Icons.person_rounded, size: 52, color: green)),
            const SizedBox(height: 14),
            Text(memberName, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(memberEmail, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 5),
            const Text('Membre de la bibliothèque', style: TextStyle(color: Colors.white70)),
          ]),
        ),
        const SizedBox(height: 22),
        const Row(children: [
          Expanded(child: ProfileStat(icon: Icons.menu_book_rounded, value: '0', label: 'Emprunts', color: Color(0xFFDCE8FF))),
          SizedBox(width: 12),
          Expanded(child: ProfileStat(icon: Icons.favorite_rounded, value: '0', label: 'Favoris', color: Color(0xFFFFE0D5))),
          SizedBox(width: 12),
          Expanded(child: ProfileStat(icon: Icons.event_available_rounded, value: '0', label: 'Événements', color: Color(0xFFFFEDB8))),
        ]),
        const SizedBox(height: 25),
        const Text('Mes informations', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(color: Colors.white, elevation: 0, child: ListTile(leading: const CircleAvatar(backgroundColor: Color(0xFFE4EFDE), child: Icon(Icons.person_outline_rounded, color: green)), title: const Text('Nom et prénom'), subtitle: Text(memberName))),
        Card(color: Colors.white, elevation: 0, child: ListTile(leading: const CircleAvatar(backgroundColor: Color(0xFFE4EFDE), child: Icon(Icons.email_outlined, color: green)), title: const Text('Adresse e-mail'), subtitle: Text(memberEmail))),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: () => setState(() {
            isLoggedIn = false;
            showLogin = false;
            _passwordController.clear();
            _confirmController.clear();
          }),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Se déconnecter'),
        ),
      ],
    );
  }
}

class ProfileStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const ProfileStat({super.key, required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 5),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)),
        child: Column(children: [
          Icon(icon, color: green, size: 25),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)),
        ]),
      );
}

// -------------------- ETAT VIDE REUTILISABLE --------------------
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  const EmptyState({super.key, required this.icon, required this.title, required this.message, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(23)),
        child: Column(children: [
          CircleAvatar(radius: 35, backgroundColor: color.withOpacity(0.18), child: Icon(icon, size: 36, color: green)),
          const SizedBox(height: 15),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(height: 1.5, color: Colors.black54)),
        ]),
      );
}

