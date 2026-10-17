
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

// -------------------- COULEURS --------------------

const Color green = Color(0xFF386641);
const Color cream = Color(0xFFFFFBF4);
const Color coral = Color(0xFFFF8066);
const Color purple = Color(0xFF8C78D8);
const Color yellow = Color(0xFFFFD166);
const Color blue = Color(0xFF75C9D5);

// -------------------- APPLICATION --------------------

class BookShareApp extends StatelessWidget {
  const BookShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
}

// -------------------- LIVRES --------------------

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
    coverUrl:
        'https://covers.openlibrary.org/b/isbn/9782070612758-L.jpg?default=false',
  ),
  Book(
    title: 'Les Misérables',
    author: 'Victor Hugo',
    category: 'Classiques',
    color: Color(0xFFD5E8D4),
    icon: Icons.account_balance_rounded,
    coverUrl:
        'https://covers.openlibrary.org/b/isbn/9782253096344-L.jpg?default=false',
  ),
  Book(
    title: 'L’Étranger',
    author: 'Albert Camus',
    category: 'Romans',
    color: Color(0xFFE9D5E8),
    icon: Icons.nightlight_round,
    coverUrl:
        'https://covers.openlibrary.org/b/isbn/9782070360024-L.jpg?default=false',
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

// -------------------- NAVIGATION --------------------

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  Widget buildApp(bool isVolunteer) {
    final titles = <String>[
      'Catalogue',
      'Mes emprunts',
      'Événements',
      'Messages',
      'Mon profil',
      if (isVolunteer) 'Espace bénévole',
    ];

    final icons = <IconData>[
      Icons.auto_stories_rounded,
      Icons.bookmark_rounded,
      Icons.event_rounded,
      Icons.chat_bubble_rounded,
      Icons.person_rounded,
      if (isVolunteer) Icons.volunteer_activism_rounded,
    ];

    final pages = <Widget>[
      const CataloguePage(),
      const LoansPage(),
      const EventsPage(),
      const MessagesPage(),
      const ProfilePage(),
      if (isVolunteer) const VolunteerPage(),
    ];

    final index = selectedIndex < pages.length ? selectedIndex : 0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.auto_stories_rounded, size: 28),
            const SizedBox(width: 9),
            Text(
              titles[index],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tu es à jour ! Aucune notification.'),
                ),
              );
            },
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
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.menu_book_rounded,
                        size: 34,
                        color: green,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'BookShare',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Lire, partager, découvrir.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  'MENU PRINCIPAL',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              for (int i = 0; i < titles.length; i++)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  child: ListTile(
                    selected: index == i,
                    selectedTileColor: const Color(0xFFE2EEDC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    leading: Icon(
                      icons[i],
                      color: index == i ? green : Colors.black54,
                    ),
                    title: Text(
                      titles[i],
                      style: TextStyle(
                        fontWeight:
                            index == i ? FontWeight.bold : FontWeight.normal,
                        color: index == i ? green : Colors.black87,
                      ),
                    ),
                    trailing: index == i
                        ? const Icon(Icons.chevron_right, color: green)
                        : null,
                    onTap: () {
                      setState(() => selectedIndex = i);
                      Navigator.pop(context);
                    },
                  ),
                ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE7D8),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.favorite_rounded, color: coral),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Chaque livre ouvre un nouveau monde.',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: index,
        children: pages,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        final user = authSnapshot.data;

        if (user == null) {
          return buildApp(false);
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (context, profileSnapshot) {
            final role = profileSnapshot.data?.data()?['role'];
            final isVolunteer = role == 'benevole';

            return buildApp(isVolunteer);
          },
        );
      },
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

  final List<String> categories = const [
    'Tous',
    'Romans',
    'Classiques',
    'Science',
    'Jeunesse',
  ];

  @override
  Widget build(BuildContext context) {
    final query = search.toLowerCase().trim();

    final filtered = books.where((book) {
      final matchesSearch = book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);
      final matchesCategory =
          category == 'Tous' || book.category == category;

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
            borderRadius: BorderRadius.all(Radius.circular(25)),
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(17),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Explorer les catégories',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
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
                  label: Text(item),
                  selected: selected,
                  selectedColor: green,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  onSelected: (_) => setState(() => category = item),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Livres à découvrir',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            Text(
              '${filtered.length} livres',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 15),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: Text('Aucun livre trouvé.')),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return BookCard(book: filtered[index]);
            },
          ),
      ],
    );
  }
}

