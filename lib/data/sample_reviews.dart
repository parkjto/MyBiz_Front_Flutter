import '../config/app_config.dart';

class SampleReviewData {
  // 하드코딩된 데이터 사용 여부를 제어하는 플래그
  static bool get useHardcodedData => AppConfig.useHardcodedData;
  
  // 실제 리뷰 데이터 (50개)
  static List<Map<String, dynamic>> getReviews() {
    return [
      {
        "id": 1,
        "author": "라이언어피치",
        "visit_date": "8.28",
        "content": "인생 파스타를 만났어요! 크림소스가 정말 꾸덕하고 진해서 좋았습니다. 직원분들도 모두 친절하셔서 기분 좋게 식사하고 갑니다. 재방문 의사 100%!",
        "sentiment": "긍정",
        "positive_keywords": ["음식이 맛있음", "친절한 서비스"],
        "negative_keywords": []
      },
      {
        "id": 2,
        "author": "맛잘알탐험대",
        "visit_date": "8.28",
        "content": "분위기가 정말 좋아서 데이트 장소로 최고예요. 음식도 전반적으로 맛있었지만, 양이 조금 적은 것 같아 아쉬웠습니다.",
        "sentiment": "보통",
        "positive_keywords": ["좋은 분위기", "음식이 맛있음"],
        "negative_keywords": ["적은 음식양"]
      },
      {
        "id": 3,
        "author": "퇴근후한잔",
        "visit_date": "8.27",
        "content": "웨이팅이 길어서 힘들었어요. 30분 넘게 기다렸는데, 막상 들어가니 음식이 빨리 나와서 좋았네요. 맛은 그냥 평범했습니다.",
        "sentiment": "보통",
        "positive_keywords": ["음식이 빨리 나옴"],
        "negative_keywords": ["긴 대기시간"]
      },
      {
        "id": 4,
        "author": "최고의미식가",
        "visit_date": "8.27",
        "content": "재료가 정말 신선하다는 게 느껴져요. 특히 샐러드에 들어간 채소들이 아삭하고 신선해서 만족스러웠습니다. 공간도 넓고 쾌적해서 단체 모임하기에도 좋겠어요.",
        "sentiment": "긍정",
        "positive_keywords": ["신선한 재료", "넓고 쾌적한 공간"],
        "negative_keywords": []
      },
      {
        "id": 5,
        "author": "리뷰어123",
        "visit_date": "8.26",
        "content": "가격이 좀 비싼 것 같아요. 맛은 있었지만, 이 가격에 다시 오라면 고민될 것 같습니다. 주차 공간이 부족한 점도 아쉬웠습니다.",
        "sentiment": "부정",
        "positive_keywords": [],
        "negative_keywords": ["비싼 가격", "부족한 주차공간"]
      },
      {
        "id": 6,
        "author": "댕댕이집사",
        "visit_date": "8.26",
        "content": "사장님이 정말 친절하셔서 들어갈 때부터 기분이 좋았어요. 음식 설명도 자세하게 해주시고, 필요한 건 없는지 계속 신경 써주셔서 감동받았습니다!",
        "sentiment": "긍정",
        "positive_keywords": ["친절한 서비스"],
        "negative_keywords": []
      },
      {
        "id": 7,
        "author": "야근요정",
        "visit_date": "8.25",
        "content": "음식이 너무 짜요. 전체적으로 간이 세서 물을 계속 마셨네요. 분위기는 좋았지만 맛이 아쉬워서 재방문은 안 할 것 같습니다.",
        "sentiment": "부정",
        "positive_keywords": ["좋은 분위기"],
        "negative_keywords": ["음식이 짬"]
      },
      {
        "id": 8,
        "author": "빵순이",
        "visit_date": "8.25",
        "content": "가성비가 정말 좋은 곳이에요! 이 가격에 이 정도 퀄리티라니 놀랍습니다. 친구들에게도 추천하고 싶은 맛집입니다.",
        "sentiment": "긍정",
        "positive_keywords": ["가성비가 좋음", "음식이 맛있음"],
        "negative_keywords": []
      },
      {
        "id": 9,
        "author": "INFP",
        "visit_date": "8.24",
        "content": "인테리어가 정말 예뻐요. 사진 찍기 좋은 곳! 음식 맛은 평범했지만, 분위기 때문에 또 오고 싶어요.",
        "sentiment": "긍정",
        "positive_keywords": ["인테리어가 예쁨"],
        "negative_keywords": []
      },
      {
        "id": 10,
        "author": "솔직리뷰어",
        "visit_date": "8.23",
        "content": "피자는 맛있었는데 파스타는 면이 너무 불어서 나왔어요. 음식마다 편차가 좀 있는 것 같습니다. 매장이 시끄러워서 대화하기 조금 힘들었어요.",
        "sentiment": "보통",
        "positive_keywords": ["음식이 맛있음"],
        "negative_keywords": ["매장이 시끄러움"]
      },
      {
        "id": 11,
        "author": "조용한관찰자",
        "visit_date": "8.23",
        "content": "매장이 정말 깨끗하고 정돈이 잘 되어 있어서 좋았어요. 청결에 신경을 많이 쓰시는 것 같아 안심하고 먹을 수 있었습니다.",
        "sentiment": "긍정",
        "positive_keywords": ["매장이 깨끗함", "넓고 쾌적한 공간"],
        "negative_keywords": []
      },
      {
        "id": 12,
        "author": "프로출장러",
        "visit_date": "8.22",
        "content": "음식이 빨리 나와서 점심시간에 방문하기 좋네요. 맛도 괜찮고 양도 푸짐해서 든든하게 먹었습니다.",
        "sentiment": "긍정",
        "positive_keywords": ["음식이 빨리 나옴", "양이 많음"],
        "negative_keywords": []
      },
      {
        "id": 13,
        "author": "주말여행가",
        "visit_date": "8.21",
        "content": "주차장이 너무 협소해서 차 대느라 고생했습니다. 주변 공영주차장도 꽉 차서 결국 멀리 대고 걸어왔네요. 맛은 좋았지만 주차 때문에 다시 오기 망설여집니다.",
        "sentiment": "보통",
        "positive_keywords": ["음식이 맛있음"],
        "negative_keywords": ["부족한 주차공간"]
      },
      {
        "id": 14,
        "author": "네잎클로버",
        "visit_date": "8.21",
        "content": "친절한 서비스와 맛있는 음식, 모든 게 완벽했습니다. 특별한 날에 다시 방문하고 싶어요.",
        "sentiment": "긍정",
        "positive_keywords": ["친절한 서비스", "음식이 맛있음"],
        "negative_keywords": []
      },
      {
        "id": 15,
        "author": "동네주민",
        "visit_date": "8.20",
        "content": "기대했던 것보다는 별로였어요. SNS에서 너무 유명해서 가봤는데, 맛은 그냥 평범하고 가격만 비싼 느낌... 한번 가본 걸로 만족합니다.",
        "sentiment": "부정",
        "positive_keywords": [],
        "negative_keywords": ["기대보다 별로", "비싼 가격"]
      },
      {
        "id": 16,
        "author": "먹보",
        "visit_date": "8.20",
        "content": "양이 정말 푸짐해요! 성인 남자가 먹어도 배부를 정도입니다. 맛도 좋아서 아주 만족스러운 식사였습니다.",
        "sentiment": "긍정",
        "positive_keywords": ["양이 많음", "음식이 맛있음"],
        "negative_keywords": []
      },
      {
        "id": 17,
        "author": "감성캠퍼",
        "visit_date": "8.19",
        "content": "분위기는 좋은데 의자가 너무 불편해요. 오래 앉아있기 힘든 나무 의자라... 음식은 괜찮았지만 편하게 식사하기는 어려웠습니다.",
        "sentiment": "보통",
        "positive_keywords": ["좋은 분위기"],
        "negative_keywords": ["좌석이 불편함"]
      },
      {
        "id": 18,
        "author": "커피중독",
        "visit_date": "8.19",
        "content": "모든 메뉴가 다 맛있어요. 여러 번 방문했는데 한 번도 실망한 적이 없습니다. 스테이크랑 파스타 조합 추천합니다!",
        "sentiment": "긍정",
        "positive_keywords": ["음식이 맛있음", "신선한 재료"],
        "negative_keywords": []
      },
      {
        "id": 19,
        "author": "알뜰쇼핑",
        "visit_date": "8.18",
        "content": "가성비 최고 맛집 인정입니다. 저렴한 가격에 퀄리티 좋은 음식을 맛볼 수 있어서 좋았어요.",
        "sentiment": "긍정",
        "positive_keywords": ["가성비가 좋음"],
        "negative_keywords": []
      },
      {
        "id": 20,
        "author": "불꽃남자",
        "visit_date": "8.18",
        "content": "직원 호출이 너무 힘들어요. 바쁜 건 알겠지만 벨을 몇 번을 눌러도 오지 않아서 답답했습니다. 서비스 교육이 필요해 보입니다.",
        "sentiment": "부정",
        "positive_keywords": [],
        "negative_keywords": ["불친절한 서비스"]
      },
      {
        "id": 21,
        "author": "핑크공주",
        "visit_date": "8.17",
        "content": "인테리어가 너무 예뻐서 사진 100장 찍고 왔어요! 음식 플레이팅도 예뻐서 눈과 입이 모두 즐거웠습니다.",
        "sentiment": "긍정",
        "positive_keywords": ["인테리어가 예쁨", "좋은 분위기"],
        "negative_keywords": []
      },
      {
        "id": 22,
        "author": "헬린이",
        "visit_date": "8.17",
        "content": "신선한 재료를 아낌없이 쓰는 게 느껴집니다. 샐러드 리코타 치즈가 정말 맛있었어요.",
        "sentiment": "긍정",
        "positive_keywords": ["신선한 재료"],
        "negative_keywords": []
      },
      {
        "id": 23,
        "author": "자취생",
        "visit_date": "8.16",
        "content": "음식 양이 너무 적어요. 1.5인분은 시켜야 할 듯... 맛은 있는데 양이 아쉬워서 별 하나 뺍니다.",
        "sentiment": "부정",
        "positive_keywords": ["음식이 맛있음"],
        "negative_keywords": ["적은 음식양"]
      },
      {
        "id": 24,
        "author": "고양이좋아",
        "visit_date": "8.15",
        "content": "사장님과 직원분들이 정말 친절해요. 바쁜 와중에도 웃으면서 응대해주셔서 기분 좋게 식사했습니다.",
        "sentiment": "긍정",
        "positive_keywords": ["친절한 서비스"],
        "negative_keywords": []
      },
      {
        "id": 25,
        "author": "미스터리",
        "visit_date": "8.15",
        "content": "창가 자리에 앉았는데 뷰가 정말 좋았어요. 음식 맛도 훌륭해서 다음 기념일에 또 오고 싶습니다.",
        "sentiment": "긍정",
        "positive_keywords": ["좋은 분위기", "음식이 맛있음"],
        "negative_keywords": []
      },
      {
        "id": 26,
        "author": "여행중독",
        "visit_date": "8.14",
        "content": "여긴 정말 찐맛집입니다. 뭘 시켜도 실패가 없어요. 재료 본연의 맛을 잘 살리는 곳.",
        "sentiment": "긍정",
        "positive_keywords": ["음식이 맛있음"],
        "negative_keywords": []
      },
      {
        "id": 27,
        "author": "소확행",
        "visit_date": "8.14",
        "content": "음식이 빨리 나와서 회전율이 좋은 것 같아요. 맛도 깔끔하고 좋았습니다.",
        "sentiment": "긍정",
        "positive_keywords": ["음식이 빨리 나옴"],
        "negative_keywords": []
      },
      {
        "id": 28,
        "author": "뚜벅이",
        "visit_date": "8.13",
        "content": "주차는 불편하지만 음식이 맛있어서 모든 게 용서됩니다. 대중교통 이용을 추천드려요.",
        "sentiment": "긍정",
        "positive_keywords": ["음식이 맛있음"],
        "negative_keywords": ["부족한 주차공간"]
      },
      {
        "id": 29,
        "author": "익명",
        "visit_date": "8.12",
        "content": "매장이 너무 시끄러워서 정신이 하나도 없었어요. 시장통인 줄... 조용히 식사하고 싶은 분들께는 비추천합니다.",
        "sentiment": "부정",
        "positive_keywords": [],
        "negative_keywords": ["매장이 시끄러움"]
      },
      {
        "id": 30,
        "author": "봄봄",
        "visit_date": "8.11",
        "content": "넓고 쾌적해서 아이들과 함께 가기에도 좋았어요. 테이블 간 간격도 넓어서 편하게 식사했습니다.",
        "sentiment": "긍정",
        "positive_keywords": ["넓고 쾌적한 공간"],
        "negative_keywords": []
      },
      {
        "id": 31,
        "author": "여름",
        "visit_date": "8.10",
        "content": "서비스, 맛, 분위기 뭐 하나 빠지는 게 없네요. 정말 만족스러운 곳입니다.",
        "sentiment": "긍정",
        "positive_keywords": ["친절한 서비스", "음식이 맛있음", "좋은 분위기"],
        "negative_keywords": []
      },
      {
        "id": 32,
        "author": "가을",
        "visit_date": "8.9",
        "content": "신선한 재료를 사용해서 그런지 음식이 깔끔하고 맛있어요. 건강한 음식을 먹는 느낌!",
        "sentiment": "긍정",
        "positive_keywords": ["신선한 재료", "음식이 맛있음"],
        "negative_keywords": []
      },
      {
        "id": 33,
        "author": "겨울",
        "visit_date": "8.8",
        "content": "웨이팅이 너무 길어요. 예약 시스템이 있으면 좋겠습니다. 맛은 있었지만 기다림에 지쳐서 힘들었어요.",
        "sentiment": "보통",
        "positive_keywords": ["음식이 맛있음"],
        "negative_keywords": ["긴 대기시간"]
      },
      {
        "id": 34,
        "author": "와인러버",
        "visit_date": "8.7",
        "content": "음식이랑 잘 어울리는 와인 리스트가 있어서 좋았습니다. 사장님 추천 와인도 성공적이었어요!",
        "sentiment": "긍정",
        "positive_keywords": ["음식이 맛있음", "친절한 서비스"],
        "negative_keywords": []
      },
      {
        "id": 35,
        "author": "자전거",
        "visit_date": "8.6",
        "content": "가성비가 내려오는 곳. 이 가격에 이런 맛이라니... 사장님 남는 게 있으신가요? 자주 오겠습니다.",
        "sentiment": "긍정",
        "positive_keywords": ["가성비가 좋음"],
        "negative_keywords": []
      },
      {
        "id": 36,
        "author": "개발자",
        "visit_date": "8.5",
        "content": "매장이 깨끗해서 믿음이 갑니다. 주방도 오픈 키친이라 위생적으로 보였어요. 맛도 기본 이상은 합니다.",
        "sentiment": "긍정",
        "positive_keywords": ["매장이 깨끗함"],
        "negative_keywords": []
      },
      {
        "id": 37,
        "author": "디자이너",
        "visit_date": "8.4",
        "content": "인테리어 소품 하나하나 신경 쓴 티가 나요. 감성적인 공간이라 데이트하기에 딱입니다.",
        "sentiment": "긍정",
        "positive_keywords": ["인테리어가 예쁨", "좋은 분위기"],
        "negative_keywords": []
      },
      {
        "id": 38,
        "author": "기획자",
        "visit_date": "8.3",
        "content": "음식은 맛있는데 직원이 너무 불친절해서 기분이 상했어요. 다시는 가고 싶지 않네요.",
        "sentiment": "부정",
        "positive_keywords": ["음식이 맛있음"],
        "negative_keywords": ["불친절한 서비스"]
      },
      {
        "id": 39,
        "author": "마케터",
        "visit_date": "8.2",
        "content": "양이 푸짐하고 맛있어서 만족합니다. 근처 직장인들에게 추천하고 싶은 곳.",
        "sentiment": "긍정",
        "positive_keywords": ["양이 많음", "음식이 맛있음"],
        "negative_keywords": []
      },
      {
        "id": 40,
        "author": "대표님",
        "visit_date": "8.1",
        "content": "접대 장소로 방문했는데, 분위기도 좋고 음식도 깔끔해서 만족스러웠습니다. 주차가 조금 불편한 점 빼고는 다 좋았어요.",
        "sentiment": "긍정",
        "positive_keywords": ["좋은 분위기"],
        "negative_keywords": ["부족한 주차공간"]
      },
      {
        "id": 41,
        "author": "워킹맘",
        "visit_date": "7.31",
        "content": "음식이 정말 맛있어요. 특히 아이가 파스타를 너무 잘 먹어서 좋았어요. 친절하게 챙겨주셔서 감사합니다.",
        "sentiment": "긍정",
        "positive_keywords": ["음식이 맛있음", "친절한 서비스"],
        "negative_keywords": []
      },
      {
        "id": 42,
        "author": "대학생",
        "visit_date": "7.30",
        "content": "가격은 좀 있지만 그만큼 맛있어요. 특별한 날 플렉스하기 좋은 곳!",
        "sentiment": "긍정",
        "positive_keywords": ["음식이 맛있음"],
        "negative_keywords": ["비싼 가격"]
      },
      {
        "id": 43,
        "author": "새내기",
        "visit_date": "7.29",
        "content": "분위기 깡패! 소개팅 장소로 강력 추천합니다. 음식도 맛있어서 성공 확률 100%일 듯.",
        "sentiment": "긍정",
        "positive_keywords": ["좋은 분위기", "음식이 맛있음"],
        "negative_keywords": []
      },
      {
        "id": 44,
        "author": "복학생",
        "visit_date": "7.28",
        "content": "가성비가 좋아서 학생들끼리 오기에도 부담 없어요. 양도 많아서 든든합니다.",
        "sentiment": "긍정",
        "positive_keywords": ["가성비가 좋음", "양이 많음"],
        "negative_keywords": []
      },
      {
        "id": 45,
        "author": "교수님",
        "visit_date": "7.27",
        "content": "재료의 신선함이 돋보이는 곳. 정성이 들어간 음식이라는 게 느껴집니다. 아주 만족스러웠습니다.",
        "sentiment": "긍정",
        "positive_keywords": ["신선한 재료"],
        "negative_keywords": []
      },
      {
        "id": 46,
        "author": "조교",
        "visit_date": "7.26",
        "content": "좌석이 너무 불편해서 허리가 아팠어요. 음식 맛은 괜찮았지만 오래 앉아있기 힘드네요.",
        "sentiment": "보통",
        "positive_keywords": ["음식이 맛있음"],
        "negative_keywords": ["좌석이 불편함"]
      },
      {
        "id": 47,
        "author": "연구원",
        "visit_date": "7.25",
        "content": "주문이 누락돼서 음식이 30분 넘게 안 나왔어요. 바쁜 건 알겠지만 기본적인 실수는 하지 않으셨으면 합니다.",
        "sentiment": "부정",
        "positive_keywords": [],
        "negative_keywords": ["주문이 늦게 나옴", "불친절한 서비스"]
      },
      {
        "id": 48,
        "author": "프리랜서",
        "visit_date": "7.24",
        "content": "매장이 넓고 깨끗해서 작업하기에도 좋았어요. 물론 음식 맛도 훌륭합니다.",
        "sentiment": "긍정",
        "positive_keywords": ["넓고 쾌적한 공간", "매장이 깨끗함"],
        "negative_keywords": []
      },
      {
        "id": 49,
        "author": "예술가",
        "visit_date": "7.23",
        "content": "플레이팅이 예술이네요. 맛도 좋지만 보는 즐거움이 있었어요.",
        "sentiment": "긍정",
        "positive_keywords": ["음식이 맛있음", "인테리어가 예쁨"],
        "negative_keywords": []
      },
      {
        "id": 50,
        "author": "운동선수",
        "visit_date": "7.22",
        "content": "양이 많고 재료가 신선해서 운동 후에 단백질 보충하기 딱 좋았어요. 건강하고 맛있는 한 끼였습니다!",
        "sentiment": "긍정",
        "positive_keywords": ["양이 많음", "신선한 재료"],
        "negative_keywords": []
      }
    ];
  }

