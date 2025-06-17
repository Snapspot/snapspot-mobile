const mockPostData = [
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
    "comments": 300
  },
  {
    "id": 2,
    "userName": "Lê Thị Hạnh",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=5",
    "location": "Công viên Tao Đàn",
    "timestamp": "2025-06-17T13:00:00Z",
    "content":
    "Sáng nay trời trong xanh tuyệt đẹp, mình vừa có buổi picnic ngắn ở công viên. Ai mê thiên nhiên nên thử!",
    "imageUrls": [
      "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
      "https://images.unsplash.com/photo-1503264116251-35a269479413",
      "https://images.unsplash.com/photo-1469474968028-56623f02e42e"
    ],
    "likes": 842,
    "comments": 122
  },
  {
    "id": 3,
    "userName": "Trần Quốc Dũng",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=12",
    "location": "Đồi chè Cầu Đất",
    "timestamp": "2025-06-17T11:45:00Z",
    "content":
    "Không khí ở Đà Lạt thật mát mẻ, đồi chè xanh ngát trải dài đến tận chân trời.",
    "imageUrls": [
      "https://images.unsplash.com/photo-1491553895911-0055eca6402d",
      "https://images.unsplash.com/photo-1586864389483-2b91cdfe0d1c",
      "https://images.unsplash.com/photo-1627645142213-efbda601c760"
    ],
    "likes": 1567,
    "comments": 207
  },
  {
    "id": 4,
    "userName": "Phạm Nhật Minh",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=11",
    "location": "Cầu Vàng Đà Nẵng",
    "timestamp": "2025-06-17T10:20:00Z",
    "content":
    "Lần đầu được chạm tay vào biểu tượng du lịch nổi tiếng. View ở đây không thể chê vào đâu được!",
    "imageUrls": [
      "https://images.unsplash.com/photo-1578898887932-1fbf3e43b5bb",
      "https://images.unsplash.com/photo-1508675801627-066ac4346a24",
      "https://images.unsplash.com/photo-1512453979798-5ea266f8880c"
    ],
    "likes": 2240,
    "comments": 350
  },
  {
    "id": 5,
    "userName": "Hoàng Thị Thu",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=16",
    "location": "Chợ nổi Cái Răng",
    "timestamp": "2025-06-17T08:50:00Z",
    "content":
    "Một buổi sáng nhộn nhịp trên sông, trải nghiệm rất đáng nhớ với các món ăn dân dã.",
    "imageUrls": [
      "https://images.unsplash.com/photo-1519817650390-64a93db511aa",
      "https://images.unsplash.com/photo-1540206395-68808572332f"
    ],
    "likes": 930,
    "comments": 119
  },
  {
    "id": 6,
    "userName": "Lâm Văn Đức",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=20",
    "location": "Phố cổ Hội An",
    "timestamp": "2025-06-17T07:30:00Z",
    "content":
    "Hội An về đêm thật lung linh. Những chiếc đèn lồng tạo cảm giác hoài cổ, rất chill luôn!",
    "imageUrls": [
      "https://images.unsplash.com/photo-1542038784456-1ea8e935640e",
      "https://images.unsplash.com/photo-1584983340040-658a2df7df20",
      "https://images.unsplash.com/photo-1584983373387-1b6a213c84b2"
    ],
    "likes": 1583,
    "comments": 233
  },
  {
    "id": 7,
    "userName": "Ngô Mai Trinh",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=8",
    "location": "Hồ Tuyền Lâm",
    "timestamp": "2025-06-16T19:20:00Z",
    "content":
    "Hoàng hôn phản chiếu xuống mặt hồ, một cảnh tượng yên bình đến lạ thường.",
    "imageUrls": [
      "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
      "https://images.unsplash.com/photo-1597262975002-c5c3b14bbd62"
    ],
    "likes": 1278,
    "comments": 198
  },
  {
    "id": 8,
    "userName": "Đặng Văn Phúc",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=7",
    "location": "Núi Bà Đen",
    "timestamp": "2025-06-16T18:00:00Z",
    "content":
    "Leo núi Bà Đen là một trải nghiệm tuyệt vời! Mệt nhưng đáng, ngắm mây bồng bềnh từ đỉnh núi.",
    "imageUrls": [
      "https://images.unsplash.com/photo-1606788075761-6cda5fbb7891",
      "https://images.unsplash.com/photo-1561489423-792d5ed6a6b3"
    ],
    "likes": 1990,
    "comments": 312
  },
  {
    "id": 9,
    "userName": "Võ Thị Huyền",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=13",
    "location": "Biển Mỹ Khê",
    "timestamp": "2025-06-16T17:10:00Z",
    "content":
    "Cát trắng, biển xanh và trời nắng vàng. Đúng chất mùa hè rồi các bạn ơi! ☀️🌊",
    "imageUrls": [
      "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
      "https://images.unsplash.com/photo-1542281286-9e0a16bb7366"
    ],
    "likes": 1432,
    "comments": 145
  },
  {
    "id": 10,
    "userName": "Lý Anh Khoa",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=15",
    "location": "Thác Datanla",
    "timestamp": "2025-06-16T15:45:00Z",
    "content":
    "Lần đầu đi máng trượt xuyên rừng, cảm giác mạnh mà cảnh đẹp thì miễn chê!",
    "imageUrls": [
      "https://images.unsplash.com/photo-1504198266285-165a4364a582",
      "https://images.unsplash.com/photo-1610391626960-637b0e91b0a4"
    ],
    "likes": 1102,
    "comments": 178
  },
  {
    "id": 11,
    "userName": "Phan Gia Hưng",
    "userAvatarUrl": "https://i.pravatar.cc/150?img=17",
    "location": "Rừng tràm Trà Sư",
    "timestamp": "2025-06-16T14:10:00Z",
    "content":
    "Một chuyến đi nhẹ nhàng giữa thiên nhiên. Đi xuồng qua những hàng tràm thật thi vị.",
    "imageUrls": [
      "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
      "https://images.unsplash.com/photo-1470770903676-69b98201ea1c",
      "https://images.unsplash.com/photo-1504198453319-5ce911bafcde"
    ],
    "likes": 990,
    "comments": 155
  }
];
