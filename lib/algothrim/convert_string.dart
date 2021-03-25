String convertString(String str) {
    var withDia =
        'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữìíịỉĩđỳýỵỷỹ';
    var withoutDia =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeooooooooooooooooouuuuuuuuuuuiiiiidyyyyy';

    str = str.toLowerCase();
    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }
    return str;
  }