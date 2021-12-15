bool isFalse(dynamic value) => value == false;

bool isTrue(dynamic value) => value == true;

bool isNull(dynamic value) => value == null;

bool isNotNull(dynamic value) => isFalse(isNull(value));

bool isNotBlank(String? value) => isNotNull(value) && value!.trim().isNotEmpty;