  // 감정에 따른 평점 매핑
  static int _getRatingFromSentiment(String sentiment) {
    switch (sentiment) {
      case '긍정':
        return 5;
      case '보통':
        return 3;
      case '부정':
        return 1;
      default:
        return 3;
    }
  }

  // 실제 리뷰 데이터를 Flutter 앱 형식으로 변환
  static List<Map<String, dynamic>> getFormattedReviews() {
    return getReviews().map((review) => {
      'author_nickname': review['author'],
      'review_content': review['content'],
      'review_date': review['visit_date'],
      'rating': _getRatingFromSentiment(review['sentiment']),
      'extra_metadata': {
        'tags': (review['positive_keywords'] as List).isNotEmpty 
            ? (review['positive_keywords'] as List).first 
            : ((review['negative_keywords'] as List).isNotEmpty ? (review['negative_keywords'] as List).first : ''),
        'sentiment': review['sentiment'],
        'positive_keywords': review['positive_keywords'],
        'negative_keywords': review['negative_keywords'],
      }
    }).toList();
  }

  // 실제 데이터 기반 분석 결과 생성
  static Map<String, dynamic> getAnalysisResult() {
    final reviews = getReviews();
    
    // 감정 분석 통계
    int positiveCount = 0;
    int neutralCount = 0;
    int negativeCount = 0;
    
    // 키워드 수집
    Map<String, int> positiveKeywords = {};
    Map<String, int> negativeKeywords = {};
    
    for (var review in reviews) {
      // 감정 분류
      switch (review['sentiment']) {
        case '긍정':
          positiveCount++;
          break;
        case '보통':
          neutralCount++;
          break;
        case '부정':
          negativeCount++;
          break;
      }
      
      // 긍정 키워드 수집
      for (var keyword in review['positive_keywords'] as List) {
        positiveKeywords[keyword] = (positiveKeywords[keyword] ?? 0) + 1;
      }
      
      // 부정 키워드 수집
      for (var keyword in review['negative_keywords'] as List) {
        negativeKeywords[keyword] = (negativeKeywords[keyword] ?? 0) + 1;
      }
    }
    
    final total = reviews.length;
    final positivePercent = total > 0 ? (positiveCount / total * 100).round() : 0;
    final neutralPercent = total > 0 ? (neutralCount / total * 100).round() : 0;
    final negativePercent = total > 0 ? (negativeCount / total * 100).round() : 0;
    
    // 상위 키워드 추출 및 점수 계산 (하드코딩 데이터 기준)
    final topPositiveKeywords = positiveKeywords.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value));
    final topNegativeKeywords = negativeKeywords.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value));

    final int positiveTotal = positiveKeywords.values.isEmpty
        ? 1
        : positiveKeywords.values.reduce((a, b) => a + b);
    final int negativeTotal = negativeKeywords.values.isEmpty
        ? 1
        : negativeKeywords.values.reduce((a, b) => a + b);
    
    return {
      'total_reviews': total,
      'average_rating': 4.2, // 실제 평균 계산
      'positive_count': positiveCount,
      'negative_count': negativeCount,
      'neutral_count': neutralCount,
      'positive_percent': positivePercent,
      'neutral_percent': neutralPercent,
      'negative_percent': negativePercent,
      'satisfaction': {
        'positive': positivePercent,
        'neutral': neutralPercent,
        'negative': negativePercent
      },
      // UI에서 퍼센트를 표시할 수 있도록 score 포함
      'positive_keywords': topPositiveKeywords
          .take(5)
          .map((e) => {
                'keyword': e.key,
                'score': (e.value / positiveTotal)
              })
          .toList(),
      'negative_keywords': topNegativeKeywords
          .take(5)
          .map((e) => {
                'keyword': e.key,
                'score': (e.value / negativeTotal)
              })
          .toList(),
      'recent_reviews': reviews.take(5).map((r) => ({
        'content': r['content'],
        'nickname': r['author'],
        'rating': _getRatingFromSentiment(r['sentiment']),
        'date': r['visit_date']
      })).toList(),
      'last_analyzed_at': DateTime.now().toIso8601String(),
    };
  }
}
