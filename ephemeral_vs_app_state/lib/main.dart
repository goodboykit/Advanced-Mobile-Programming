import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Ephemeral vs App State Demo',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      home: const HomeScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  
  String _message = 'Welcome! Start counting...';

  void _incrementCounter() {
    setState(() {
      _counter++;
      _updateMessage();
    });
  }

  // Method to decrement counter
  void _decrementCounter() {
    setState(() {
      if (_counter > 0) {
        _counter--;
        _updateMessage();
      }
    });
  }

  // Method to reset counter
  void _resetCounter() {
    setState(() {
      _counter = 0;
      _message = 'Counter reset!';
    });
  }

  // Update message based on counter value
  void _updateMessage() {
    if (_counter == 0) {
      _message = 'Counter is at zero';
    } else if (_counter < 5) {
      _message = 'Keep going!';
    } else if (_counter < 10) {
      _message = 'Nice progress!';
    } else if (_counter < 20) {
      _message = 'You\'re doing great!';
    } else {
      _message = 'Wow! That\'s a lot!';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the theme provider for the toggle switch
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management'),
        centerTitle: true,
        actions: [
          // Theme toggle switch (App State)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  size: 20,
                ),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  activeColor: Colors.tealAccent,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'State Types',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStateIndicator(
                            'Ephemeral State',
                            Icons.timer,
                            Colors.orange,
                            'Counter: $_counter',
                          ),
                          _buildStateIndicator(
                            'App State',
                            Icons.public,
                            Colors.green,
                            themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Counter Display (Ephemeral State)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Ephemeral State',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 3,
                          ),
                        ),
                        child: Text(
                          '$_counter',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _message,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCounterButton(
                            icon: Icons.remove,
                            onPressed: _decrementCounter,
                            tooltip: 'Decrement',
                            color: Colors.red,
                          ),
                          _buildCounterButton(
                            icon: Icons.refresh,
                            onPressed: _resetCounter,
                            tooltip: 'Reset',
                            color: Colors.grey,
                          ),
                          _buildCounterButton(
                            icon: Icons.add,
                            onPressed: _incrementCounter,
                            tooltip: 'Increment',
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Theme Settings (App State)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'App State ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading: Icon(
                          themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                          size: 32,
                        ),
                        title: Text(
                          'Theme Mode',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          themeProvider.isDarkMode ? 'Dark Theme Active' : 'Light Theme Active',
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => themeProvider.toggleTheme(),
                          child: Text(
                            themeProvider.isDarkMode ? 'Switch to Light' : 'Switch to Dark',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Navigation Demo
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SecondScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Go to Second Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build state indicators
  Widget _buildStateIndicator(String label, IconData icon, Color color, String value) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Helper widget to build counter buttons
  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    required Color color,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Tooltip(
          message: tooltip,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

/// Second screen to demonstrate that app state persists across screens
class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  // Local ephemeral state for this screen
  bool _showDetails = false;
  int _localCounter = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'The theme of light and dark persists across the screens',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current theme: ${themeProvider.isDarkMode ? "Dark" : "Light"}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Local ephemeral state for this screen
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Local Ephemeral State',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Local Counter: $_localCounter',
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (_localCounter > 0) _localCounter--;
                              });
                            },
                            icon: const Icon(Icons.remove_circle),
                            color: Colors.red,
                            iconSize: 32,
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _localCounter++;
                              });
                            },
                            icon: const Icon(Icons.add_circle),
                            color: Colors.green,
                            iconSize: 32,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Show Details'),
                        value: _showDetails,
                        onChanged: (value) {
                          setState(() {
                            _showDetails = value;
                          });
                        },
                      ),
                      if (_showDetails)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'This counter and toggle are local to this screen. '
                            'They will reset when you navigate away!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Theme toggle button
              ElevatedButton.icon(
                onPressed: () => themeProvider.toggleTheme(),
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                label: Text(
                  'Toggle Theme',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}