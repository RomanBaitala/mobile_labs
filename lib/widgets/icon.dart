import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget{

  const CustomIcon({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(width: 0),
      ),
      child: Stack(
        children: [
          Positioned(top:0, left:45,
            child: Container(
              width: 55,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(width: 15, color: Colors.blue),
              ),
            )
          ),
          Positioned(top:45, left:0,
            child: Container(
              width: 100,
              height: 55,
              decoration: BoxDecoration(
                border: Border.all(width: 15, color: Colors.deepOrange),    
              ),
            )
          ),
          Positioned(top:60, left:85,
            child: Container(
              width: 15,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(width: 15, color: Colors.blue),    
              ),
            )
          ),
          Positioned(top:0, left:45,
            child: Container(
              width: 15,
              height: 60,
              decoration: BoxDecoration(
                border: Border.all(width: 15, color: Colors.blue),    
              ),
            )
          ),
        ],
      )
    );
  }
}