// -------------------- CARTE D'UN LIVRE --------------------

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  Widget fallbackCover() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            book.color,
            Color.lerp(book.color, Colors.black, 0.22)!,
          ],
        ),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(book.icon, color: green, size: 22),
            const Spacer(),
            Text(
              book.title,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: green,
                fontWeight: FontWeight.bold,
                fontSize: 9,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              book.author,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: green, fontSize: 7),
            ),
          ],
        ),
      ),
    );
  }

  Widget coverImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Image.network(
        book.coverUrl,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => fallbackCover(),
      ),
    );
  }

  Future<void> reserveBook(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connecte-toi dans Mon profil pour réserver un livre.'),
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('reservations').add({
        'userId': user.uid,
        'bookTitle': book.title,
        'author': book.author,
        'category': book.category,
        'status': 'en_attente',
        'requestedAt': FieldValue.serverTimestamp(),
      });

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ta demande de réservation a été enregistrée !'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showDialog<void>(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                backgroundColor: cream,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                title: Text(
                  book.title,
                  style: const TextStyle(
                    color: green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 115, height: 170, child: coverImage()),
                    const SizedBox(height: 16),
                    Text('Auteur : ${book.author}'),
                    const SizedBox(height: 8),
                    Text('Catégorie : ${book.category}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text(
                      'Fermer',
                      style: TextStyle(color: green),
                    ),
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: green),
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      await reserveBook(context);
                    },
                    child: const Text('Réserver'),
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE8EDE5)),
          ),
          child: Row(
            children: [
              SizedBox(width: 76, height: 104, child: coverImage()),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1E6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        book.category,
                        style: const TextStyle(
                          color: green,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF26352A),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      book.author,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Voir les détails',
                      style: TextStyle(
                        color: green,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: green),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- MES EMPRUNTS --------------------

class LoansPage extends StatelessWidget {
  const LoansPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
              message: 'Lorsque tu réserveras un livre, il apparaîtra ici.',
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
              final title = data['bookTitle']?.toString() ?? 'Livre inconnu';
              final author = data['author']?.toString() ?? 'Auteur inconnu';
              final status = data['status']?.toString() ?? 'en_attente';

              final statusLabel = status == 'acceptee'
                  ? 'Acceptée'
                  : status == 'refusee'
                      ? 'Refusée'
                      : 'En attente';

              final statusColor = status == 'acceptee'
                  ? green
                  : status == 'refusee'
                      ? Colors.red
                      : Colors.orange;

              final statusIcon = status == 'acceptee'
                  ? Icons.check_circle_rounded
                  : status == 'refusee'
                      ? Icons.cancel_rounded
                      : Icons.hourglass_top_rounded;

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
                              Icon(statusIcon, size: 16, color: statusColor),
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

// -------------------- ESPACE BENEVOLE --------------------

class VolunteerPage extends StatelessWidget {
  const VolunteerPage({super.key});

  Future<void> updateStatus(
    BuildContext context,
    String reservationId,
    String status,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('reservations')
          .doc(reservationId)
          .update({'status': status});

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'acceptee'
                ? 'Réservation acceptée !'
                : 'Réservation refusée.',
          ),
        ),
      );
    } on FirebaseException catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.code == 'permission-denied'
                ? 'Action refusée par les règles Firestore.'
                : 'Erreur : ${e.message ?? e.code}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('reservations')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Impossible de charger les réservations. '
                'Vérifie les règles Firestore et le rôle bénévole.',
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

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Espace bénévole 🤝',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${reservations.length} réservation(s) au total',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            if (reservations.isEmpty)
              const EmptyState(
                icon: Icons.menu_book_rounded,
                title: 'Aucune réservation',
                message: 'Les nouvelles demandes apparaîtront ici.',
                color: purple,
              ),
            ...reservations.map((reservation) {
              final data = reservation.data();
              final title =
                  data['bookTitle']?.toString() ?? 'Livre inconnu';
              final author =
                  data['author']?.toString() ?? 'Auteur inconnu';
              final userId = data['userId']?.toString() ?? '';
              final status =
                  data['status']?.toString() ?? 'en_attente';

              final isPending = status == 'en_attente';

              final statusLabel = status == 'acceptee'
                  ? 'Acceptée'
                  : status == 'refusee'
                      ? 'Refusée'
                      : 'En attente';

              final statusColor = status == 'acceptee'
                  ? green
                  : status == 'refusee'
                      ? Colors.red
                      : Colors.orange;

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: green,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text('Auteur : $author'),
                      const SizedBox(height: 5),
                      Text(
                        'Membre : ${userId.length > 8 ? userId.substring(0, 8) : userId}',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.circle, size: 10, color: statusColor),
                          const SizedBox(width: 7),
                          Text(
                            statusLabel,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (isPending) ...[
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                style: FilledButton.styleFrom(
                                  backgroundColor: green,
                                ),
                                onPressed: () => updateStatus(
                                  context,
                                  reservation.id,
                                  'acceptee',
                                ),
                                icon: const Icon(Icons.check),
                                label: const Text('Accepter'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                onPressed: () => updateStatus(
                                  context,
                                  reservation.id,
                                  'refusee',
                                ),
                                icon: const Icon(Icons.close),
                                label: const Text('Refuser'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
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
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Connecte-toi depuis Mon profil pour consulter les événements '
            'et participer aux ateliers.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, profileSnapshot) {
        final isVolunteer =
            profileSnapshot.data?.data()?['role'] == 'benevole';

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('events')
              .orderBy('date')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Erreur de chargement : ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final events = snapshot.data?.docs ?? [];

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'La vie de la bibliothèque 🎉',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Rencontres, ateliers et découvertes.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 18),

                if (isVolunteer)
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: green,
                      padding: const EdgeInsets.all(15),
                    ),
                    onPressed: () => _createEvent(context, user.uid),
                    icon: const Icon(Icons.add),
                    label: const Text('Publier un événement'),
                  ),

                if (isVolunteer) const SizedBox(height: 18),

                if (events.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.event_available_rounded,
                          size: 55,
                          color: green,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Aucun événement pour le moment',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Les prochains ateliers apparaîtront ici.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                for (final event in events)
                  EventCard(
                    eventId: event.id,
                    data: event.data(),
                    userId: user.uid,
                    isVolunteer: isVolunteer,
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _createEvent(
    BuildContext context,
    String userId,
  ) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const CreateEventDialog(),
    );

    if (result == null) return;

    try {
      await FirebaseFirestore.instance.collection('events').add({
        'title': result['title'],
        'description': result['description'],
        'location': result['location'],
        'date': Timestamp.fromDate(result['date'] as DateTime),
        'capacity': result['capacity'],
        'registeredCount': 0,
        'createdBy': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Événement publié avec succès !')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Publication impossible : $e')),
        );
      }
    }
  }
}

class EventCard extends StatelessWidget {
  final String eventId;
  final Map<String, dynamic> data;
  final String userId;
  final bool isVolunteer;

  const EventCard({
    super.key,
    required this.eventId,
    required this.data,
    required this.userId,
    required this.isVolunteer,
  });

  String formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');

    return '$d/$m/${date.year} à $h:$min';
  }

  Future<void> _register(BuildContext context) async {
    final db = FirebaseFirestore.instance;
    final eventRef = db.collection('events').doc(eventId);
    final registrationRef = db
        .collection('eventRegistrations')
        .doc('${eventId}_$userId');

    try {
      await db.runTransaction((transaction) async {
        final eventSnapshot = await transaction.get(eventRef);
        final registrationSnapshot =
            await transaction.get(registrationRef);

        if (!eventSnapshot.exists) {
          throw Exception('Cet événement n’existe plus.');
        }

        if (registrationSnapshot.exists) {
          throw Exception('Tu es déjà inscrit à cet événement.');
        }

        final eventData = eventSnapshot.data()!;
        final capacity = (eventData['capacity'] as num).toInt();
        final registeredCount =
            ((eventData['registeredCount'] ?? 0) as num).toInt();

        if (registeredCount >= capacity) {
          throw Exception('Désolé, toutes les places sont réservées.');
        }

        transaction.set(registrationRef, {
          'eventId': eventId,
          'userId': userId,
          'createdAt': FieldValue.serverTimestamp(),
        });

        transaction.update(eventRef, {
          'registeredCount': registeredCount + 1,
        });
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscription confirmée !')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        final message = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  Future<void> _deleteEvent(BuildContext context) async {
    if (((data['registeredCount'] ?? 0) as num).toInt() > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Impossible de supprimer un événement ayant des inscrits.',
          ),
        ),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Supprimer cet événement ?'),
        content: const Text('Cette action est définitive.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Événement supprimé.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Suppression impossible : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = data['title'] as String? ?? 'Événement';
    final description = data['description'] as String? ?? '';
    final location = data['location'] as String? ?? 'Lieu à préciser';
    final dateValue = data['date'];
    final date = dateValue is Timestamp
        ? dateValue.toDate()
        : DateTime.now();

    final capacity = ((data['capacity'] ?? 0) as num).toInt();
    final count = ((data['registeredCount'] ?? 0) as num).toInt();
    final isFull = count >= capacity;

    return Container(
      margin: const EdgeInsets.only(bottom: 18, top: 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black..withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFDCE8FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.event_rounded,
              size: 48,
              color: green,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            formatDate(date),
            style: const TextStyle(
              color: green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Text(description),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 19),
              const SizedBox(width: 5),
              Expanded(child: Text(location)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$count / $capacity places réservées',
            style: const TextStyle(
              color: green,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('eventRegistrations')
                .doc('${eventId}_$userId')
                .snapshots(),
            builder: (context, registrationSnapshot) {
              final alreadyRegistered =
                  registrationSnapshot.data?.exists == true;

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (alreadyRegistered)
                    const Chip(
                      avatar: Icon(Icons.check_circle, color: green),
                      label: Text('Déjà inscrit'),
                    )
                  else
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: green,
                      ),
                      onPressed: isFull
                          ? null
                          : () => _register(context),
                      child: Text(isFull ? 'Complet' : 'S’inscrire'),
                    ),
                  if (isVolunteer && count == 0)
                    OutlinedButton.icon(
                      onPressed: () => _deleteEvent(context),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Supprimer'),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class CreateEventDialog extends StatefulWidget {
  const CreateEventDialog({super.key});

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final capacityController = TextEditingController(text: '10');

  DateTime selectedDate = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    capacityController.dispose();
    super.dispose();
  }

  Future<void> chooseDate() async {
  final date = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 730)),
  );

  if (!mounted || date == null) return;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(selectedDate),
  );

  if (!mounted || time == null) return;

  setState(() {
    selectedDate = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  });
}

  @override
  Widget build(BuildContext context) {
    final dateText =
        '${selectedDate.day.toString().padLeft(2, '0')}/'
        '${selectedDate.month.toString().padLeft(2, '0')}/'
        '${selectedDate.year} '
        '${selectedDate.hour.toString().padLeft(2, '0')}:'
        '${selectedDate.minute.toString().padLeft(2, '0')}';

    return AlertDialog(
      title: const Text('Nouvel événement'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Saisis un titre.'
                        : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Saisis une description.'
                        : null,
              ),
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Lieu'),
                validator: (value) =>
                    value == null || value.trim().isEmpty
                        ? 'Saisis un lieu.'
                        : null,
              ),
              TextFormField(
                controller: capacityController,
                decoration:
                    const InputDecoration(labelText: 'Nombre de places'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final capacity = int.tryParse(value ?? '');
                  if (capacity == null || capacity < 1) {
                    return 'Saisis un nombre supérieur à zéro.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: chooseDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(dateText),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: green),
          onPressed: () {
            if (!formKey.currentState!.validate()) return;

            if (!selectedDate.isAfter(DateTime.now())) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Choisis une date dans le futur.'),
                ),
              );
              return;
            }

            Navigator.pop(context, {
              'title': titleController.text.trim(),
              'description': descriptionController.text.trim(),
              'location': locationController.text.trim(),
              'capacity': int.parse(capacityController.text),
              'date': selectedDate,
            });
          },
          child: const Text('Publier'),
        ),
      ],
    );
  }
}


