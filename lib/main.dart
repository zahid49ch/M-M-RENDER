import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const AuthApp());
}

class AuthApp extends StatelessWidget {
  const AuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'M & M RENDER',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: const Color(0xFF731112),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
          labelLarge: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF98353F),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
            borderRadius: BorderRadius.circular(4),
          ),
          hintStyle: const TextStyle(color: Colors.white70),
          labelStyle: const TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFFB3B3B),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin = true;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _toggleView() {
    setState(() {
      showLogin = !showLogin;
      _errorMessage = null;
      _nameController.clear();
      _confirmPasswordController.clear();
    });
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (_emailController.text == 'admin@gmail.com' &&
        _passwordController.text == 'admin1122') {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          _errorMessage = 'Invalid email or password';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSignup() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      _toggleView();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF731112), Color(0xFF550101)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF550101),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFB3B3B)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF550000),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_circle,
                        size: 60, color: Colors.amber),
                    const SizedBox(height: 10),
                    const Text(
                      'M & M Render',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _errorMessage != null
                        ? Text(_errorMessage!,
                            style: const TextStyle(color: Colors.red))
                        : const SizedBox.shrink(),
                    const SizedBox(height: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: showLogin ? _buildLoginForm() : _buildSignupForm(),
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

  Widget _buildLoginForm() {
    return Column(
      key: const ValueKey('login'),
      children: [
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock, color: Colors.white),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.red.shade300,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                    ),
                  ),
          ),
        ),
        TextButton(
          onPressed: _toggleView,
          child: const Text("Don't have an account? Sign Up",
              style: TextStyle(color: Colors.amber)),
        )
      ],
    );
  }

  Widget _buildSignupForm() {
    return Column(
      key: const ValueKey('signup'),
      children: [
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            prefixIcon: Icon(Icons.person, color: Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email, color: Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock, color: Colors.white),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.white,
              ),
              onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSignup,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.red.shade300,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                    ),
                  ),
          ),
        ),
        TextButton(
          onPressed: _toggleView,
          child: const Text("Already have an account? Login",
              style: TextStyle(color: Colors.amber)),
        )
      ],
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const QuotePage(),
    const PricingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'M & M RENDER',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF550101),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthPage()),
              );
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF550101),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Quotes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Pricing',
          ),
        ],
      ),
    );
  }
}

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  int quoins = 5;
  int bulkheads = 5;
  int plynth = 5;
  int columns = 5;
  int windowBands = 5;

  void _changeValue(String id, int delta) {
    setState(() {
      switch (id) {
        case 'quoins':
          quoins = (quoins + delta).clamp(0, 100);
          break;
        case 'bulkheads':
          bulkheads = (bulkheads + delta).clamp(0, 100);
          break;
        case 'plynth':
          plynth = (plynth + delta).clamp(0, 100);
          break;
        case 'columns':
          columns = (columns + delta).clamp(0, 100);
          break;
        case 'windowBands':
          windowBands = (windowBands + delta).clamp(0, 100);
          break;
      }
    });
  }

  Widget _buildCounterRow(String label, String id, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label,
                style: const TextStyle(fontSize: 16, color: Colors.white)),
          ),
          Expanded(
            flex: 8,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.white),
                  onPressed: () => _changeValue(id, -1),
                ),
                Container(
                  width: 50,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFFB3B3B)),
                  ),
                  child: Text(
                    '$value',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () => _changeValue(id, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF550101),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFB3B3B)),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF550000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField(String placeholder, {bool halfWidth = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: placeholder,
          filled: true,
          fillColor: const Color(0xFF98353F),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
            borderRadius: BorderRadius.circular(4),
          ),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Center(
            child: Text(
              'Welcome, user!',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF550101),
                    side: const BorderSide(color: Color(0xFFFB3B3B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'New Quote',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF550101),
                    side: const BorderSide(color: Color(0xFFFB3B3B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PricingPage()),
                    );
                  },
                  child: const Text(
                    'Update Prices',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection('Customer Details', [
            Row(
              children: [
                Expanded(
                  child: _buildInputField('Enter Your Name'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInputField('Enter Project'),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildInputField('Enter Your Email'),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInputField('Enter Your Number'),
                ),
              ],
            ),
          ]),
          _buildSection('Quote Items', [
            _buildInputField('Render SQM'),
            _buildInputField('Hebel SQM'),
            _buildInputField('Acrylic SQM'),
            _buildInputField('Foam SQM'),
          ]),
          _buildSection('Extra Special Feature', [
            _buildCounterRow('Quoins:', 'quoins', quoins),
            _buildCounterRow('Bulkheads:', 'bulkheads', bulkheads),
            _buildCounterRow('Plynth:', 'plynth', plynth),
            _buildCounterRow('Columns:', 'columns', columns),
            _buildCounterRow('Window Bands:', 'windowBands', windowBands),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Add More Categories',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ]),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF550101),
              side: const BorderSide(color: Color(0xFFFB3B3B)),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {},
            child: const Text(
              'Material Breakdown',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF550101),
              side: const BorderSide(color: Color(0xFFFB3B3B)),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {},
            child: const Text(
              'Export to Email',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PricingPage extends StatefulWidget {
  const PricingPage({super.key});

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  double pricePerSqm = 65.0;
  double brickPrice = 15.0;
  double foamPrice = 1.5;
  double hebalPrice = 2.0;
  double cementSandPrice = 15.93;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'M & M RENDER',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),

          // Back Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.white, size: 25),
                    SizedBox(width: 4),
                    Text(
                      'Back',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Title
              const Text(
                'RENDER & Substrate Prices',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const Divider(color: Colors.white, height: 24),

          // Price Inputs
          _buildPriceRow(
            label: 'Price/m² or \$/m²',
            value: pricePerSqm,
            onChanged: (value) {
              setState(() {
                pricePerSqm = double.tryParse(value) ?? pricePerSqm;
              });
            },
          ),

          _buildPriceRow(
            label: 'Brick (Acrylic) - 1bag/3m²',
            value: brickPrice,
            onChanged: (value) {
              setState(() {
                brickPrice = double.tryParse(value) ?? brickPrice;
              });
            },
          ),

          _buildPriceRow(
            label: 'Foam - 1bag/6m² = Price/m²',
            value: foamPrice,
            onChanged: (value) {
              setState(() {
                foamPrice = double.tryParse(value) ?? foamPrice;
              });
            },
          ),

          _buildPriceRow(
            label: 'Hebal - 1bag/6m² = Price/m²',
            value: hebalPrice,
            onChanged: (value) {
              setState(() {
                hebalPrice = double.tryParse(value) ?? hebalPrice;
              });
            },
          ),

          // Cement/Sand Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(
                      'Cement 10 bags + 1 ton sand = 35m²',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: TextEditingController(
                          text: cementSandPrice.toString()),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF550101),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              const BorderSide(color: Color(0xFFFB3B3B)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: (value) {
                        setState(() {
                          cementSandPrice =
                              double.tryParse(value) ?? cementSandPrice;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Sand Ton = SQM / 35, Cement = Sand ton / 10',
                style: TextStyle(
                  fontSize: 13,
                  height: 1,
                ),
              ),
              const Divider(color: Colors.white, height: 24),
            ],
          ),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ExtraSectionPrices()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF550101),
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 35),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.0,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('NEXT : Extra Section'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_ios, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required String label,
    required double value,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: TextField(
              controller: TextEditingController(text: value.toString()),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF550101),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class ExtraSectionPrices extends StatelessWidget {
  const ExtraSectionPrices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'M & M RENDER',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF550101),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'M & M RENDER',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 25,
                        height: 35,
                        color: const Color(0xFFFB3B3B),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Back',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Extra Section Prices',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white, height: 20),
              _buildInputRow('Quoins : Per piece', '600'),
              const SizedBox(height: 16),
              _buildInputRow('Bands/Plinths - Per LM', '85'),
              const SizedBox(height: 16),
              _buildInputRow('Bulk Head - Per LM', '75'),
              const SizedBox(height: 16),
              _buildInputRow('Pillars - Per Item', '500'),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Fence Panel Min or LM for Top',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildLabeledInput('LM for Top', '35'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildLabeledInput('Min', '500'),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const PreparationBulkheadPrices()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF550101),
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFFB3B3B)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'NEXT : Preparation & Bulkhead',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            controller: TextEditingController(text: value),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF550101),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledInput(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF550101),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ],
    );
  }
}

class PreparationBulkheadPrices extends StatefulWidget {
  const PreparationBulkheadPrices({super.key});

  @override
  State<PreparationBulkheadPrices> createState() =>
      _PreparationBulkheadPricesState();
}

class _PreparationBulkheadPricesState extends State<PreparationBulkheadPrices> {
  // Controllers for text fields
  final TextEditingController _coverTrapeController =
      TextEditingController(text: '3');
  final TextEditingController _plasticController =
      TextEditingController(text: '70');
  final TextEditingController _windowController =
      TextEditingController(text: '15');
  final TextEditingController _pillarsController =
      TextEditingController(text: '500');
  final TextEditingController _expansionJointsController =
      TextEditingController(text: '15');
  final TextEditingController _cornerBeadController =
      TextEditingController(text: '5');
  final TextEditingController _sprayGlueController =
      TextEditingController(text: '30');

  @override
  void dispose() {
    _coverTrapeController.dispose();
    _plasticController.dispose();
    _windowController.dispose();
    _pillarsController.dispose();
    _expansionJointsController.dispose();
    _cornerBeadController.dispose();
    _sprayGlueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'M & M RENDER',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF550101),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heading
                const Text(
                  'M & M RENDER',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),

                // Back Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button with icon
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back, color: Colors.white, size: 25),
                          SizedBox(width: 4),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Title
                    const Text(
                      'Preparation & Bulkhead Prices',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                const Divider(color: Colors.white, height: 20),

                // Input Sections
                _buildInputRow(
                  'Cover Trape, caulking, window Protection & Plastic: Per m²',
                  _coverTrapeController,
                  isSuperscript: true,
                ),
                const SizedBox(height: 16),
                _buildInputRow('Plastic - Per Roll (50LM)', _plasticController),
                const SizedBox(height: 16),
                _buildInputRow('Window - Per Item', _windowController),
                const SizedBox(height: 16),
                _buildInputRow('Pillars - Per Item', _pillarsController),
                const SizedBox(height: 16),
                _buildInputRow(
                    'Expansion Joints - Per Item', _expansionJointsController),

                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Bulk head-Corner Bead per 3m',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Corner Bead and Spray Glue inputs
                Row(
                  children: [
                    Expanded(
                      child: _buildLabeledInput(
                          'Each per 3m', _cornerBeadController),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildLabeledInput(
                        'Spray Glue per Can(covers 30LM)',
                        _sprayGlueController,
                        isLongLabel: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Next Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to next screen
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => LabourCalculationScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF550101),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFFB3B3B)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'NEXT: Labour Calculation & Rules',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(String label, TextEditingController controller,
      {bool isSuperscript = false}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: isSuperscript
              ? RichText(
                  text: TextSpan(
                    text: label.replaceAll('m²', 'm'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    children: const [
                      TextSpan(
                        text: '2',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
        ),
        Expanded(
          flex: 1,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: const Color(0xFF550101),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledInput(String label, TextEditingController controller,
      {bool isLongLabel = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLongLabel ? 14 : 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: const Color(0xFF550101),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFFFB3B3B)),
            ),
          ),
        ),
      ],
    );
  }
}
