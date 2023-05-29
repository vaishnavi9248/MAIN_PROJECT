enum DaysEnum {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

extension DaysEnumExtension on DaysEnum {
  String get title {
    return switch (this) {
      DaysEnum.monday => "Monday",
      DaysEnum.tuesday => "Tuesday",
      DaysEnum.wednesday => "Wednesday",
      DaysEnum.thursday => "Thursday",
      DaysEnum.friday => "Friday",
      DaysEnum.saturday => "Saturday",
      DaysEnum.sunday => "Sunday",
    };
  }

  String get titleShort {
    return switch (this) {
      DaysEnum.monday => "Mon",
      DaysEnum.tuesday => "Tue",
      DaysEnum.wednesday => "Wed",
      DaysEnum.thursday => "Thu",
      DaysEnum.friday => "Fri",
      DaysEnum.saturday => "Sat",
      DaysEnum.sunday => "Sun",
    };
  }

  String get titleSingleWord {
    return switch (this) {
      DaysEnum.monday => "M",
      DaysEnum.tuesday => "T",
      DaysEnum.wednesday => "W",
      DaysEnum.thursday => "T",
      DaysEnum.friday => "F",
      DaysEnum.saturday => "S",
      DaysEnum.sunday => "S",
    };
  }

  int get order {
    return switch (this) {
      DaysEnum.monday => 1,
      DaysEnum.tuesday => 2,
      DaysEnum.wednesday => 3,
      DaysEnum.thursday => 4,
      DaysEnum.friday => 5,
      DaysEnum.saturday => 6,
      DaysEnum.sunday => 7,
    };
  }
}