// -------------------- MESSAGES --------------------

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = [
      {
        'name': 'Bibliothèque',
        'message': 'Bienvenue sur BookShare !',
        'time': '09:30',
      },
      {
        'name': 'Équipe des bénévoles',
        'message': 'Les prochains événements arrivent.',
        'time': 'Hier',
      },
    ];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Tes conversations 💬',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Reste en contact avec ta bibliothèque.',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 22),
        for (int i = 0; i < conversations.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: CircleAvatar(
                radius: 27,
                backgroundColor:
                    i == 0 ? const Color(0xFFDCE8FF) : const Color(0xFFFFE0D5),
                child: Icon(
                  i == 0
                      ? Icons.local_library_rounded
                      : Icons.groups_rounded,
                  color: green,
                ),
              ),
              title: Text(
                conversations[i]['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(conversations[i]['message']!),
              ),
              trailing: Text(
                conversations[i]['time']!,
                style: const TextStyle(fontSize: 11, color: Colors.black45),
              ),
              onTap: () {
                showDialog<void>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(conversations[i]['name']!),
                    content: const Text(
                      'La messagerie complète sera disponible après '
                      'connexion au backend.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Fermer'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 10),
        const EmptyState(
          icon: Icons.forum_rounded,
          title: 'Une messagerie à découvrir',
          message:
              'Tu pourras échanger avec les bénévoles et les autres membres '
              'lorsque la messagerie sera connectée.',
          color: coral,
        ),
      ],
    );
  }
}

