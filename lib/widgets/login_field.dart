import 'package:flutter/material.dart';
import 'package:login_flutter/pallete.dart';

class LoginField extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final Color? fillColor;
  final TextEditingController? controller; 
  final bool obscureText;
  final bool isPassword;

  const LoginField({
    super.key, 
    required this.hintText, 
    required this.icon,
    this.fillColor,
    this.controller,
    this.obscureText = false,
    this.isPassword = false,
  });

  @override
  State<LoginField> createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 350),
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        style: const TextStyle(color: Colors.white), 
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.fillColor ??  Color(0xFF130F26).withOpacity(0.6),
          prefixIcon: Icon(widget.icon, color: Color.fromARGB(255, 136, 85, 218)), 

          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; 
                    });
                  },
                )
              : null,

          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Pallete.borderColor.withOpacity(0.5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 215, 85, 247),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}