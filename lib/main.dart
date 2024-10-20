import 'package:flutter/material.dart';

void main() {
  runApp(TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TemperatureConverter(),
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  @override
  _TemperatureConverterState createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  String _fromUnit = 'Celsius';
  String _toUnit = 'Fahrenheit';
  final TextEditingController _controller = TextEditingController();
  String _result = '';
  Widget _icon = Text('C', style: TextStyle(fontSize: 50)); // Default icon
  bool _conversionDone = false;

  void _convertTemperature() {
    double inputValue = double.tryParse(_controller.text) ?? 0.0;
    double convertedValue;

    if (_fromUnit == 'Celsius' && _toUnit == 'Fahrenheit') {
      convertedValue = inputValue * 9 / 5 + 32;
    } else if (_fromUnit == 'Celsius' && _toUnit == 'Kelvin') {
      convertedValue = inputValue + 273.15;
    } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Celsius') {
      convertedValue = (inputValue - 32) * 5 / 9;
    } else if (_fromUnit == 'Fahrenheit' && _toUnit == 'Kelvin') {
      convertedValue = (inputValue - 32) * 5 / 9 + 273.15;
    } else if (_fromUnit == 'Kelvin' && _toUnit == 'Celsius') {
      convertedValue = inputValue - 273.15;
    } else if (_fromUnit == 'Kelvin' && _toUnit == 'Fahrenheit') {
      convertedValue = (inputValue - 273.15) * 9 / 5 + 32;
    } else {
      convertedValue = inputValue; // Same unit, no conversion needed
    }

    setState(() {
      _result = convertedValue.toStringAsFixed(2);
      _icon = Text('✓', style: TextStyle(fontSize: 50)); // Change to "Done Converting" icon
      _conversionDone = true;
    });
  }

  void _reset() {
    setState(() {
      _controller.clear();
      _result = '';
      _icon = Text('C', style: TextStyle(fontSize: 50)); // Reset icon to default
      _conversionDone = false;
    });
  }

  void _updateIcon() {
    if (_conversionDone) {
      _icon = Image.network(
        'https://st3.depositphotos.com/1688079/17316/i/450/depositphotos_173165516-stock-photo-done-validate-icon-special-green.jpg',
        width: 50,
        height: 50,
      ); // Set to "Done Converting" icon
      return;
    }

    // Update icon based on "To" unit
    switch (_toUnit) {
      case 'Celsius':
        _icon = Image.network(
          'https://th.bing.com/th/id/R.bf44ddd2978e7494a7470edc37d1b1aa?rik=8v3iziyOAajDpA&pid=ImgRaw&r=0',
          width: 50,
          height: 50,
        ); // Celsius icon
        break;
      case 'Fahrenheit':
        _icon = Image.network(
          'https://th.bing.com/th/id/OIP.ChDTXyNKwcNe_YvIzOuxxAHaHa?rs=1&pid=ImgDetMain',
          width: 50,
          height: 50,
        ); // Fahrenheit icon
        break;
      case 'Kelvin':
        _icon = Image.network(
          'https://th.bing.com/th/id/OIP.Oc-KPk-eDE4NRZJpvTpbWAHaHa?rs=1&pid=ImgDetMain',
          width: 50,
          height: 50,
        ); // Kelvin icon
        break;
      default:
        _icon = Image.network(
          'https://example.com/unknown.png',
          width: 50,
          height: 50,
        ); // Unknown icon
    }
  }



  @override
  Widget build(BuildContext context) {
    _updateIcon(); // Call to update the icon based on "To" unit

    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Converter'),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dropdown Menu for "From" unit
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _fromUnit,
                    items: <String>['Celsius', 'Fahrenheit', 'Kelvin']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text('From: $value'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _fromUnit = newValue!;
                      });
                    },
                  ),
                ),
                SizedBox(width: 20),
                // Dropdown Menu for "To" unit
                Expanded(
                  child: DropdownButton<String>(
                    value: _toUnit,
                    items: <String>['Celsius', 'Fahrenheit', 'Kelvin']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text('To: $value'),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _toUnit = newValue!;
                        _conversionDone = false;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Input field for temperature value
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Temperature',
              ),
            ),
            SizedBox(height: 20),
            // Convert button
            ElevatedButton(
              onPressed: _convertTemperature,
              child: Text('Convert'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent, // Updated to backgroundColor
                foregroundColor: Colors.black, // Set the text color to black
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
            // Output display with dynamic icon
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _icon, // Custom icon based on "To" unit
                  Text(
                    'Converted Value: $_result',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Reset button
            ElevatedButton(
              onPressed: _reset,
              child: Text('Reset'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent, // Updated to backgroundColor
                foregroundColor: Colors.black, // Set the text color to black
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