// -------------------- PROFIL ET AUTHENTIFICATION --------------------

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

  bool showLogin = false;
  bool hidePassword = true;
  bool isLoading = false;

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

    try {
      if (showLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        final name = _nameController.text.trim();

        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = credential.user!;

        await user.updateDisplayName(name);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            showLogin ? 'Connexion réussie !' : 'Compte créé avec succès !',
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur Firestore : ${e.message ?? e.code}. '
            'Vérifie les règles de sécurité.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Une erreur est survenue : $e')),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (user == null) {
          return _buildAuthForm();
        }

        return _buildProfile(user);
      },
    );
  }

  Widget _buildAuthForm() {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Column(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person_rounded,
                  color: green,
                  size: 45,
                ),
              ),
              SizedBox(height: 13),
              Text(
                'Bienvenue sur BookShare',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'Connecte-toi pour retrouver ton espace lecteur.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Text(
          showLogin ? 'Connexion' : 'Créer un compte',
          style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 18),
        Form(
          key: _formKey,
          child: Column(
            children: [
              if (!showLogin) ...[
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Nom et prénom',
                    prefixIcon: Icon(Icons.person_outline),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (!showLogin &&
                        (value == null || value.trim().isEmpty)) {
                      return 'Entre ton nom et prénom.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
              ],
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Adresse e-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null ||
                      !RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                          .hasMatch(value.trim())) {
                    return 'Entre une adresse e-mail valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: const Icon(Icons.lock_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => hidePassword = !hidePassword);
                    },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Utilise au moins 6 caractères.';
                  }
                  return null;
                },
              ),
              if (!showLogin) ...[
                const SizedBox(height: 14),
                TextFormField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirmer le mot de passe',
                    prefixIcon: Icon(Icons.lock_reset_rounded),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (!showLogin && value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas.';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: green),
                  onPressed: isLoading ? null : submitForm,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          showLogin ? 'Se connecter' : 'Créer mon compte',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                showLogin = !showLogin;
                _formKey.currentState?.reset();
                _nameController.clear();
                _emailController.clear();
                _passwordController.clear();
                _confirmController.clear();
              });
            },
            child: Text(
              showLogin
                  ? 'Pas encore de compte ? Inscris-toi'
                  : 'Tu as déjà un compte ? Connecte-toi',
              textAlign: TextAlign.center,
              style: const TextStyle(color: green),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfile(User user) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final name = data?['name']?.toString() ??
            user.displayName ??
            user.email?.split('@').first ??
            'Membre';
        final email = user.email ?? '';
        final isVolunteer = data?['role'] == 'benevole';

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 43,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person_rounded,
                      size: 52,
                      color: green,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isVolunteer
                        ? 'Bénévole BookShare'
                        : 'Membre de la bibliothèque',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Row(
              children: [
                Expanded(
                  child: ProfileStat(
                    icon: Icons.menu_book_rounded,
                    value: '—',
                    label: 'Emprunts',
                    color: Color(0xFFDCE8FF),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ProfileStat(
                    icon: Icons.favorite_rounded,
                    value: '0',
                    label: 'Favoris',
                    color: Color(0xFFFFE0D5),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ProfileStat(
                    icon: Icons.event_available_rounded,
                    value: '0',
                    label: 'Événements',
                    color: Color(0xFFFFEDB8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Mes informations',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.white,
              elevation: 0,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE4EFDE),
                  child: Icon(Icons.person_outline_rounded, color: green),
                ),
                title: const Text('Nom et prénom'),
                subtitle: Text(name),
              ),
            ),
            Card(
              color: Colors.white,
              elevation: 0,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE4EFDE),
                  child: Icon(Icons.email_outlined, color: green),
                ),
                title: const Text('Adresse e-mail'),
                subtitle: Text(email),
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();

                  if (!mounted) return;

                  setState(() {
                    showLogin = false;
                    _passwordController.clear();
                    _confirmController.clear();
                  });
                } on FirebaseAuthException catch (e) {
                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Déconnexion impossible : ${e.message ?? e.code}',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Se déconnecter'),
            ),
          ],
        );
      },
    );
  }
}

// -------------------- STATISTIQUES DU PROFIL --------------------

class ProfileStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const ProfileStat({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: green, size: 25),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// -------------------- ETAT VIDE REUTILISABLE --------------------

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: color.withOpacity(0.18),
            child: Icon(icon, size: 36, color: green),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              height: 1.5,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
