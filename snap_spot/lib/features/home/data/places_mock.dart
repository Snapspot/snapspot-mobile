final List<Map<String, dynamic>> mockPlaces = [
  {
    "id": "1",
    "name": "Chợ Bến Thành",
    "description": "Biểu tượng của TP.HCM",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Quận 1, TP.HCM",
    "district": {
      "id": "d1",
      "name": "Quận 1",
      "province": {
        "id": "p1",
        "name": "Thành phố Hồ Chí Minh"
      }
    },
    "agencies": [
      {
        "id": "a1",
        "name": "Tour Bến Thành",
        "fullName": "Công ty du lịch Bến Thành",
        "rating": 4.5,
        "services": [
          {"id": "s1", "name": "Hướng dẫn viên", "color": "#FF5733"},
          {"id": "s2", "name": "Xe đưa đón", "color": "#33C1FF"}
        ]
      }
    ]
  },
  {
    "id": "2",
    "name": "Nhà Thờ Lớn Hà Nội",
    "description": "Công trình kiến trúc Pháp",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Hoàn Kiếm, Hà Nội",
    "district": {
      "id": "d2",
      "name": "Hoàn Kiếm",
      "province": {
        "id": "p2",
        "name": "Hà Nội"
      }
    },
    "agencies": []
  },
  {
    "id": "3",
    "name": "Cầu Rồng",
    "description": "Cây cầu biểu tượng của Đà Nẵng",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Hải Châu, Đà Nẵng",
    "district": {
      "id": "d3",
      "name": "Hải Châu",
      "province": {
        "id": "p3",
        "name": "Đà Nẵng"
      }
    },
    "agencies": []
  },
  {
    "id": "4",
    "name": "Hồ Xuân Hương",
    "description": "Hồ trung tâm thành phố Đà Lạt",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Phường 1, Lâm Đồng",
    "district": {
      "id": "d4",
      "name": "Phường 1",
      "province": {
        "id": "p4",
        "name": "Lâm Đồng"
      }
    },
    "agencies": []
  },
  {
    "id": "5",
    "name": "Phố cổ Hội An",
    "description": "Di sản văn hóa thế giới",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Hội An, Quảng Nam",
    "district": {
      "id": "d5",
      "name": "Hội An",
      "province": {
        "id": "p5",
        "name": "Quảng Nam"
      }
    },
    "agencies": []
  },
  {
    "id": "6",
    "name": "Tháp Bà Ponagar",
    "description": "Di tích văn hóa Chăm nổi tiếng",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Vĩnh Phước, Khánh Hòa",
    "district": {
      "id": "d6",
      "name": "Vĩnh Phước",
      "province": {
        "id": "p6",
        "name": "Khánh Hòa"
      }
    },
    "agencies": []
  },
  {
    "id": "7",
    "name": "Lăng Khải Định",
    "description": "Lăng tẩm vua Nguyễn",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Hương Thủy, Thừa Thiên Huế",
    "district": {
      "id": "d7",
      "name": "Hương Thủy",
      "province": {
        "id": "p7",
        "name": "Thừa Thiên Huế"
      }
    },
    "agencies": []
  },
  {
    "id": "8",
    "name": "Núi Bà Đen",
    "description": "Đỉnh núi cao nhất Nam Bộ",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Thành phố Tây Ninh, Tây Ninh",
    "district": {
      "id": "d8",
      "name": "Thành phố Tây Ninh",
      "province": {
        "id": "p8",
        "name": "Tây Ninh"
      }
    },
    "agencies": []
  },
  {
    "id": "9",
    "name": "Đảo Phú Quốc",
    "description": "Thiên đường biển đảo Việt Nam",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Phú Quốc, Kiên Giang",
    "district": {
      "id": "d9",
      "name": "Phú Quốc",
      "province": {
        "id": "p9",
        "name": "Kiên Giang"
      }
    },
    "agencies": []
  },
  {
    "id": "10",
    "name": "Thung lũng Mường Hoa",
    "description": "Vùng đất thơ mộng tại Sa Pa",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Sa Pa, Lào Cai",
    "district": {
      "id": "d10",
      "name": "Sa Pa",
      "province": {
        "id": "p10",
        "name": "Lào Cai"
      }
    },
    "agencies": []
  },
  {
    "id": "11",
    "name": "Biển Mỹ Khê",
    "description": "Bãi biển đẹp nổi tiếng thế giới",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Sơn Trà, Đà Nẵng",
    "district": {
      "id": "d11",
      "name": "Sơn Trà",
      "province": {
        "id": "p3",
        "name": "Đà Nẵng"
      }
    },
    "agencies": []
  },
  {
    "id": "12",
    "name": "Hồ Gươm",
    "description": "Trái tim của Thủ đô Hà Nội",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Hoàn Kiếm, Hà Nội",
    "district": {
      "id": "d2",
      "name": "Hoàn Kiếm",
      "province": {
        "id": "p2",
        "name": "Hà Nội"
      }
    },
    "agencies": []
  }
];
