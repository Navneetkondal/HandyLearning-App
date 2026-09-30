import 'package:flutter/material.dart';
import '../../../core/widgets/code_snippet_card.dart';
import '../../../core/widgets/interactive_demo_box.dart';
import '../../../core/widgets/section_header.dart';

/// Screen teaching all basic button and user input controls in Flutter.
class ButtonsInputsScreen extends StatefulWidget {
  const ButtonsInputsScreen({super.key});

  @override
  State<ButtonsInputsScreen> createState() => _ButtonsInputsScreenState();
}

class _ButtonsInputsScreenState extends State<ButtonsInputsScreen> {
  // Input State
  final TextEditingController _textController = TextEditingController(text: 'Hello Flutter!');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Selection states
  bool _checkboxVal = true;
  bool _switchVal = false;
  int _selectedRadio = 1;
  double _sliderVal = 50.0;
  String _dropdownVal = 'Beginner';

  String _lastActionMessage = 'Tap any button or change an input';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _recordAction(String msg) {
    setState(() {
      _lastActionMessage = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons & Inputs Lab'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Action Feedback Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.primary.withAlpha(50)),
            ),
            child: Row(
              children: [
                Icon(Icons.touch_app_rounded, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Event Triggered: $_lastActionMessage',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // SECTION 1: Buttons
          const SectionHeader(
            title: '1. Button Family',
            subtitle: 'Elevated, Outlined, Text, and Icon buttons for varying visual hierarchy.',
            icon: Icons.smart_button_rounded,
            badgeText: 'Hierarchy',
          ),
          InteractiveDemoBox(
            label: 'Buttons Interactive Preview',
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Elevated Button (Primary)
                ElevatedButton.icon(
                  onPressed: () => _recordAction('ElevatedButton pressed (Primary Action)'),
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('ElevatedButton'),
                ),

                // Outlined Button (Secondary)
                OutlinedButton.icon(
                  onPressed: () => _recordAction('OutlinedButton pressed (Secondary Action)'),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('OutlinedButton'),
                ),

                // Text Button (Tertiary/Subtle)
                TextButton.icon(
                  onPressed: () => _recordAction('TextButton pressed (Subtle/Inline Action)'),
                  icon: const Icon(Icons.info_outline_rounded, size: 18),
                  label: const Text('TextButton'),
                ),

                // Icon Button
                IconButton.filledTonal(
                  onPressed: () => _recordAction('IconButton tapped'),
                  icon: const Icon(Icons.favorite_rounded),
                  tooltip: 'Add to favorites',
                ),

                // Floating Action Button mini
                FloatingActionButton.small(
                  heroTag: 'demo_fab',
                  onPressed: () => _recordAction('FloatingActionButton tapped'),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const CodeSnippetCard(
            title: 'Button Syntax & Hierarchy',
            code: '''// Primary High-Emphasis Action:
ElevatedButton(
  onPressed: () => print('Primary clicked'),
  child: const Text('Submit'),
);

// Medium-Emphasis Outlined Action:
OutlinedButton(
  onPressed: () => print('Cancel clicked'),
  child: const Text('Cancel'),
);

// Low-Emphasis Text Action (Dialogs, Card Footers):
TextButton(
  onPressed: () => print('Learn more'),
  child: const Text('Learn More'),
);''',
            explanation:
                'Use ElevatedButton for the main CTA on a page, OutlinedButton for secondary actions, and TextButton for low-emphasis options.',
          ),

          // SECTION 2: Text Inputs
          const SectionHeader(
            title: '2. Text Input & Validation',
            subtitle: 'TextField for simple input; TextFormField inside Form for validation.',
            icon: Icons.edit_note_rounded,
            badgeText: 'Form',
          ),
          InteractiveDemoBox(
            label: 'Form Input Sandbox',
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'Your Name / Topic',
                      hintText: 'Enter text here...',
                      prefixIcon: const Icon(Icons.person_outline_rounded),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _textController.clear();
                          _recordAction('Input cleared');
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onChanged: (text) => _recordAction('Text typed: "$text"'),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _recordAction('Form Validated Successfully: ${_textController.text}');
                        }
                      },
                      child: const Text('Validate Input'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const CodeSnippetCard(
            title: 'TextFormField Validation Pattern',
            code: '''final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Valid!
          }
        },
        child: const Text('Submit'),
      ),
    ],
  ),
)''',
            explanation:
                'Wrap TextFormFields inside a Form widget with a GlobalKey<FormState> to trigger cross-field validation with currentState!.validate().',
          ),

          // SECTION 3: Selection Controls
          const SectionHeader(
            title: '3. Selection Controls',
            subtitle: 'Checkbox, Switch, Radio, Slider, and Dropdown.',
            icon: Icons.toggle_on_rounded,
            badgeText: 'Inputs',
          ),
          InteractiveDemoBox(
            label: 'Toggles & Pickers',
            child: Column(
              children: [
                // Switch
                SwitchListTile(
                  title: const Text('Switch (Boolean Toggle)'),
                  subtitle: Text('Notifications active: $_switchVal'),
                  value: _switchVal,
                  onChanged: (val) {
                    setState(() => _switchVal = val);
                    _recordAction('Switch changed: $val');
                  },
                ),
                const Divider(),

                // Checkbox
                CheckboxListTile(
                  title: const Text('Checkbox (Multi-select)'),
                  subtitle: Text('Terms accepted: $_checkboxVal'),
                  value: _checkboxVal,
                  onChanged: (val) {
                    setState(() => _checkboxVal = val ?? false);
                    _recordAction('Checkbox changed: $val');
                  },
                ),
                const Divider(),

                // Radio Group
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: RadioGroup<int>(
                    groupValue: _selectedRadio,
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedRadio = val);
                        _recordAction('Radio option $val selected');
                      }
                    },
                    child: const Row(
                      children: [
                        Text('Radio (Single Select): ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Radio<int>(value: 1),
                        Text('Option A'),
                        Radio<int>(value: 2),
                        Text('Option B'),
                      ],
                    ),
                  ),
                ),
                const Divider(),

                // Slider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Slider (Continuous Value: ${_sliderVal.round()}%)',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Slider(
                        value: _sliderVal,
                        min: 0,
                        max: 100,
                        divisions: 10,
                        label: '${_sliderVal.round()}%',
                        onChanged: (val) {
                          setState(() => _sliderVal = val);
                          _recordAction('Slider adjusted to ${val.round()}%');
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),

                // Dropdown
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButtonFormField<String>(
                    initialValue: _dropdownVal,
                    decoration: const InputDecoration(
                      labelText: 'Experience Level (Dropdown)',
                      prefixIcon: Icon(Icons.school_rounded),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
                      DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
                      DropdownMenuItem(value: 'Advanced', child: Text('Advanced')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _dropdownVal = val);
                        _recordAction('Dropdown picked: $val');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
