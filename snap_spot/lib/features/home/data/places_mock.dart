final List<Map<String, dynamic>> mockPlacesData = [
  {
    "id": "1",
    "name": "Chợ Bến Thành",
    "description": "Biểu tượng văn hóa và thương mại của TP.HCM.",
    "imageUrl": "https://mia.vn/media/uploads/blog-du-lich/cho-ben-thanh-1742355724.jpg",
    "address": "Đường Lê Lợi, Quận 1, TP.HCM",
    "latitude": 10.7721,
    "longitude": 106.6979,
    "district": {
      "id": "d1",
      "name": "Quận 1",
      "province": {"id": "p1", "name": "Thành phố Hồ Chí Minh"}
    },
    "agencies": [
      {
        "id": "a1",
        "name": "Tour Bến Thành",
        "fullName": "Công ty Du lịch Bến Thành",
        "description": "Chuyên tổ chức tour tham quan khu vực trung tâm TP.HCM.",
        "phoneNumber": "0901234567",
        "avatarUrl": "https://i.pravatar.cc/150?u=a1_logo",
        "companyId": "c1",
        "spotId": "1",
        "rating": 4.5,
        "isApproved": true,
        "services": [
          {"id": "s1", "name": "Hướng dẫn viên", "color": "FF5733"},
          {"id": "s2", "name": "Xe đưa đón", "color": "33C1FF"},
          {"id": "s3", "name": "Ăn uống", "color": "28A745"}
        ],
        "individualRatings": [
          {
            "userId": "u1",
            "userName": "Nguyễn Văn A",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user1",
            "stars": 5.0,
            "comment": "Công ty Tour Bến Thành rất chuyên nghiệp, HDV nhiệt tình!",
            "date": "2023-10-28T10:00:00Z"
          }
        ]
      },
      {
        "id": "a2",
        "name": "Sài Gòn Travel",
        "fullName": "Công ty TNHH Du lịch Sài Gòn",
        "description": "Chuyên các tour trải nghiệm ẩm thực và mua sắm.",
        "phoneNumber": "0909876543",
        "avatarUrl": "https://i.pravatar.cc/150?u=a2_logo",
        "companyId": "c2",
        "spotId": "1",
        "rating": 4.8,
        "isApproved": true,
        "services": [
          {"id": "s4", "name": "Tour ẩm thực", "color": "FFC107"},
          {"id": "s5", "name": "Mua sắm", "color": "6F42C1"}
        ],
        "individualRatings": [
          {
            "userId": "u3",
            "userName": "Lê Văn C",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user3",
            "stars": 4.5,
            "comment": "Tour ẩm thực rất ngon, đáng thử.",
            "date": "2023-11-01T15:00:00Z"
          }
        ]
      }
    ]
  },
  {
    "id": "2",
    "name": "Vịnh Hạ Long",
    "description": "Di sản thiên nhiên thế giới với hàng nghìn đảo đá vôi kỳ thú.",
    "imageUrl": "https://cdn.tgddsites.com/Files/2021/09/08/1378827/vinh-ha-long-o-dau-kinh-nghiem-du-lich-vinh-ha-long-tu-a-z-202109081736453937.jpg",
    "address": "Thành phố Hạ Long, Quảng Ninh",
    "latitude": 20.9101,
    "longitude": 107.1839,
    "district": {
      "id": "d2",
      "name": "Thành phố Hạ Long",
      "province": {"id": "p2", "name": "Quảng Ninh"}
    },
    "agencies": [
      {
        "id": "a3",
        "name": "Halong Bay Tours",
        "fullName": "Công ty Cổ phần Du lịch Vịnh Hạ Long",
        "description": "Chuyên tổ chức du thuyền cao cấp khám phá Vịnh Hạ Long.",
        "phoneNumber": "0923456789",
        "avatarUrl": "https://i.pravatar.cc/150?u=a3_logo",
        "companyId": "c3",
        "spotId": "2",
        "rating": 4.7,
        "isApproved": true,
        "services": [
          {"id": "s10", "name": "Du thuyền", "color": "007BFF"},
          {"id": "s11", "name": "Kayak", "color": "17A2B8"},
          {"id": "s12", "name": "Nghỉ đêm trên tàu", "color": "6610F2"}
        ],
        "individualRatings": [
          {
            "userId": "u6",
            "userName": "Trần Thị B",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user6",
            "stars": 5.0,
            "comment": "Trải nghiệm tuyệt vời trên du thuyền, cảnh đẹp mê hồn!",
            "date": "2024-01-20T14:30:00Z"
          },
          {
            "userId": "u7",
            "userName": "Phan Văn F",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user7",
            "stars": 4.0,
            "comment": "Dịch vụ tốt, tuy nhiên giá hơi cao.",
            "date": "2024-02-05T09:15:00Z"
          }
        ]
      }
    ]
  },
  {
    "id": "3",
    "name": "Đại Nội Huế",
    "description": "Quần thể di tích cổ kính, là kinh đô của triều Nguyễn.",
    "imageUrl": "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2018/08/dai-noi-hue.jpg",
    "address": "Phú Hậu, Thành phố Huế, Thừa Thiên Huế",
    "latitude": 16.4637,
    "longitude": 107.5909,
    "district": {
      "id": "d3",
      "name": "Thành phố Huế",
      "province": {"id": "p3", "name": "Thừa Thiên Huế"}
    },
    "agencies": [
      {
        "id": "a4",
        "name": "Hue Heritage Tour",
        "fullName": "Công ty Di sản Huế",
        "description": "Tổ chức các tour khám phá di tích lịch sử tại Huế.",
        "phoneNumber": "0987654321",
        "avatarUrl": "https://i.pravatar.cc/150?u=a4_logo",
        "companyId": "c4",
        "spotId": "3",
        "rating": 4.9,
        "isApproved": true,
        "services": [
          {"id": "s6", "name": "Tham quan di tích", "color": "8E44AD"},
          {"id": "s7", "name": "Hướng dẫn viên", "color": "2980B9"}
        ],
        "individualRatings": [
          {
            "userId": "u4",
            "userName": "Phạm Hồng D",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user4",
            "stars": 5.0,
            "comment": "Rất thích phong cách thuyết minh tại các điểm di tích.",
            "date": "2024-01-15T13:20:00Z"
          }
        ]
      }
    ]
  },
  {
    "id": "4",
    "name": "Bà Nà Hills",
    "description": "Khu du lịch nổi tiếng với Cầu Vàng và cảnh quan núi non hùng vĩ.",
    "imageUrl": "https://cdn1.ivivu.com/iVivu/2022/03/08/16/n/ba-na-hills.jpg",
    "address": "Hòa Ninh, Hòa Vang, Đà Nẵng",
    "latitude": 15.9995,
    "longitude": 107.9881,
    "district": {
      "id": "d4",
      "name": "Hòa Vang",
      "province": {"id": "p4", "name": "Đà Nẵng"}
    },
    "agencies": [
      {
        "id": "a5",
        "name": "Danang Explorer",
        "fullName": "CTCP Du lịch Khám phá Đà Nẵng",
        "description": "Chuyên tour trọn gói Bà Nà Hills, trải nghiệm Cầu Vàng.",
        "phoneNumber": "0961122334",
        "avatarUrl": "https://i.pravatar.cc/150?u=a5_logo",
        "companyId": "c5",
        "spotId": "4",
        "rating": 4.6,
        "isApproved": true,
        "services": [
          {"id": "s8", "name": "Cáp treo", "color": "E91E63"},
          {"id": "s9", "name": "Tham quan", "color": "3F51B5"}
        ],
        "individualRatings": [
          {
            "userId": "u5",
            "userName": "Hoàng Minh E",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user5",
            "stars": 4.5,
            "comment": "Cảnh đẹp tuyệt vời, dịch vụ ổn định.",
            "date": "2024-02-10T11:00:00Z"
          }
        ]
      }
    ]
  },
  {
    "id": "5",
    "name": "Phố Cổ Hội An",
    "description": "Thành phố cổ với kiến trúc độc đáo, là di sản văn hóa thế giới.",
    "imageUrl": "https://cdn.baogiaothong.vn/images/e-magazine/2023/01/28/baogiaothong/thumb_660_a74b15b2-3f9a-4aa8-96d2-0e38b4ce0d10.jpg",
    "address": "Phố cổ Hội An, Quảng Nam",
    "latitude": 15.8801,
    "longitude": 108.3380,
    "district": {
      "id": "d5",
      "name": "Thành phố Hội An",
      "province": {"id": "p5", "name": "Quảng Nam"}
    },
    "agencies": [
      {
        "id": "a6",
        "name": "Hoi An Ancient Tours",
        "fullName": "Công ty Du lịch Phố Cổ Hội An",
        "description": "Chuyên tour khám phá phố cổ và làng nghề truyền thống.",
        "phoneNumber": "0934567890",
        "avatarUrl": "https://i.pravatar.cc/150?u=a6_logo",
        "companyId": "c6",
        "spotId": "5",
        "rating": 4.8,
        "isApproved": true,
        "services": [
          {"id": "s13", "name": "Tour đi bộ", "color": "FD7E14"},
          {"id": "s14", "name": "Làm đèn lồng", "color": "D63384"},
          {"id": "s15", "name": "Tour ẩm thực", "color": "198754"}
        ],
        "individualRatings": [
          {
            "userId": "u8",
            "userName": "Võ Thị G",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user8",
            "stars": 5.0,
            "comment": "Phố cổ thật đẹp, hướng dẫn viên am hiểu lịch sử.",
            "date": "2024-01-25T16:45:00Z"
          },
          {
            "userId": "u9",
            "userName": "Đỗ Văn H",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user9",
            "stars": 4.5,
            "comment": "Trải nghiệm làm đèn lồng rất thú vị.",
            "date": "2024-02-15T12:30:00Z"
          }
        ]
      }
    ]
  },
  {
    "id": "6",
    "name": "Sa Pa",
    "description": "Thị trấn miền núi với ruộng bậc thang tuyệt đẹp và văn hóa dân tộc.",
    "imageUrl": "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/06/sa-pa-1.jpg",
    "address": "Thị trấn Sa Pa, Lào Cai",
    "latitude": 22.3364,
    "longitude": 103.8438,
    "district": {
      "id": "d6",
      "name": "Sa Pa",
      "province": {"id": "p6", "name": "Lào Cai"}
    },
    "agencies": [
      {
        "id": "a7",
        "name": "Sapa Mountain Tours",
        "fullName": "Công ty Du lịch Núi Sapa",
        "description": "Chuyên trekking và khám phá văn hóa dân tộc thiểu số.",
        "phoneNumber": "0945678901",
        "avatarUrl": "https://i.pravatar.cc/150?u=a7_logo",
        "companyId": "c7",
        "spotId": "6",
        "rating": 4.6,
        "isApproved": true,
        "services": [
          {"id": "s16", "name": "Trekking", "color": "795548"},
          {"id": "s17", "name": "Homestay", "color": "FF9800"},
          {"id": "s18", "name": "Tour văn hóa", "color": "9C27B0"}
        ],
        "individualRatings": [
          {
            "userId": "u10",
            "userName": "Bùi Văn I",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user10",
            "stars": 4.5,
            "comment": "Trekking qua ruộng bậc thang rất ấn tượng.",
            "date": "2024-01-30T08:20:00Z"
          }
        ]
      },
      {
        "id": "a8",
        "name": "Highland Discovery",
        "fullName": "Công ty Khám phá Cao nguyên",
        "description": "Tour cao nguyên và leo núi Fansipan chuyên nghiệp.",
        "phoneNumber": "0956789012",
        "avatarUrl": "https://i.pravatar.cc/150?u=a8_logo",
        "companyId": "c8",
        "spotId": "6",
        "rating": 4.4,
        "isApproved": true,
        "services": [
          {"id": "s19", "name": "Leo núi", "color": "607D8B"},
          {"id": "s20", "name": "Cáp treo Fansipan", "color": "FF5722"}
        ],
        "individualRatings": [
          {
            "userId": "u11",
            "userName": "Lý Thị J",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user11",
            "stars": 4.0,
            "comment": "Leo núi Fansipan thành công, mệt nhưng đáng.",
            "date": "2024-02-20T18:00:00Z"
          }
        ]
      }
    ]
  },
  {
    "id": "7",
    "name": "Đà Lạt",
    "description": "Thành phố ngàn hoa với khí hậu mát mẻ quanh năm.",
    "imageUrl": "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/07/dalat-2.jpg",
    "address": "Thành phố Đà Lạt, Lâm Đồng",
    "latitude": 11.9404,
    "longitude": 108.4583,
    "district": {
      "id": "d7",
      "name": "Thành phố Đà Lạt",
      "province": {"id": "p7", "name": "Lâm Đồng"}
    },
    "agencies": [
      {
        "id": "a9",
        "name": "Dalat Flower Tours",
        "fullName": "Công ty Du lịch Hoa Đà Lạt",
        "description": "Chuyên tour khám phá vườn hoa và trang trại Đà Lạt.",
        "phoneNumber": "0967890123",
        "avatarUrl": "https://i.pravatar.cc/150?u=a9_logo",
        "companyId": "c9",
        "spotId": "7",
        "rating": 4.7,
        "isApproved": true,
        "services": [
          {"id": "s21", "name": "Tour vườn hoa", "color": "E91E63"},
          {"id": "s22", "name": "Tham quan trang trại", "color": "4CAF50"},
          {"id": "s23", "name": "Xe jeep", "color": "795548"}
        ],
        "individualRatings": [
          {
            "userId": "u12",
            "userName": "Ngô Văn K",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user12",
            "stars": 5.0,
            "comment": "Vườn hoa tuyệt đẹp, không khí trong lành.",
            "date": "2024-02-25T10:15:00Z"
          }
        ]
      }
    ]
  },
  {
    "id": "8",
    "name": "Phú Quốc",
    "description": "Đảo ngọc với bãi biển đẹp và hải sản tươi ngon.",
    "imageUrl": "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/08/phu-quoc-1.jpg",
    "address": "Đảo Phú Quốc, Kiên Giang",
    "latitude": 10.2899,
    "longitude": 103.9840,
    "district": {
      "id": "d8",
      "name": "Thành phố Phú Quốc",
      "province": {"id": "p8", "name": "Kiên Giang"}
    },
    "agencies": [
      {
        "id": "a10",
        "name": "Pearl Island Tours",
        "fullName": "Công ty Du lịch Đảo Ngọc",
        "description": "Tổ chức tour biển đảo và lặn ngắm san hô.",
        "phoneNumber": "0978901234",
        "avatarUrl": "https://i.pravatar.cc/150?u=a10_logo",
        "companyId": "c10",
        "spotId": "8",
        "rating": 4.5,
        "isApproved": true,
        "services": [
          {"id": "s24", "name": "Tour 4 đảo", "color": "00BCD4"},
          {"id": "s25", "name": "Lặn ngắm san hô", "color": "2196F3"},
          {"id": "s26", "name": "Câu cá", "color": "FF9800"}
        ],
        "individualRatings": [
          {
            "userId": "u13",
            "userName": "Dương Thị L",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user13",
            "stars": 4.5,
            "comment": "Biển đẹp, san hô rất đa dạng.",
            "date": "2024-03-01T14:20:00Z"
          },
          {
            "userId": "u14",
            "userName": "Hà Văn M",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user14",
            "stars": 4.0,
            "comment": "Tour tốt nhưng thời tiết hơi xấu.",
            "date": "2024-03-05T11:30:00Z"
          }
        ]
      }
    ]
  },
  {
    "id": "9",
    "name": "Ninh Bình",
    "description": "Vịnh Hạ Long trên cạn với hang động và cảnh quan sông nước hùng vĩ.",
    "imageUrl": "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/07/ninh-binh-1.jpg",
    "address": "Thành phố Ninh Bình, Ninh Bình",
    "latitude": 20.2506,
    "longitude": 105.9745,
    "district": {
      "id": "d9",
      "name": "Thành phố Ninh Bình",
      "province": {"id": "p9", "name": "Ninh Bình"}
    },
    "agencies": [
      {
        "id": "a11",
        "name": "Trang An Eco Tours",
        "fullName": "Công ty Du lịch Sinh thái Tràng An",
        "description": "Chuyên tour thuyền kayak khám phá động Tràng An.",
        "phoneNumber": "0989012345",
        "avatarUrl": "https://i.pravatar.cc/150?u=a11_logo",
        "companyId": "c11",
        "spotId": "9",
        "rating": 4.8,
        "isApproved": true,
        "services": [
          {"id": "s27", "name": "Tour thuyền", "color": "009688"},
          {"id": "s28", "name": "Khám phá hang động", "color": "5D4037"},
          {"id": "s29", "name": "Leo núi", "color": "607D8B"}
        ],
        "individualRatings": [
          {
            "userId": "u15",
            "userName": "Đinh Văn N",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user15",
            "stars": 5.0,
            "comment": "Tràng An đẹp như tranh vẽ, tour thuyền rất thú vị.",
            "date": "2024-03-10T09:45:00Z"
          }
        ]
      }
    ]
  },
  {
    "id": "10",
    "name": "Mũi Né",
    "description": "Bãi biển với đồi cát đỏ, đồi cát trắng và các hoạt động thể thao biển.",
    "imageUrl": "https://cdn.vntrip.vn/cam-nang/wp-content/uploads/2017/08/mui-ne-1.jpg",
    "address": "Mũi Né, Phan Thiết, Bình Thuận",
    "latitude": 10.9333,
    "longitude": 108.2833,
    "district": {
      "id": "d10",
      "name": "Thành phố Phan Thiết",
      "province": {"id": "p10", "name": "Bình Thuận"}
    },
    "agencies": [
      {
        "id": "a12",
        "name": "Mui Ne Beach Tours",
        "fullName": "Công ty Du lịch Biển Mũi Né",
        "description": "Tour trọn gói khám phá đồi cát và thể thao biển.",
        "phoneNumber": "0990123456",
        "avatarUrl": "https://i.pravatar.cc/150?u=a12_logo",
        "companyId": "c12",
        "spotId": "10",
        "rating": 4.4,
        "isApproved": true,
        "services": [
          {"id": "s30", "name": "Tour đồi cát", "color": "FFEB3B"},
          {"id": "s31", "name": "Lướt ván", "color": "00BCD4"},
          {"id": "s32", "name": "Jeep tour", "color": "8BC34A"}
        ],
        "individualRatings": [
          {
            "userId": "u16",
            "userName": "Cao Thị O",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user16",
            "stars": 4.5,
            "comment": "Đồi cát đỏ rất đẹp, hoạt động jeep thú vị.",
            "date": "2024-03-15T15:10:00Z"
          },
          {
            "userId": "u17",
            "userName": "Lê Văn P",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user17",
            "stars": 4.0,
            "comment": "Biển đẹp, tuy nhiên hơi đông du khách.",
            "date": "2024-03-20T12:05:00Z"
          }
        ]
      },
      {
        "id": "a13",
        "name": "Red Sand Adventures",
        "fullName": "Công ty Phiêu lưu Cát Đỏ",
        "description": "Chuyên các hoạt động mạo hiểm và thể thao trên cát.",
        "phoneNumber": "0991234567",
        "avatarUrl": "https://i.pravatar.cc/150?u=a13_logo",
        "companyId": "c13",
        "spotId": "10",
        "rating": 4.2,
        "isApproved": true,
        "services": [
          {"id": "s33", "name": "Trượt cát", "color": "FF5722"},
          {"id": "s34", "name": "ATV", "color": "3F51B5"}
        ],
        "individualRatings": [
          {
            "userId": "u18",
            "userName": "Trương Văn Q",
            "userAvatarUrl": "https://i.pravatar.cc/40?u=user18",
            "stars": 4.0,
            "comment": "Trượt cát rất vui, nhân viên thân thiện.",
            "date": "2024-03-25T10:30:00Z"
          }
        ]
      }
    ]
  }
];