import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const LineLeakApp());
}

class LineLeakApp extends StatelessWidget {
  const LineLeakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LineLeak',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF120E1B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF3366),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color ink = Color(0xFF120E1B);
  static const Color paper = Color(0xFFF7F3E9);
  static const Color hot = Color(0xFFFF3366);
  static const Color acid = Color(0xFFD4FF3D);
  static const Color violet = Color(0xFF8A5CFF);

  final Map<String, List<String>> lines = {
    'Rishta / Shaadi': [
      'Swarg toh chala jaayega bandaa, par wahaan bhi bandi nahi milegi.',
      'Biwi se zubaan ladaane ka maza hi alag hai — jeetne ka toh sawaal hi nahi.',
      'Shaadi ek exam hai jisme syllabus shaadi ke baad pata chalta hai.',
      "Pehle 'I love you' bola tha, ab 'tune bola tha' sunna padta hai.",
      'Sasural mein sabse bada sach — damaad ka wallet sabse zyada active hota hai.',
      'Dahej mein sirf ek cheez maango — thodi si shaanti.',
      "Shaadi ke baad pata chala, 'adjust karo' ek full-time job hai.",
    ],
    'Parents / Ghar': [
      "Aaj tak papa ne 'puchi' nahi di, bas 'seedha ho ja' diya hai.",
      "Mummy ka ek hi dialogue — 'padhai chhod ke sab yaad hai.'",
      'Ghar mein Wi-Fi password se zyada secret papa ki salary hai.',
      'Bachpan mein maar padi, ab bas tone badal ke maar padti hai.',
      "Result kharab ho, ya dil — dono baar mummy ka pehla sawaal ek hi hota hai: 'khaana khaya?'",
      "Papa ke paas do hi settings hain — normal aur 'ab bas.'",
    ],
    'Dosti': [
      'Dost woh hota hai jo tumhari galti pe sabse zyada haste — sabse pehle.',
      'Group mein sabse zyada online, real life mein sabse zyada ghost.',
      'Udhaar do dost ko, rishta khatam karne ka sabse tez tareeka.',
      'Best friend ka matlab — jo tumhari secret sabko bata de, thoda maza le ke.',
      'Dosti ka test tab hota hai jab bill split karna ho.',
    ],
    'Adulting / Job': [
      'Salary aati hai, dikhti bhi nahi, bas account chhoo ke nikal jaati hai.',
      'Monday se pyaar sirf un logon ko hai jinki job hai hi nahi.',
      "Boss bolta hai 'passion se kaam karo', salary slip mein passion ka column nahi hota.",
      'Adulting ka matlab — bills yaad rehte hain, khushiyaan bhool jaati hain.',
      "Resume mein 'hardworking' likha, dil mein sirf weekend chal raha hai.",
    ],
    'Random Chaos': [
      'Zindagi ek WiFi hai — signal full dikhta hai, load kuch nahi hota.',
      'Kal ka plan aaj bana lo, kal phir kal pe daal denge.',
      'Motivation aata hai raat ko 2 baje, kaam karne ka time subah 9 baje hota hai.',
      "Diet start karne ka best din hamesha 'kal' hota hai.",
      'Apni life ek meme hai, bas caption abhi tak nahi mila.',
      'Sapne bade dekhe the, alarm hi snooze nahi hota.',
    ],
    'Spicy Extra': [
      'Pyaar mein sab jayaz hai, bas UPI history clear rakhna.',
      'Ek taraf ka pyaar aur ek taraf ka loan — dono ki EMI zindagi bhar chalti hai.',
      "Rishta tootne ka reason hamesha ek hi hota hai — 'seen' kiya, reply nahi kiya.",
      'Sabse bada breakup tab hota hai jab data pack khatam ho jaaye.',
    ],
  };

  late List<String> categories;
  String selectedCategory = 'Random';
  String currentLine = 'Button daba ke dekho, dimaag thoda ghoomega.';
  String currentCatLabel = 'RANDOM';
  final Random rng = Random();
  final Map<String, int> lastUsedIndex = {};
  bool isPro = false;

  @override
  void initState() {
    super.initState();
    categories = ['Random', ...lines.keys];
  }

  void generateLine() {
    String cat = selectedCategory;
    if (cat == 'Random') {
      final keys = lines.keys.toList();
      cat = keys[rng.nextInt(keys.length)];
    }
    final pool = lines[cat]!;
    int idx = rng.nextInt(pool.length);
    if (pool.length > 1 && lastUsedIndex[cat] == idx) {
      idx = (idx + 1) % pool.length;
    }
    lastUsedIndex[cat] = idx;

    setState(() {
      currentCatLabel = cat.toUpperCase();
      currentLine = pool[idx];
    });
  }

