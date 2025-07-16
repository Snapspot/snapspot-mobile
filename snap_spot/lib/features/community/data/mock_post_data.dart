const mockPostData = [
  // Dữ liệu gốc của bạn
  {
    "id": 1,
    "userName": "Nguyễn Bình An",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=3",
    "location": "Nhà Thờ Giáo Xứ Bình An",
    "timestamp": "2025-06-17T14:10:00Z",
    "content": "Cách đây khoảng 120 triệu năm...",
    "imageUrls": [
      "https://tgpsaigon.net/Images/Parish/P_Binhan_BA.jpg",
      "https://giothanhle.net/wp-content/uploads/2016/10/nha-tho-binh-an-quan-8-2.jpg",
      "https://images.unsplash.com/photo-1523413651479-597eb2da0ad6"
    ],
    "likes": 1300,
    "commentList": [
      {
        "userName": "Trịnh Trần Phương Tuấn",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=21",
        "content": "Cảnh đẹp cỡ này mà người chụp đâu rồi!",
        "timestamp": "2025-06-17T15:00:00Z",
        "likes": 2
      },
      {
        "userName": "Đặng Tiến Hoàng",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=22",
        "content": "Đẹp vậy cho mình xin nhé, về có ý tưởng làm nhạc nè!",
        "timestamp": "2025-06-17T15:05:00Z",
        "likes": 1
      }
    ]
  },
  // 10 dữ liệu mới được tạo
  {
    "id": 2,
    "userName": "Lê Thị Mỹ Duyên",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=4",
    "location": "Hồ Hoàn Kiếm, Hà Nội",
    "timestamp": "2025-06-16T08:30:00Z",
    "content": "Một buổi sáng trong lành tại trái tim của Thủ đô. 💙",
    "imageUrls": [
      "https://images.unsplash.com/photo-1596205219446-51c93e2a8423?q=80&w=1974&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1558291241-e3741752834d?q=80&w=2070&auto=format&fit=crop"
    ],
    "likes": 892,
    "commentList": [
      {
        "userName": "Phạm Minh Tuấn",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=25",
        "content": "Nhớ Hà Nội quá bạn ơi!",
        "timestamp": "2025-06-16T09:15:00Z",
        "likes": 5
      }
    ]
  },
  {
    "id": 3,
    "userName": "Võ Thành Ý",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=5",
    "location": "Bánh Mì Huỳnh Hoa, Sài Gòn",
    "timestamp": "2025-06-15T12:00:00Z",
    "content": "Bữa trưa 'nhẹ nhàng' với ổ bánh mì siêu topping. No tới chiều! 🥖",
    "imageUrls": [
      "https://images.unsplash.com/photo-1585238342070-61e1e758c068?q=80&w=1965&auto=format&fit=crop"
    ],
    "likes": 1540,
    "commentList": [
      {
        "userName": "Hoàng Thùy Linh",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=30",
        "content": "Nhìn mà thèm nhỏ dãi luôn á trời.",
        "timestamp": "2025-06-15T12:05:00Z",
        "likes": 10
      },
      {
        "userName": "Nguyễn Thanh Tùng",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=31",
        "content": "Quán này là chân ái rồi, không đâu bằng.",
        "timestamp": "2025-06-15T12:10:00Z",
        "likes": 8
      }
    ]
  },
  {
    "id": 4,
    "userName": "Mai Phương Thúy",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=6",
    "location": "Bãi biển Mỹ Khê, Đà Nẵng",
    "timestamp": "2025-06-14T16:45:00Z",
    "content": "Hoàng hôn trên biển không bao giờ làm mình thất vọng. 🌅",
    "imageUrls": [
      "https://images.unsplash.com/photo-1563283248-f144747a1854?q=80&w=1974&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1620921495010-9c4c700192a0?q=80&w=2070&auto=format&fit=crop"
    ],
    "likes": 2100,
    "commentList": []
  },
  {
    "id": 5,
    "userName": "Đỗ Mỹ Linh",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=7",
    "location": "The Coffee House Signature",
    "timestamp": "2025-06-13T10:20:00Z",
    "content": "Chạy deadline ở một góc quen. Cà phê và sự yên tĩnh là đủ.",
    "imageUrls": [
      "https://images.unsplash.com/photo-1511920183353-3b2c5169ce11?q=80&w=1974&auto=format&fit=crop"
    ],
    "likes": 450,
    "commentList": [
      {
        "userName": "Trần Thu Hà",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=35",
        "content": "Góc này chill quá chị ơi!",
        "timestamp": "2025-06-13T11:00:00Z",
        "likes": 1
      }
    ]
  },
  {
    "id": 6,
    "userName": "Trần Tiểu Vy",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=8",
    "location": "Đỉnh Fansipan, Sapa",
    "timestamp": "2025-06-12T11:00:00Z",
    "content": "Chạm tay vào nóc nhà Đông Dương. Một trải nghiệm không thể nào quên!",
    "imageUrls": [
      "https://images.unsplash.com/photo-1609623696236-d7b24344e21a?q=80&w=1974&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1582223888362-878563467c7e?q=80&w=2070&auto=format&fit=crop"
    ],
    "likes": 3200,
    "commentList": [
      {
        "userName": "Phan Văn Đức",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=41",
        "content": "Ngưỡng mộ quá! Chúc mừng bạn nhé.",
        "timestamp": "2025-06-12T13:30:00Z",
        "likes": 12
      },
      {
        "userName": "Hồ Tấn Tài",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=42",
        "content": "Lần tới phải đi mới được.",
        "timestamp": "2025-06-12T14:00:00Z",
        "likes": 5
      }
    ]
  },
  {
    "id": 7,
    "userName": "Nguyễn Thúc Thùy Tiên",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=9",
    "location": "Phố Cổ Hội An",
    "timestamp": "2025-06-11T20:00:00Z",
    "content": "Hội An về đêm đẹp lung linh huyền ảo. ✨",
    "imageUrls": [
      "https://images.unsplash.com/photo-1559592413-716d00b212f3?q=80&w=1964&auto=format&fit=crop"
    ],
    "likes": 1850,
    "commentList": []
  },
  {
    "id": 8,
    "userName": "Lương Thùy Linh",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=10",
    "location": "Chợ nổi Cái Răng, Cần Thơ",
    "timestamp": "2025-06-10T06:15:00Z",
    "content": "Buổi sáng ở chợ nổi, tấp nập và đầy màu sắc của miền Tây sông nước.",
    "imageUrls": [
      "https://images.unsplash.com/photo-1543385223-44754c6023fb?q=80&w=2070&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1623577742938-510b83321590?q=80&w=1968&auto=format&fit=crop"
    ],
    "likes": 950,
    "commentList": [
      {
        "userName": "Đoàn Văn Hậu",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=50",
        "content": "Thương lắm miền Tây.",
        "timestamp": "2025-06-10T07:00:00Z",
        "likes": 4
      }
    ]
  },
  {
    "id": 9,
    "userName": "Huỳnh Trần Ý Nhi",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=11",
    "location": "Đại Nội Huế",
    "timestamp": "2025-06-09T14:30:00Z",
    "content": "Dạo bước trong kinh thành, cảm nhận dấu ấn thời gian và lịch sử.",
    "imageUrls": [
      "https://images.unsplash.com/photo-1595825223793-197e33528a2a?q=80&w=2070&auto=format&fit=crop"
    ],
    "likes": 1120,
    "commentList": [
      {
        "userName": "Châu Bùi",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=55",
        "content": "Outfit hợp với cảnh quá bạn ơi!",
        "timestamp": "2025-06-09T15:00:00Z",
        "likes": 9
      }
    ]
  },
  {
    "id": 10,
    "userName": "Bùi Quỳnh Hoa",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=12",
    "location": "Landmark 81, Vinhomes Central Park",
    "timestamp": "2025-06-08T21:00:00Z",
    "content": "Sài Gòn không ngủ. View từ trên cao thật sự choáng ngợp.",
    "imageUrls": [
      "https://images.unsplash.com/photo-1583417319047-49174b125868?q=80&w=1964&auto=format&fit=crop"
    ],
    "likes": 2500,
    "commentList": [
      {
        "userName": "Lê Dương Bảo Lâm",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=60",
        "content": "Ở trển có thấy nhà anh không em?",
        "timestamp": "2025-06-08T21:30:00Z",
        "likes": 25
      }
    ]
  },
  {
    "id": 11,
    "userName": "Lê Hoàng Phương",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=13",
    "location": "Bãi Sao, Phú Quốc",
    "timestamp": "2025-06-07T13:00:00Z",
    "content": "Vitamin sea. Nước trong vắt, cát trắng mịn, còn gì bằng! ☀️",
    "imageUrls": [
      "https://images.unsplash.com/photo-1616738223933-3168d3782352?q=80&w=1935&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1627893144639-a7858c673414?q=80&w=2070&auto=format&fit=crop",
      "https://images.unsplash.com/photo-1624025134298-e64e5246714e?q=80&w=2071&auto=format&fit=crop"
    ],
    "likes": 1760,
    "commentList": [
      {
        "userName": "Nguyễn Quang Hải",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=65",
        "content": "Đẹp quá, muốn đi liền luôn.",
        "timestamp": "2025-06-07T14:00:00Z",
        "likes": 7
      }
    ]
  },
  {
    "id": 12,
    "userName": "Ngô Thanh Vân",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=15",
    "location": "Hồ Con Rùa",
    "timestamp": "2025-06-18T18:45:00Z",
    "content": "Hồ Con Rùa chiều nay đẹp lạ kỳ. Gió nhẹ, nhạc du dương từ quán trà sữa ven hồ, quá hợp để chill. 🌆🧋",
    "imageUrls": [
      "https://saigonreview.vn/wp-content/uploads/2023/08/ho-con-rua.jpg",
      "https://saigonreview.vn/wp-content/uploads/2023/08/ho-con-rua-1.jpg",
      "https://saigonreview.vn/wp-content/uploads/2023/08/ho-con-rua-3.jpg",
      "https://saigonreview.vn/wp-content/uploads/2023/08/ho-con-rua-4.jpg"
    ],
    "likes": 1245,
    "commentList": [
      {
        "userName": "Bảo Anh",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=26",
        "content": "View này chill thật, mai phải ra làm bộ ảnh mới được!",
        "timestamp": "2025-06-18T19:00:00Z",
        "likes": 8
      },
      {
        "userName": "Trúc Nhân",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=27",
        "content": "Ủa hồi chiều tui cũng ở đó mà không thấy bà ta?",
        "timestamp": "2025-06-18T19:05:00Z",
        "likes": 3
      }
    ]
  },
  {
    "id": 13,
    "userName": "Trần Mỹ Ngọc",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=18",
    "location": "Hồ Con Rùa",
    "timestamp": "2025-06-20T17:20:00Z",
    "content": "Hôm nay trời nhiều mây nhưng hồ vẫn đẹp nhẹ nhàng. Lúc ngồi đọc sách mà nghe tiếng nước róc rách bên dưới, cảm giác thư thái ghê. 📖☁️",
    "imageUrls": [
      "https://saigonreview.vn/wp-content/uploads/2023/08/ho-con-rua-2.jpg"
    ],
    "likes": 860,
    "commentList": [
      {
        "userName": "Đặng Trần Tùng",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=33",
        "content": "Đọc gì đó chị? Recommend cuốn nào đi!",
        "timestamp": "2025-06-20T18:00:00Z",
        "likes": 2
      }
    ]
  },
  {
    "id": 14,
    "userName": "Phạm Quốc Anh",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=23",
    "location": "Hồ Con Rùa",
    "timestamp": "2025-06-19T19:10:00Z",
    "content": "Ghé ngang Hồ Con Rùa buổi tối, đèn vàng phản chiếu mặt nước như tranh vẽ. Chụp vài kiểu ảnh xong là full bộ hình nghệ luôn. 📸✨",
    "imageUrls": [
      "https://saigonreview.vn/wp-content/uploads/2023/08/ho-con-rua-6.jpg",
      "https://saigonreview.vn/wp-content/uploads/2023/08/ho-con-rua-7.jpg"
    ],
    "likes": 1142,
    "commentList": [
      {
        "userName": "Lê Hải Nam",
        "userAvatarUrl": "https://i.pravatar.cc/150?img=39",
        "content": "Cảnh đêm nhìn mộng mị thiệt sự á!",
        "timestamp": "2025-06-19T19:20:00Z",
        "likes": 4
      }
    ]
  },
  {
    "id": 15,
    "userName": "Nguyễn Trúc Lam",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=29",
    "location": "Hồ Con Rùa",
    "timestamp": "2025-06-21T08:15:00Z",
    "content": "Sáng chạy bộ ngang Hồ Con Rùa, dừng lại hít một hơi thật sâu. Thành phố vẫn ồn ào, nhưng ở đây lại có chút yên bình rất riêng. 🏃‍♀️🌳",
    "imageUrls": [
      "https://saigonreview.vn/wp-content/uploads/2023/08/ho-con-rua-5.jpg"
    ],
    "likes": 675,
    "commentList": []
  }
];