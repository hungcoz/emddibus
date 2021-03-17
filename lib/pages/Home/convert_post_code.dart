String convertPostCode (int postCode){
  String city;
  if (postCode >= 10000 && postCode <= 14000)
    city = "Hà Nội";
  else if (postCode >= 70000 && postCode <= 74000)
    city = "TP.Hồ Chí Minh";
  else if (postCode == 90000)
    city = "An Giang";
  else if (postCode == 26000)
    city = "Bắc Giang";
  else if (postCode == 23000)
    city = "Bắc Kạn";
  else if (postCode == 97000)
    city = "Bạc Liêu";
  else if (postCode == 16000)
    city = "Bắc Ninh";
  else if (postCode == 78000  )
    city = "Bà Rịa – Vũng Tàu";
  else if (postCode >= 70000 && postCode <= 74000)
    city = "TP.Hồ Chí Minh";
  else if (postCode == 86000)
    city = "Bến Tre";
  else if (postCode == 55000)
    city = "Bình Định";
  else if (postCode == 75000)
    city = "Bình Dương";
  else if (postCode == 67000)
    city = "Bình Phước";
  else if (postCode == 77000)
    city = "Bình Thuận";
  else if (postCode == 94000)
    city = "Cần Thơ";
  else if (postCode == 21000)
    city = "Cao Bằng";
  else if (postCode == 50000)
    city = "Đà Nẵng";
  else if (postCode >= 63000  && postCode <= 64000)
    city = "Đắk Lắk";
  else if (postCode == 65000)
    city = "Đắk Nông";
  else if (postCode == 76000)
    city = "Đồng Nai";
  else if (postCode == 81000)
    city = "Đồng Tháp";
  else if (postCode >= 61000  && postCode <= 62000)
    city = "Gia Lai";
  else if (postCode == 20000)
    city = "Hà Giang";
  else if (postCode == 18000)
    city = "Hà Nam";
  else if (postCode >= 45000 && postCode <= 46000)
    city = "Hà Tĩnh";
  else if (postCode == 03000)
    city = "Hải Dương";
  else if (postCode >= 04000 && postCode <= 05000)
    city = "Hải Phòng";
  else if (postCode == 95000)
    city = "Hậu Giang";
  else if (postCode == 36000)
    city = "Hòa Bình";
  else if (postCode == 17000)
    city = "Hưng Yên";
  else if (postCode == 57000)
    city = "Khánh Hòa";
  else if (postCode >= 91000 && postCode <= 92000)
    city = "Kiên Giang";
  else if (postCode == 60000)
    city = "Kon Tum";
  else if (postCode == 30000)
    city = "Lai Châu";
  else if (postCode == 66000)
    city = "Lâm Đồng";
  else if (postCode == 25000)
    city = "Lạng Sơn";
  else if (postCode == 31000)
    city = "Lào Cai";
  else if (postCode >= 82000 && postCode <= 83000)
    city = "Long An";
  else if (postCode == 07000)
    city = "Nam Định";
  else if (postCode >= 43000 && postCode <= 44000)
    city = "Nghệ An";
  else if (postCode == 08000)
    city = "Ninh Bình";
  else if (postCode == 59000)
    city = "Ninh Thuận";
  else if (postCode == 35000)
    city = "Phú Thọ";
  else if (postCode == 56000)
    city = "Phú Yên";
  else if (postCode == 47000)
    city = "Quảng Bình";
  else if (postCode >= 51000 && postCode <= 52000)
    city = "Quảng Nam";
  else if (postCode >= 53000 && postCode <= 54000)
    city = "Quảng Ngãi";
  else if (postCode >= 01000 && postCode <= 02000)
    city = "Quảng Ninh";
  else if (postCode == 48000)
    city = "Quảng Trị";
  else if (postCode == 96000)
    city = "Sóc Trăng";
  else if (postCode == 34000)
    city = "Sơn La";
  else if (postCode == 80000)
    city = "Tây Ninh";
  else if (postCode == 06000)
    city = "Thái Bình";
  else if (postCode == 24000)
    city = "Thái Nguyên";
  else if (postCode >= 40000 && postCode <= 42000)
    city = "Thanh Hóa";
  else if (postCode == 49000)
    city = "Thừa Thiên Huế";
  else if (postCode == 84000)
    city = "Tiền Giang";
  else if (postCode == 87000)
    city = "Trà Vinh";
  else if (postCode == 22000)
    city = "Tuyên Quang";
  else if (postCode == 85000)
    city = "Vĩnh Long";
  else if (postCode == 15000)
    city = "Vĩnh Phúc";
  else if (postCode == 33000)
    city = "Yên Bái";
  else city = "";
  return city;
}