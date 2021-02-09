import 'package:flutter/material.dart';
import 'package:enum_to_string/enum_to_string.dart';

enum Category { Sport, Food, Water, Sleep, Work, NoPhone }

extension WeatherExt on Category {
  Color get color {
    switch (this) {
      case Category.Food:
        return Colors.redAccent[700];
        break;
      case Category.Water:
        return Colors.cyanAccent[700];
        break;
      case Category.Sport:
        return Colors.orangeAccent[700];
        break;
      case Category.NoPhone:
        return Colors.grey[700];
        break;
      case Category.Sleep:
        return Colors.purple;
        break;
      case Category.Work:
        return Colors.teal;
        break;
      default:
        return Colors.redAccent[700];
        break;
    }
  }

  IconData get icon {
    switch (this) {
      case Category.Food:
        return Icons.fastfood;
        break;
      case Category.Water:
        return Icons.local_drink;
        break;
      case Category.Sport:
        return Icons.fitness_center;
        break;
      case Category.NoPhone:
        return Icons.mobile_off;
        break;
      case Category.Sleep:
        return Icons.bedtime;
        break;
      case Category.Work:
        return Icons.work;
        break;
      default:
        return Icons.star;
        break;
    }
  }
}

class Habit {
  Habit({this.id, this.text, this.categoryString});
  final String text;
  final int id;
  final String categoryString;

  Category get category {
    Category test = EnumToString.fromString(Category.values, categoryString);
    return test;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'category': categoryString,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> json) => new Habit(
        id: json["id"],
        text: json["text"],
        categoryString: json["category"],
      );
}

class HabitView extends StatelessWidget {
  HabitView({this.text, this.category});
  final String text;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 8.0),
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 30.0),
              padding: const EdgeInsets.only(left: 30, right: 5),
              width: 400,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(text,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.only(
                  //   topRight: Radius.circular(10),
                  //   bottomRight: Radius.circular(10),
                  // ),
                  shape: BoxShape.rectangle,
                  color: category.color),
            ),
            Container(
              width: 60,
              height: 60,
              child: Icon(category.icon, size: 25, color: Colors.white),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: category.color),
            ),
          ],
        ));
  }
}
