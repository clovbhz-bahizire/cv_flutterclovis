import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const ClovisCvApp());

const navy = Color(0xFF14213D);
const blue = Color(0xFF2563EB);
const pale = Color(0xFFF3F6FC);

class ClovisCvApp extends StatelessWidget {
  const ClovisCvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV - Clovis Bahizire',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: pale,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;
  String? error;

  void login() {
    // Identifiants de demonstration : clovis / 1234
    if (userController.text.trim().toLowerCase() == 'clovis' &&
        passwordController.text == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } else {
      setState(() => error = 'Identifiant ou mot de passe incorrect.');
    }
  }

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundColor: navy,
                    child: Icon(Icons.person, color: Colors.white, size: 54),
                  ),
                  const SizedBox(height: 22),
                  const Text('Bienvenue',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: navy)),
                  const SizedBox(height: 8),
                  const Text('Connectez-vous pour découvrir mon profil',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 32),
                  TextField(
                    controller: userController,
                    decoration: const InputDecoration(
                      labelText: 'Identifiant',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: obscure,
                    onSubmitted: (_) => login(),
                    decoration: InputDecoration(
                      labelText: 'Mot de passe',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => obscure = !obscure),
                        icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 22),
                  FilledButton(
                    onPressed: login,
                    style: FilledButton.styleFrom(
                      backgroundColor: navy,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Se connecter'),
                  ),
                  const SizedBox(height: 14),
                  const Text('Compte de démonstration : clovis / 1234',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;
  final pages = const [HomePage(), FamilyPage(), ContactPage()];
  final titles = const ['Mon CV', 'Ma famille', 'Contact'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(titles[index])),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                color: navy,
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 34, child: Icon(Icons.person, size: 38)),
                    SizedBox(height: 12),
                    Text('Clovis Rudahindwa Bahizire',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('Informaticien', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              _drawerItem(Icons.home_outlined, 'Mon CV', 0),
              _drawerItem(Icons.family_restroom, 'Ma famille', 1),
              _drawerItem(Icons.contact_phone_outlined, 'Contact', 2),
              const Spacer(),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Déconnexion'),
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) => setState(() => index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'CV'),
          NavigationDestination(icon: Icon(Icons.family_restroom), label: 'Famille'),
          NavigationDestination(icon: Icon(Icons.call_outlined), label: 'Contact'),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, int pageIndex) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: index == pageIndex,
      onTap: () {
        setState(() => index = pageIndex);
        Navigator.pop(context);
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 52,
                  backgroundColor: Color(0xFFE0EAFE),
                  child: Icon(Icons.person, size: 62, color: navy),
                ),
                const SizedBox(height: 14),
                const Text('Rudahindwa Bahizire Clovis',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: navy)),
                const SizedBox(height: 6),
                const Text('Informaticien',
                    style: TextStyle(color: blue, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                const Text('Passionné par les technologies de l’information et le numérique.',
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
        const SectionTitle('Formation'),
        const InfoCard(
          icon: Icons.school_outlined,
          title: 'Formation en informatique',
          detail: 'Établissement, niveau et année de formation à compléter.',
        ),
        const SectionTitle('Expériences professionnelles'),
        const InfoCard(
          icon: Icons.work_outline,
          title: 'Stage chez OliverSoft',
          detail: 'Stage professionnel — période et tâches réalisées à préciser.',
        ),
        const SectionTitle('Compétences techniques'),
        const InfoCard(
          icon: Icons.computer,
          title: 'Informatique',
          detail: 'À compléter : développement, réseaux, maintenance, logiciels et outils maîtrisés.',
        ),
        const SectionTitle('Langues'),
        const InfoCard(
          icon: Icons.language,
          title: 'Compétences linguistiques',
          detail: 'À compléter : français, anglais et autres langues avec leur niveau.',
        ),
        const SectionTitle('Centres d’intérêt'),
        const InfoCard(
          icon: Icons.interests_outlined,
          title: 'Loisirs et intérêts',
          detail: 'À compléter selon tes activités et passions.',
        ),
      ],
    );
  }
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final members = [
      const FamilyMember(name: 'Bahizire', relation: 'Père', profession: 'Profession à préciser', icon: Icons.man),
      const FamilyMember(name: 'Odile', relation: 'Mère', profession: 'Profession à préciser', icon: Icons.woman),
    ];
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Ma famille',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: navy)),
        const SizedBox(height: 6),
        const Text('Les personnes importantes de ma famille.'),
        const SizedBox(height: 14),
        ...members.map((m) => Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFFE0EAFE),
              child: Icon(m.icon, color: navy, size: 30),
            ),
            title: Text(m.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${m.relation} • ${m.profession}'),
          ),
        )),
        const SizedBox(height: 12),
        const Text('Ajoute les photos des membres de ta famille et les autres membres dans cette page.',
            style: TextStyle(color: Colors.black54)),
      ],
    );
  }
}

class FamilyMember {
  final String name, relation, profession;
  final IconData icon;
  const FamilyMember({required this.name, required this.relation, required this.profession, required this.icon});
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> open(String value) async {
    final uri = Uri.parse(value);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        const Text('Restons en contact',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: navy)),
        const SizedBox(height: 8),
        const Text('Voici mes coordonnées.'),
        const SizedBox(height: 16),
        ContactTile(icon: Icons.phone, title: 'Téléphone', value: '0848642151',
            onTap: () => open('tel:0848642151')),
        const ContactTile(icon: Icons.email_outlined, title: 'E-mail', value: 'Adresse e-mail à compléter'),
        const ContactTile(icon: Icons.location_on_outlined, title: 'Adresse', value: 'Adresse à compléter'),
        const ContactTile(icon: Icons.link, title: 'LinkedIn', value: 'Lien LinkedIn à ajouter'),
        const ContactTile(icon: Icons.code, title: 'GitHub', value: 'Lien GitHub à ajouter'),
      ],
    );
  }
}

class ContactTile extends StatelessWidget {
  final IconData icon;
  final String title, value;
  final VoidCallback? onTap;
  const ContactTile({super.key, required this.icon, required this.title, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: onTap == null ? null : const Icon(Icons.open_in_new, size: 18),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 22, 4, 8),
    child: Text(title, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: navy)),
  );
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title, detail;
  const InfoCard({super.key, required this.icon, required this.title, required this.detail});
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      contentPadding: const EdgeInsets.all(14),
      leading: Icon(icon, color: blue, size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Padding(padding: const EdgeInsets.only(top: 5), child: Text(detail)),
    ),
  );
}