  void showUnlockDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: paper,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Payment yahan connect hoga',
            style: TextStyle(fontWeight: FontWeight.w800, color: ink),
          ),
          content: const Text(
            'Is demo mein Razorpay/UPI checkout wire nahi hai — live version mein ₹49 ka ek-time unlock yahin se hoga.',
            style: TextStyle(color: ink),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Band karo', style: TextStyle(color: ink)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: hot, foregroundColor: paper),
              onPressed: () {
                setState(() => isPro = true);
                Navigator.pop(context);
              },
              child: const Text('Demo mein unlock karo'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ink,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 30),
                    _buildHeroCard(),
                    const SizedBox(height: 34),
                    _buildGeneratorSection(),
                    const SizedBox(height: 34),
                    _buildAdStrip(),
                    const SizedBox(height: 42),
                    _buildPricingSection(),
                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        'LineLeak — sirf entertainment ke liye. Jo bhi trigger ho jaye, woh apni marzi se hua. 😄',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w800, color: paper),
            children: [
              TextSpan(text: 'LINE'),
              TextSpan(text: 'LEAK', style: TextStyle(color: acid)),
            ],
          ),
        ),
        if (isPro)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
                color: acid, borderRadius: BorderRadius.circular(999)),
            child: const Text('PRO ✓',
                style: TextStyle(
                    color: ink, fontWeight: FontWeight.w800, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [violet, hot],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 16))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Ek line, poora reel ka comment section bhar de.',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: paper,
                height: 1.2),
          ),
          SizedBox(height: 10),
          Text(
            'Random Hinglish brainrot lines — reels pe chipkao, screenshot bano, aur comments padho.',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratorSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 26),
      child: Column(
        children: [
          const Text(
            'Line generator',
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w800, color: paper),
          ),
          const SizedBox(height: 6),
          const Text(
            'Category chuno, button daba, apni reel pe chaspa do.',
            style: TextStyle(fontSize: 13.5, color: Colors.white54),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: categories.map((cat) {
              final bool active = cat == selectedCategory;
              return ChoiceChip(
                label: Text(cat),
                selected: active,
                onSelected: (_) {
                  setState(() => selectedCategory = cat);
                  generateLine();
                },
                selectedColor: paper,
                backgroundColor: Colors.transparent,
                side: const BorderSide(color: paper, width: 1.6),
                labelStyle: TextStyle(
                  color: active ? ink : paper,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 26),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 34),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1626),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                Text(
                  currentCatLabel,
                  style: const TextStyle(
                      color: acid,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                      letterSpacing: 0.5),
                ),
                const SizedBox(height: 16),
                SelectableText(
                  currentLine,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: paper,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.35),
                ),
                const SizedBox(height: 6),
                const Text(
                  '(Text ko select karke copy kar sakte ho)',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: generateLine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: acid,
                    foregroundColor: ink,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999)),
                  ),
                  child: const Text('🎲 Naya nikaalo',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdStrip() {
    if (isPro) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white24, width: 1.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('AD SLOT — free version yahin ek chhota ad dikhayega',
              style: TextStyle(color: Colors.white54, fontSize: 12)),
          Text('Skip in 5s',
              style: TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Column(
      children: [
        const Text(
          'Free rakho ya ₹49 mein VIP bano',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.w800, color: paper),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            _priceCard(
              title: 'Free',
              price: '₹0',
              features: const [
                'Saari 6 categories',
                'Unlimited random generate',
                'Beech mein chhote ads',
              ],
              highlighted: false,
              onTap: null,
              buttonLabel: null,
            ),
            _priceCard(
              title: 'Pro — ek baar ka',
              price: '₹49 lifetime',
              features: const [
                'Zero ads, seedha kaam',
                'Exclusive "spicy" pack',
                'Trending-topic packs, weekly update',
              ],
              highlighted: true,
              onTap: isPro ? null : showUnlockDialog,
              buttonLabel: isPro ? 'Already Pro ✓' : 'Pro unlock karo',
            ),
          ],
        ),
      ],
    );
  }

  Widget _priceCard({
    required String title,
    required String price,
    required List<String> features,
    required bool highlighted,
    required VoidCallback? onTap,
    required String? buttonLabel,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: highlighted
            ? const LinearGradient(
                colors: [hot, violet],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)
            : null,
        color: highlighted ? null : const Color(0xFF1B1626),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white24, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800, color: paper)),
          const SizedBox(height: 8),
          Text(price,
              style: const TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w800, color: paper)),
          const SizedBox(height: 16),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text('• $f',
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 18),
          if (buttonLabel != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: highlighted ? paper : Colors.transparent,
                  foregroundColor: highlighted ? ink : paper,
                  side: highlighted ? null : const BorderSide(color: paper),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999)),
                ),
                child: Text(buttonLabel,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
              ),
            )
          else
            const SizedBox(height: 44),
        ],
      ),
    );
  }
}
